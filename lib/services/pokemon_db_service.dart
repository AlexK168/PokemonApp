import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pokemon_app/DTO/service_pokemon_list.dart';
import 'package:pokemon_app/entities/pokemon_detail.dart';
import 'package:pokemon_app/hive_models/hive_pokemon.dart';

import '../DTO/service_pokemon.dart';
import '../exceptions.dart';

class PokemonDbService {
  late final Box _box;
  static const String _pokemonDbBoxName = 'pokemon_box';

  Future init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HivePokemonAdapter());
    _box = await Hive.openBox(_pokemonDbBoxName);
  }

  Future<R> _tryRequest<R>(Future<R> Function() body) async {
    try {
      return await body();
    }
    catch(e) {
      throw Failure.dbError;
    }
  }

  Future savePokemon(url, PokemonDetail pokemon) async {
    return _tryRequest(() async {
      _box.put(url, HivePokemon(
          name: pokemon.name ?? "unknown",
          weight: pokemon.weight ?? 0,
          height: pokemon.height ?? 0,
          image: pokemon.image ?? "",
          types: pokemon.types ?? []
      ));
    });
  }

  Future<PokemonDetail> getPokemon(String url) async {
    return _tryRequest(() async {
      HivePokemon? pokemon = await _box.get(url);
      if (pokemon == null) {
        throw Failure.dbError;
      }
      return PokemonDetail(
        name: pokemon.name,
        image: pokemon.image,
        types: pokemon.types,
        weight: pokemon.weight,
        height: pokemon.height
      );
    });
  }

  Future<ServicePokemonList> getPokemonListWithCount({int offset=0, int limit=20}) async {
    return _tryRequest(() async {
      int count = _box.length;
      int start = offset;
      int finish = offset + limit;
      if (finish > count) {
        finish = count;
      }
      if (start > count) {
        start = count;
      }
      var pokemonMap = _box.toMap().entries.toList().sublist(start, finish);
      List<ServicePokemon> pokemonList = pokemonMap.map(
              (e) => ServicePokemon(name: e.value.toString(), url: e.key)
      ).toList();
      return ServicePokemonList(
        pokemonList: pokemonList,
        count: count
      );
    });
  }
}