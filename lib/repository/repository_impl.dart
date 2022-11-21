import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_app/DTO/pokemon_list_with_boundaries.dart';
import 'package:pokemon_app/repository/repository.dart';
import 'package:pokemon_app/services/pokemon_db_service.dart';

import '../DTO/pokemon.dart';
import '../DTO/pokemon_list.dart';
import '../DTO/pokemon_list_item.dart';
import '../entities/pokemon_detail.dart';
import '../exceptions.dart';
import '../services/favorites_service.dart';
import '../services/pagination_service.dart';
import '../services/pokemon_api_service.dart';

class PokemonRepositoryImpl extends PokemonRepository {

  late PokemonApiService _apiService;
  late PokemonDbService _dbService;
  late PaginationService _paginationService;
  late FavoritesService _favoritesService;

  PokemonRepositoryImpl() {
    _apiService = GetIt.instance<PokemonApiService>();
    _dbService = GetIt.instance<PokemonDbService>();
    _paginationService = GetIt.instance<PaginationService>();
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
    required Future<T> Function() dbFetchRequest
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

  Future _saveDeepListToDb(PokemonList listToSave) async {
    for (var listItem in listToSave.pokemonList) {
      String detailUrl = listItem.url;
      final response = await _tryServiceRequest(() async {
        return _apiService.getPokemon(detailUrl);
      });
      if (response.isLeft) {
        continue;
      }
      PokemonDetail pokemon = response.right;

      _tryServiceRequest(() async {
        return _dbService.savePokemon(detailUrl, pokemon);
      });
    }
  }

  void _saveDataToDb(PokemonRepositoryResponse<PokemonList> response) {
    // get errors from response - if there are no errors - can save to db
    if (response.errors.isEmpty && response.data != null) {
      PokemonList listToSave = response.data ?? PokemonList(pokemonList: [], count: 0);
      _saveDeepListToDb(listToSave);
    }
  }

  void _updatePaginationCounter(PokemonRepositoryResponse<PokemonList> response) {
    if (response.data != null) {
      _paginationService.updateCount(response.data!.count);
    }
  }

  Future<List<PokemonListItem>> _getPokemonListWithFavFlags(PokemonList pokemonList) async {
    List<PokemonListItem> pokemonListWithFavFlag = [];
    for (Pokemon pokemon in pokemonList.pokemonList) {
      var response = await _tryServiceRequest(() => _favoritesService.isFavorite(pokemon.url));
      pokemonListWithFavFlag.add(
        PokemonListItem(
          name: pokemon.name,
          url: pokemon.url,
          isFavorite: response.isRight ? response.right : false
        )
      );
    }
    return pokemonListWithFavFlag;
  }

  @override
  void scrollToNext() {
    _paginationService.toNextPage();
  }

  @override
  void scrollToPrev() {
    _paginationService.toPrevPage();
  }

  @override
  Future<PokemonRepositoryResponse<PokemonListWithBoundaries>> getPokemonListWithBoundaries() async {
    final response = await _fetchRepositoryData<PokemonList>(
      apiFetchServiceRequest: () {
        return _apiService.getPokemonListWithCount(
          offset: _paginationService.currentOffset,
          limit: _paginationService.limit
        );
      },
      dbFetchRequest: () {
        return _dbService.getPokemonListWithCount(
          offset: _paginationService.currentOffset,
          limit: _paginationService.limit
        );
      }
    );
    _saveDataToDb(response);
    _updatePaginationCounter(response);
    PokemonList? pokemonList = response.data;
    if (pokemonList == null) {
      return PokemonRepositoryResponse<PokemonListWithBoundaries>(null, response.errors);
    }

    List<PokemonListItem> pokemonListWithFavFlags = await _getPokemonListWithFavFlags(pokemonList);

    return PokemonRepositoryResponse<PokemonListWithBoundaries>(
      PokemonListWithBoundaries(
        pokemonList: pokemonListWithFavFlags,
        endOfList: _paginationService.endOfList(),
        startOfList: _paginationService.startOfList(),
      ),
      response.errors
    );
  }

  @override
  Future<PokemonRepositoryResponse<bool>> switchFavorite(String url) async {
    var response = await _tryServiceRequest(() => _favoritesService.isFavorite(url));
    if (response.isLeft) {
      return PokemonRepositoryResponse(null, [response.left]);
    }
    bool isFavorite = response.right;
    var actionResponse = isFavorite ?
      await _tryServiceRequest(() => _favoritesService.removeFromFavorites(url)):
      await _tryServiceRequest(() => _favoritesService.addToFavorites(url));
    if (actionResponse.isRight) {
      return PokemonRepositoryResponse(!isFavorite, []);
    } else {
      return PokemonRepositoryResponse(isFavorite, [actionResponse.left]);
    }
  }
}
