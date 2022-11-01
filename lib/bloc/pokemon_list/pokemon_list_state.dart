import 'package:equatable/equatable.dart';
import 'package:pokemon_app/model/pokemon_list_item.dart';

abstract class PokemonListState extends Equatable {
  const PokemonListState();
}

class LoadingState extends PokemonListState {
  @override
  List<Object> get props => [];
}

class LoadedState extends PokemonListState {
  final List<PokemonListItem> pokemonList;

  const LoadedState(this.pokemonList);

  @override
  List<Object?> get props => [pokemonList];
}

class ErrorState extends PokemonListState {
  static const int unknownError = 1;
  static const int networkError = 2;
  static const int dbError = 3;

  final int errorCode;

  const ErrorState(this.errorCode);

  @override
  List<Object?> get props => [errorCode];
}
