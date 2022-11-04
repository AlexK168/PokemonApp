import 'package:equatable/equatable.dart';
import 'package:pokemon_app/entities/pokemon_list_item.dart';

abstract class PokemonListState extends Equatable {
  const PokemonListState();
}

class LoadingState extends PokemonListState {
  @override
  List<Object> get props => [];
}

class LoadedState extends PokemonListState {
  final List<PokemonListItem> pokemonList;
  final bool startOfList;
  final bool endOfList;

  const LoadedState({required this.pokemonList, required this.startOfList, required this.endOfList});

  @override
  List<Object?> get props => [pokemonList];
}

class ErrorState extends PokemonListState {
  static const int unknownError = 1;
  static const int networkError = 2;
  static const int noInternetError = 3;
  static const int dbError = 4;

  final int errorCode;

  const ErrorState(this.errorCode);

  @override
  List<Object?> get props => [errorCode];
}
