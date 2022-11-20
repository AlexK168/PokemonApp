import 'package:pokemon_app/entities/pokemon_detail.dart';

abstract class PokemonDetailState{
  const PokemonDetailState();
}

class LoadingState extends PokemonDetailState {}

class LoadedState extends PokemonDetailState {
  final PokemonDetail pokemonDetail;

  const LoadedState(this.pokemonDetail);
}

enum PokemonDetailErrorCode {
  unknownError,
  networkError,
  noInternetError,
  dbError,
}

class ErrorState extends PokemonDetailState {
  final PokemonDetailErrorCode errorCode;

  const ErrorState(this.errorCode);
}
