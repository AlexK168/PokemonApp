import 'package:pokemon_app/entities/pokemon_detail.dart';
import '../DTO/pokemon_list.dart';

abstract class PokemonService{
  Future<PokemonDetail> getPokemon(String url);
  Future<PokemonList> getPokemonListWithCount({int offset, int limit});
}