import 'package:equatable/equatable.dart';

abstract class PokemonListEvent extends Equatable{
  const PokemonListEvent();
}

class LoadListEvent extends PokemonListEvent {
  final bool toNext;
  final bool toPrev;
  @override
  List<Object?> get props => [toNext, toPrev];

  const LoadListEvent({this.toNext = false, this.toPrev = false});
}

class LoadNextEvent extends PokemonListEvent {
  @override
  List<Object?> get props => [];
}

class LoadPrevEvent extends PokemonListEvent {
  @override
  List<Object?> get props => [];
}