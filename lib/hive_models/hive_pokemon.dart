import 'package:hive/hive.dart';

part 'hive_pokemon.g.dart';

@HiveType(typeId: 0)
class HivePokemon {
  @HiveField(0)
  String name;

  @HiveField(1)
  int weight;

  @HiveField(2)
  int height;

  @HiveField(3)
  String image;

  @HiveField(4)
  List<String> types;

  HivePokemon({
    required this.name,
    required this.weight,
    required this.height,
    required this.image,
    required this.types});

  @override
  String toString() {
    return name;
  }
}