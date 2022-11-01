class PokemonListItem {
  PokemonListItem({
    required this.name,
    required this.url,
  });

  String name;
  String url;

  factory PokemonListItem.fromJson(Map<String, dynamic> json) => PokemonListItem(
    name: json["name"],
    url: json["url"],
  );
}