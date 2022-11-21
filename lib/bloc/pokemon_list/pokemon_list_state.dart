import 'package:pokemon_app/DTO/bloc_pokemon.dart';

abstract class PokemonListState{
  const PokemonListState();
}

class LoadingState extends PokemonListState {}

class LoadedState extends PokemonListState {
  final List<BlocPokemon> pokemonList;
  final bool startOfList;
  final bool endOfList;
  final bool favoritesActive;

  const LoadedState({
    required this.pokemonList,
    required this.startOfList,
    required this.endOfList,
    required this.favoritesActive,
  });
}

enum PokemonListPageErrorCode {
   unknownError,
   networkError,
   noInternetError,
   dbError,
}

class ErrorState extends PokemonListState {
  final PokemonListPageErrorCode errorCode;

  const ErrorState(this.errorCode);
}
