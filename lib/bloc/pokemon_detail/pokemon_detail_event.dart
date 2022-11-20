abstract class PokemonDetailEvent{
  const PokemonDetailEvent();
}

class LoadDetailEvent extends PokemonDetailEvent {
  final String pokemonDetailUrl;

  const LoadDetailEvent(this.pokemonDetailUrl);
}