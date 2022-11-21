abstract class PokemonListEvent{
  const PokemonListEvent();
}

class LoadListEvent extends PokemonListEvent {
  final bool loadFavorite;
  const LoadListEvent({this.loadFavorite = false});
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