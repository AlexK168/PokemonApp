import 'package:pokemon_app/model/pokemon_list_item.dart';

class PokemonList {
  // this field contains list of pokemons
  final List<PokemonListItem> pokemonList;
  // contains the overall count of pokemons provided by API
  final int count;

  PokemonList(this.pokemonList, this.count);
}