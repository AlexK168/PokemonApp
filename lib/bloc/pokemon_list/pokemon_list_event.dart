import 'package:equatable/equatable.dart';

abstract class PokemonListEvent extends Equatable{
  const PokemonListEvent();
}

class LoadFromApiEvent extends PokemonListEvent {
  @override
  List<Object?> get props => [];
}

class NoInternetEvent extends PokemonListEvent {
  @override
  List<Object?> get props => [];
}

class LoadFromDbEvent extends PokemonListEvent {
  @override
  List<Object?> get props => [];
}