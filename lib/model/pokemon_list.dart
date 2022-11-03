import 'package:pokemon_app/model/pokemon_list_item.dart';

class PokemonList {
  // this field contains list of pokemons
  final List<PokemonListItem> pokemonList;
  // contains the overall count of pokemons provided by API
  final int count;

  PokemonList({required this.pokemonList, required this.count});

  factory PokemonList.fromJson (Map<String, dynamic> json) {
    List<dynamic> parsedList = json['results'];
    List<PokemonListItem> pokemonList = parsedList.map(
      (i) => PokemonListItem.fromJson(i)
    ).toList();
    return PokemonList(
      pokemonList: pokemonList,
      count: json['count']
    );
  }
}