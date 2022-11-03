import 'package:equatable/equatable.dart';

abstract class PokemonDetailEvent extends Equatable{
  const PokemonDetailEvent();
}

class LoadDetailFromApiEvent extends PokemonDetailEvent {
  final String pokemonDetailUrl;
  @override
  List<Object?> get props => [pokemonDetailUrl];

  const LoadDetailFromApiEvent(this.pokemonDetailUrl);
}

class LoadDetailFromDbEvent extends PokemonDetailEvent {
  @override
  List<Object?> get props => [];
}