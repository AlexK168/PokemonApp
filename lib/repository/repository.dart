
import 'package:pokemon_app/DTO/bloc_pokemon_list.dart';

import '../entities/pokemon_detail.dart';
import '../exceptions.dart';

abstract class PokemonRepository{
  Future<PokemonRepositoryResponse<PokemonDetail>> getPokemon(String url);
  Future<PokemonRepositoryResponse<BlocPokemonList>> getPokemonListWithCount({
    required int limit,
    required int offset,
  });
  Future<PokemonRepositoryResponse<bool>> switchFavorite(String url);
}

class PokemonRepositoryResponse<T> {
  final List<Failure> errors;
  final T? data;

  PokemonRepositoryResponse(this.data, this.errors);
}