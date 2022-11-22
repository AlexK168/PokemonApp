import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_app/DTO/bloc_pokemon_list.dart';
import 'package:pokemon_app/DTO/service_pokemon_list.dart';
import 'package:pokemon_app/repository/repository.dart';
import 'package:pokemon_app/services/pokemon_db_service.dart';
import '../DTO/bloc_pokemon.dart';
import '../DTO/service_pokemon.dart';
import '../entities/pokemon_detail.dart';
import '../exceptions.dart';
import '../services/favorites_service.dart';
import '../services/pokemon_api_service.dart';

class PokemonRepositoryImpl extends PokemonRepository {

  late PokemonApiService _apiService;
  late PokemonDbService _dbService;
  late FavoritesService _favoritesService;

  PokemonRepositoryImpl() {
    _apiService = GetIt.instance<PokemonApiService>();
    _dbService = GetIt.instance<PokemonDbService>();
    _favoritesService = GetIt.instance<FavoritesService>();
  }

  Future<Either<Failure, T>> _tryServiceRequest<T>(Future<T> Function() body) async {
    try {
      // if service request is successful - return data
      return Right(await body());
    } on Failure catch(f) {
      // if service request threw an error - return it
      return Left(f);
    }
  }

  Future<PokemonRepositoryResponse<T>> _fetchRepositoryData<T> ({
    required Future<T> Function() apiFetchServiceRequest,
    required Future<T> Function() dbFetchRequest,
  }) async {
    List<Failure> errors = [];
    final apiResponse = await _tryServiceRequest<T>(() async {
      return apiFetchServiceRequest();
    });
    if (apiResponse.isRight) {
      return PokemonRepositoryResponse(apiResponse.right, errors);
    }
    // if api request threw an error
    // add error to error stack
    errors.add(apiResponse.left);
    final dbResponse = await _tryServiceRequest<T>(() async {
      return dbFetchRequest();
    });
    if (dbResponse.isRight) {
      return PokemonRepositoryResponse(dbResponse.right, errors);
    }
    // if db request threw an error
    // add error to error stack
    errors.add(dbResponse.left);
    return PokemonRepositoryResponse(null, errors);
  }

  @override
  Future<PokemonRepositoryResponse<PokemonDetail>> getPokemon(String url) {
    return _fetchRepositoryData<PokemonDetail>(
      apiFetchServiceRequest: () {
        return _apiService.getPokemon(url);
      },
      dbFetchRequest: () {
        return _dbService.getPokemon(url);
      },
    );
  }

  Future _saveDeepListToDb(List<ServicePokemon> listToSave) async {
    for (ServicePokemon listItem in listToSave) {
      final String detailUrl = listItem.url;
      final response = await _tryServiceRequest(() async {
        return _apiService.getPokemon(detailUrl);
      });
      if (response.isLeft) {
        continue;
      }
      PokemonDetail pokemon = response.right;
      _tryServiceRequest(() {
        return _dbService.savePokemon(detailUrl, pokemon);
      });
    }
  }

  void _saveDataToDb(PokemonRepositoryResponse<ServicePokemonList> response) {
    // get errors from response - if there are no errors - can save to db
    if (response.errors.isEmpty && response.data != null) {
      final listToSave = response.data ?? ServicePokemonList(pokemonList: [], count: 0);
      _saveDeepListToDb(listToSave.pokemonList);
    }
  }

  Future<BlocPokemonList> _getPokemonListWithFavFlags(ServicePokemonList pokemonList) async {
    List<BlocPokemon> pokemonListWithFavFlag = [];
    for (ServicePokemon pokemon in pokemonList.pokemonList) {
      final response = await _tryServiceRequest(() => _favoritesService.isFavorite(pokemon.url));
      pokemonListWithFavFlag.add(
        BlocPokemon(
          name: pokemon.name,
          url: pokemon.url,
          isFavorite: response.isRight ? response.right : false,
        )
      );
    }
    return BlocPokemonList(
      pokemonList: pokemonListWithFavFlag,
      count: pokemonList.count,
    );
  }

  @override
  Future<PokemonRepositoryResponse<BlocPokemonList>> getPokemonListWithCount({
    required int limit,
    required int offset,
  }) async {
    final response = await _fetchRepositoryData<ServicePokemonList>(
      apiFetchServiceRequest: () {
        return _apiService.getPokemonListWithCount(
          offset: offset,
          limit: limit,
        );
      },
      dbFetchRequest: () {
        return _dbService.getPokemonListWithCount(
          offset: offset,
          limit: limit,
        );
      }
    );
    _saveDataToDb(response);
    final ServicePokemonList? pokemonList = response.data;
    if (pokemonList == null) {
      return PokemonRepositoryResponse<BlocPokemonList>(null, response.errors);
    }
    BlocPokemonList pokemonListWithFavFlags = await _getPokemonListWithFavFlags(pokemonList);
    return PokemonRepositoryResponse<BlocPokemonList>(
      pokemonListWithFavFlags,
      response.errors,
    );
  }

  @override
  Future<PokemonRepositoryResponse<bool>> switchFavorite(String url) async {
    final response = await _tryServiceRequest(() => _favoritesService.isFavorite(url));
    if (response.isLeft) {
      return PokemonRepositoryResponse(null, [response.left]);
    }
    bool isFavorite = response.right;
    final actionResponse = isFavorite ?
      await _tryServiceRequest(() => _favoritesService.removeFromFavorites(url)):
      await _tryServiceRequest(() => _favoritesService.addToFavorites(url));
    if (actionResponse.isRight) {
      return PokemonRepositoryResponse(!isFavorite, []);
    } else {
      return PokemonRepositoryResponse(isFavorite, [actionResponse.left]);
    }
  }

  @override
  Future<PokemonRepositoryResponse<BlocPokemonList>> getFavoritePokemonListWithCount({
    required int limit,
    required int offset,
  }) async {
    final favServiceResponse = await _tryServiceRequest(() => _favoritesService.getFavoriteUrlsWithCount(
      offset: offset,
      limit: limit,
    ));
    if (favServiceResponse.isLeft) {
      return PokemonRepositoryResponse(null, [favServiceResponse.left]);
    }
    final List<String> urls = favServiceResponse.right;
    List<BlocPokemon> pokemonList = [];
    Set<Failure> errors = {};
    for (String url in urls) {
      final response = await _fetchRepositoryData(
        apiFetchServiceRequest: () {
          return _apiService.getPokemon(url);
        },
        dbFetchRequest: () {
          return _dbService.getPokemon(url);
        }
      );
      PokemonDetail? pokemon = response.data;
      if (pokemon != null) {
        pokemonList.add(
          BlocPokemon(
            name: pokemon.name ?? "unknown",
            url: url,
            isFavorite: true,
          )
        );
      } else {
        for (Failure err in response.errors) {
          errors.add(err);
        }
      }
    }
    return PokemonRepositoryResponse<BlocPokemonList>(
      BlocPokemonList(
        pokemonList: pokemonList,
        count: pokemonList.length,
      ),
      errors.toList(),
    );
  }
}
