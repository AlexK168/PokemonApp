import 'package:pokemon_app/DTO/pokemon_list_item.dart';

class PokemonList {
  final List<PokemonListItem> pokemonList;
  final int count;

  PokemonList({required this.pokemonList, required this.count});
}