import 'package:either_dart/either.dart';
import 'package:pokemon_app/repository/repository.dart';

import '../DTO/pokemon_list.dart';
import '../entities/pokemon_detail.dart';
import '../exceptions.dart';
import '../services/api_services/pokemon_api_service.dart';

// TODO : implement Database actions
class PokemonRepositoryImpl extends PokemonRepository {

  final PokemonApiService _apiService;
  // db service should be here

  PokemonRepositoryImpl(this._apiService);

  Future<Either<Failure, T>> _tryServiceRequest<T>(Future<T> Function() body) async {
    try {
      // if service request is successful - return data
      return Right(await body());
    } on Failure catch(f) {
      // if service request threw error - return it
      return Left(f);
    }
  }

  // pass another parameter to specify fetch db request
  // pass another parameter to specify write db request
  Future<PokemonRepositoryResponse<T>> _fetchRepositoryData<T> (
      Future<T> Function() apiServiceRequest) async {

    List<Failure> errors = [];

    final apiResponse = await _tryServiceRequest<T>(() async {
      return await apiServiceRequest();
    });
    if (apiResponse.isRight) {
      // if request to api is successful
      // save to database here ?
      // ...
      // and return fetched data
      return PokemonRepositoryResponse(apiResponse.right, errors);
    }
    // if api request threw an error
    // add error to error stack
    errors.add(apiResponse.left);

    // try to load data from db
    // add database request here
    // ...

    // assume database request failed
    // then add db error to error stack
    errors.add(Failure.dbError);
    return PokemonRepositoryResponse(null, errors);
  }

  @override
  Future<PokemonRepositoryResponse<PokemonDetail>> getPokemon(String url) async {
    return _fetchRepositoryData<PokemonDetail>(() async {
      return await _apiService.getPokemon(url);
    });
  }

  @override
  Future<PokemonRepositoryResponse<PokemonList>> getPokemonListWithCount({int offset=0, int limit=20}) async {
    return _fetchRepositoryData<PokemonList>(() async {
      return await _apiService.getPokemonListWithCount(offset: offset, limit: limit);
    });
  }
}
