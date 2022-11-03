import 'package:equatable/equatable.dart';

abstract class PokemonListEvent extends Equatable{
  const PokemonListEvent();
}

class LoadListFromApiEvent extends PokemonListEvent {
  @override
  List<Object?> get props => [];
}

class LoadNextFromApiEvent extends PokemonListEvent {
  @override
  List<Object?> get props => [];
}

class LoadPrevFromApiEvent extends PokemonListEvent {
  @override
  List<Object?> get props => [];
}

class LoadListFromDbEvent extends PokemonListEvent {
  @override
  List<Object?> get props => [];
}