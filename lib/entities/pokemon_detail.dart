class PokemonDetail{
  final String? name;
  final String? image;
  final List<String>? types;
  final int? weight;
  final int? height;

  const PokemonDetail({
    required this.name,
    required this.image,
    required this.types,
    required this.weight,
    required this.height,
  });

  static const empty = PokemonDetail(
    name: null,
    image: null,
    types: null,
    weight: null,
    height: null,
  );
}