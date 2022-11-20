abstract class PokemonListEvent{
  const PokemonListEvent();
}

class LoadListEvent extends PokemonListEvent {
  final bool toNext;
  final bool toPrev;

  const LoadListEvent({this.toNext = false, this.toPrev = false});
}

class LoadNextEvent extends PokemonListEvent {}

class LoadPrevEvent extends PokemonListEvent {}