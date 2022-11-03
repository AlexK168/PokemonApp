class PokemonDetail{
  final String name;
  final String image;
  final List<String> types;
  final int weight;
  final int height;

  PokemonDetail({
    required this.name,
    required this.image,
    required this.types,
    required this.weight,
    required this.height});

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    List<dynamic> parsedTypes = json["types"];
    List<String> types = parsedTypes.map((i) => i["type"]["name"] as String).toList();
    return PokemonDetail(
      name: json["forms"][0]["name"],
      image: json["sprites"]["front_default"],
      weight: json["weight"],
      height: json["height"],
      types: types,
    );
  }
}