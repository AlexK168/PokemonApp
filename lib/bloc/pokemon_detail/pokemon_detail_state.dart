import 'package:equatable/equatable.dart';
import 'package:pokemon_app/entities/pokemon_detail.dart';

abstract class PokemonDetailState extends Equatable {
  const PokemonDetailState();
}

class LoadingState extends PokemonDetailState {
  @override
  List<Object> get props => [];
}

class LoadedState extends PokemonDetailState {
  final PokemonDetail pokemonDetail;

  const LoadedState(this.pokemonDetail);

  @override
  List<Object?> get props => [pokemonDetail];
}

class ErrorState extends PokemonDetailState {
  static const int unknownError = 1;
  static const int networkError = 2;
  static const int noInternetError = 3;
  static const int dbError = 4;

  final int errorCode;

  const ErrorState(this.errorCode);

  @override
  List<Object?> get props => [errorCode];
}
