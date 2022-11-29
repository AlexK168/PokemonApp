import 'package:pokemon_app/entities/pokemon_detail.dart';

import '../../exceptions.dart';

abstract class PokemonDetailState{
  const PokemonDetailState();
}

class LoadingState extends PokemonDetailState {}

class LoadedState extends PokemonDetailState {
  final PokemonDetail pokemonDetail;

  const LoadedState(this.pokemonDetail);
}

class ErrorState extends PokemonDetailState {
  final Failure error;

  const ErrorState(this.error);
}
