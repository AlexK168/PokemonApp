import 'package:pokemon_app/DTO/pokemon_list_with_boundaries.dart';
import '../entities/pokemon_detail.dart';
import '../exceptions.dart';

abstract class PokemonRepository{
  Future<PokemonRepositoryResponse<PokemonDetail>> getPokemon(String url);
  Future<PokemonRepositoryResponse<PokemonListWithBoundaries>> getPokemonListWithBoundaries({
    required bool toPrevPage,
    required bool toNextPage,
  });
}

class PokemonRepositoryResponse<T> {
  List<Failure> errors;
  T? data;

  PokemonRepositoryResponse(this.data, this.errors);
}