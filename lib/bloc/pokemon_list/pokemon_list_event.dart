abstract class PokemonListEvent{
  const PokemonListEvent();
}

class LoadListEvent extends PokemonListEvent {
  const LoadListEvent();
}

class LoadNextEvent extends PokemonListEvent {
  const LoadNextEvent();
}

class LoadPrevEvent extends PokemonListEvent {
  const LoadPrevEvent();
}

class SwitchFavoriteEvent extends PokemonListEvent {
  final String url;
  final bool isFavoriteActive;
  const SwitchFavoriteEvent(this.url, this.isFavoriteActive);
}