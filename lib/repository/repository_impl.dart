import 'dart:async';

import 'package:either_dart/either.dart';
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

class FetchOperationResponse<T> {
  final List<Failure> errors;
  final T? data;

  FetchOperationResponse(this.data, this.errors);

  bool get isInError => errors.isNotEmpty;

  FetchOperationResponse.withoutErrors(T this.data) : errors = [];
  FetchOperationResponse.withoutData(this.errors) : data = null;

  PokemonRepositoryError toPokemonRepositoryError() {
    return PokemonRepositoryError(data, errors);
  }
}

class PokemonRepositoryImpl extends PokemonRepository {
  final PokemonApiService _apiService;
  final PokemonDbService _dbService;
  final FavoritesService _favoritesService;

  PokemonRepositoryImpl({
    required apiService,
    required dbService,
    required favoritesService,
  }) :  _apiService = apiService,
        _dbService = dbService,
        _favoritesService = favoritesService;

  Future<Either<Failure, T>> _tryServiceRequest<T>(Future<T> Function() body) async {
    try {
      return Right(await body());
    } on Failure catch(f) {
      return Left(f);
    } catch (_) {
      return const Left(Failure.unknownError);
    }
  }

  Future<FetchOperationResponse<T>> _fetchRepositoryData<T> ({
    required Future<T> Function() apiFetchServiceRequest,
    required Future<T> Function() dbFetchRequest,
  }) async {
    List<Failure> errors = [];
    final apiResponse = await _tryServiceRequest<T>(() async {
      return apiFetchServiceRequest();
    });
    if (apiResponse.isRight) {
      return FetchOperationResponse.withoutErrors(apiResponse.right);
    }
    // if api request threw an error
    // add error to error stack
    errors.add(apiResponse.left);
    final dbResponse = await _tryServiceRequest<T>(() async {
      return dbFetchRequest();
    });
    if (dbResponse.isRight) {
      return FetchOperationResponse(dbResponse.right, errors);
    }
    // if db request threw an error
    // add error to error stack
    errors.add(dbResponse.left);
    return FetchOperationResponse.withoutData(errors);
  }

  @override
  Future<PokemonDetail> getPokemon(String url) async {
    final fetchResponse = await _fetchRepositoryData<PokemonDetail>(
      apiFetchServiceRequest: () {
        return _apiService.getPokemon(url);
      },
      dbFetchRequest: () {
        return _dbService.getPokemon(url);
      },
    );
    if (fetchResponse.isInError) {
      throw fetchResponse.toPokemonRepositoryError();
    } else {
      return fetchResponse.data ?? PokemonDetail.empty;
    }
  }

  Future<void> _savePokemonsDetailsToDb(FetchOperationResponse<ServicePokemonList> response) async {
    // get errors from response - if there are no errors - can save to db
    final listToSave = response.data;
    if (response.errors.isNotEmpty || listToSave == null) {
      return;
    }
    for (ServicePokemon listItem in listToSave.pokemonList) {
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

  Future<BlocPokemonList> _getBlocPokemonList(ServicePokemonList pokemonList) async {
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
  Future<BlocPokemonList> getPokemonListWithCount({
    required int limit,
    required int offset,
  }) async {
    final fetchResponse = await _fetchRepositoryData<ServicePokemonList>(
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
    final fetchedData = fetchResponse.data;
    if (fetchedData == null) {
      throw fetchResponse.toPokemonRepositoryError();
    }
    unawaited(_savePokemonsDetailsToDb(fetchResponse));
    final pokemonListWithFavFlags = await _getBlocPokemonList(fetchedData);
    if (fetchResponse.isInError) {
      throw PokemonRepositoryError(pokemonListWithFavFlags, fetchResponse.errors);
    }
    return pokemonListWithFavFlags;
  }

  @override
  Future<bool> switchFavorite(String url) async {
    final isFavoriteResponse = await _tryServiceRequest(() => _favoritesService.isFavorite(url));
    if (isFavoriteResponse.isLeft) {
      throw PokemonRepositoryError(null, [isFavoriteResponse.left]);
    }
    bool isFavorite = isFavoriteResponse.right;
    final switchResponse = isFavorite ?
      await _tryServiceRequest(() => _favoritesService.removeFromFavorites(url)):
      await _tryServiceRequest(() => _favoritesService.addToFavorites(url));
    if (switchResponse.isLeft) {
      throw PokemonRepositoryError(isFavorite, [switchResponse.left]);
    }
    return !isFavorite;
  }

  @override
  Future<BlocPokemonList> getFavoritePokemonListWithCount({
    required int limit,
    required int offset,
  }) async {
    // get urls of favorite pokemons
    final favServiceResponse = await _tryServiceRequest(() => _favoritesService.getFavoriteUrlsWithCount(
      offset: offset,
      limit: limit,
    ));
    if (favServiceResponse.isLeft) {
      throw PokemonRepositoryError(null, [favServiceResponse.left]);
    }
    // retrieve each pokemon by url and return list of bloc pokemons
    final List<String> urls = favServiceResponse.right;
    List<BlocPokemon> pokemonList = [];
    Set<Failure> errors = {};
    for (String url in urls) {
      try {
        final pokemon = await getPokemon(url);
        pokemonList.add(
          BlocPokemon(
            name: pokemon.name ?? "unknown",
            url: url,
            isFavorite: true,
          )
        );
      } on PokemonRepositoryError catch (e) {
        for (Failure err in e.errors) {
          errors.add(err);
        }
      }
    }
    if (errors.isNotEmpty) {
      throw PokemonRepositoryError(
        pokemonList,
        errors.toList(),
      );
    }
    return BlocPokemonList(
      pokemonList: pokemonList,
      count: pokemonList.length,
    );
  }
}
