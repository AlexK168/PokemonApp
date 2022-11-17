import 'package:pokemon_app/DTO/pokemon_list_item.dart';

class PokemonListWithBoundaries{
  final List<PokemonListItem> pokemonList;
  final bool endOfList;
  final bool startOfList;

  PokemonListWithBoundaries({
    required this.pokemonList,
    required this.endOfList,
    required this.startOfList
  });
}