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

class SwitchFavoritePokemonEvent extends PokemonListEvent {
  final String url;
  const SwitchFavoritePokemonEvent(this.url);
}

class SwitchFavoriteModeEvent extends PokemonListEvent {
  const SwitchFavoriteModeEvent();
}