import 'package:equatable/equatable.dart';

abstract class PokemonDetailEvent extends Equatable{
  const PokemonDetailEvent();
}

class LoadDetailEvent extends PokemonDetailEvent {
  final String pokemonDetailUrl;
  @override
  List<Object?> get props => [pokemonDetailUrl];

  const LoadDetailEvent(this.pokemonDetailUrl);
}

class LoadDetailFromDbEvent extends PokemonDetailEvent {
  @override
  List<Object?> get props => [];
}