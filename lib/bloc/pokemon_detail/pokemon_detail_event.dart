import 'package:equatable/equatable.dart';

abstract class PokemonDetailEvent extends Equatable{
  const PokemonDetailEvent();
}

class LoadDetailFromApiEvent extends PokemonDetailEvent {
  final int pokemonIndex;
  @override
  List<Object?> get props => [pokemonIndex];

  const LoadDetailFromApiEvent(this.pokemonIndex);
}

class LoadFromDbEvent extends PokemonDetailEvent {
  @override
  List<Object?> get props => [];
}