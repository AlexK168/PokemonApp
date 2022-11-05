import '../DTO/pokemon_list.dart';
import '../entities/pokemon_detail.dart';
import '../exceptions.dart';

abstract class PokemonRepository{
  Future<PokemonRepositoryResponse<PokemonDetail>> getPokemon(String url);
  Future<PokemonRepositoryResponse<PokemonList>> getPokemonListWithCount({int offset, int limit});
}

class PokemonRepositoryResponse<T> {
  List<Failure> errors;
  T? data;

  PokemonRepositoryResponse(this.data, this.errors);
}