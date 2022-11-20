import 'package:pokemon_app/DTO/pokemon_list_item.dart';

abstract class PokemonListState{
  const PokemonListState();
}

class LoadingState extends PokemonListState {}

class LoadedState extends PokemonListState {
  final List<PokemonListItem> pokemonList;
  final bool startOfList;
  final bool endOfList;

  const LoadedState({required this.pokemonList, required this.startOfList, required this.endOfList});
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
