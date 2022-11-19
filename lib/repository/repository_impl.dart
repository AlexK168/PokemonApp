import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_app/DTO/pokemon_list_with_boundaries.dart';
import 'package:pokemon_app/repository/repository.dart';
import 'package:pokemon_app/services/pokemon_db_service.dart';

import '../DTO/pokemon_list.dart';
import '../entities/pokemon_detail.dart';
import '../exceptions.dart';
import '../services/pagination_service.dart';
import '../services/pokemon_api_service.dart';

class PokemonRepositoryImpl extends PokemonRepository {

  late PokemonApiService _apiService;
  late PokemonDbService _dbService;
  late PaginationService _paginationService;

  PokemonRepositoryImpl() {
    _apiService = GetIt.instance<PokemonApiService>();
    _dbService = GetIt.instance<PokemonDbService>();
    _paginationService = GetIt.instance<PaginationService>();
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

  void _scrollPage(bool toPrevPage, bool toNextPage) {
    if (toPrevPage) {
      _paginationService.toPrevPage();
    } else if (toNextPage) {
      _paginationService.toNextPage();
    }
  }

  @override
  Future<PokemonRepositoryResponse<PokemonListWithBoundaries>> getPokemonListWithBoundaries({
    required bool toPrevPage,
    required bool toNextPage
  }) async {
    _scrollPage(toPrevPage, toNextPage);
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
    // get errors from response - if there are no errors - can save to db
    if (response.errors.isEmpty && response.data != null) {
      PokemonList listToSave = response.data ?? PokemonList(pokemonList: [], count: 0);
      _saveDeepListToDb(listToSave);
    }
    if (response.data != null) {
      _paginationService.updateCount(response.data!.count);
    }
    return PokemonRepositoryResponse<PokemonListWithBoundaries>(
      response.data == null ? null:
      PokemonListWithBoundaries(
        pokemonList: response.data!.pokemonList,
        endOfList: _paginationService.endOfList(),
        startOfList: _paginationService.startOfList(),
      ),
      response.errors
    );
  }
}
