import 'package:pokemon_app/DTO/bloc_pokemon_list.dart';
import '../entities/pokemon_detail.dart';
import '../exceptions.dart';

abstract class PokemonRepository{
  Future<PokemonDetail> getPokemon(String url);
  Future<BlocPokemonList> getPokemonListWithCount({
    required int limit,
    required int offset,
  });
  Future<bool> switchFavorite(String url);

  Future<BlocPokemonList> getFavoritePokemonListWithCount({
    required int limit,
    required int offset,
  });
}

class PokemonRepositoryError<T> {
  final List<Failure> errors;
  final T? data;

  PokemonRepositoryError(this.data, this.errors);
}