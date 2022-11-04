import 'package:pokemon_app/model/pokemon_list_item.dart';

// TODO: move this class to another module, coz it is not an entity, but a TDO class
class PokemonList {
  // this field contains list of pokemons
  final List<PokemonListItem> pokemonList;
  // contains the overall count of pokemons provided by API
  // (not good coz this field is present only for API layer)
  final int count;

  PokemonList({required this.pokemonList, required this.count});
}