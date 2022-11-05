import 'package:equatable/equatable.dart';

abstract class PokemonListEvent extends Equatable{
  const PokemonListEvent();
}

class LoadListEvent extends PokemonListEvent {
  @override
  List<Object?> get props => [];
}

class LoadNextEvent extends PokemonListEvent {
  @override
  List<Object?> get props => [];
}

class LoadPrevEvent extends PokemonListEvent {
  @override
  List<Object?> get props => [];
}