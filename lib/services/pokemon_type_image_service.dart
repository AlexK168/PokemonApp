class PokemonTypeImageService {
  static const String _base = "assets/pokemon_types_images/";
  static const String _ext = ".png";
  static const String _noneOfTypes = "none";
  static const List<String> _types = [
    "bug",
    "dark",
    "dragon",
    "electric",
    "fairy",
    "fighting",
    "fire",
    "flying",
    "ghost",
    "grass",
    "ground",
    "ice",
    "normal",
    "poison",
    "psychic",
    "rock",
    "steel",
    "water",
  ];

  static String getTypeImagePath(String type) => _base + (_types.contains(type) ? type : _noneOfTypes) + _ext;
}