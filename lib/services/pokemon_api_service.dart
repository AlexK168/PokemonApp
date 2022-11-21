import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:pokemon_app/exceptions.dart';
import 'package:pokemon_app/entities/pokemon_detail.dart';

import '../DTO/service_pokemon.dart';
import '../DTO/service_pokemon_list.dart';


class PokemonApiService{
  static const String _apiBaseurl = "https://pokeapi.co/api/v2/pokemon/";

  const PokemonApiService();

  Future<R> _tryRequest<R>(Future<R> Function() body) async {
    try {
      return await body();
    } on SocketException {
      throw Failure.noInternetError;
    } on HttpException {
      throw Failure.networkError;
    } on FormatException {
      throw Failure.unknownError;
    } on TimeoutException {
      throw Failure.networkError;
    }
    catch(e) {
      throw Failure.unknownError;
    }
  }

  PokemonDetail _getPokemonDetailFromJson(Map<String, dynamic> json) {
    List<dynamic> parsedTypes = json["types"];
    List<String> types = parsedTypes.map((i) => i["type"]["name"] as String).toList();
    return PokemonDetail(
      name: json["name"],
      image: json["sprites"]["front_default"],
      weight: json["weight"],
      height: json["height"],
      types: types,
    );
  }

  ServicePokemon _getPokemonFromJson(Map<String, dynamic> json) => ServicePokemon(
      name: json["name"],
      url: json["url"],
    );

  ServicePokemonList _getPokemonListFromJson(Map<String, dynamic> json) {
    List<dynamic> parsedList = json['results'];
    List<ServicePokemon> pokemonList = parsedList.map(
            (i) => _getPokemonFromJson(i)
    ).toList();
    return ServicePokemonList(
      pokemonList: pokemonList,
      count: json['count']
    );
  }

  Future<ServicePokemonList> getPokemonListWithCount({int offset=0, int limit=20}) async {
    var queryParams = {
      'offset': offset.toString(),
      'limit': limit.toString()
    };
    return _tryRequest(() async {
      final response = await get(
          Uri.parse(_apiBaseurl).replace(queryParameters: queryParams)
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode != 200) {
        throw const HttpException("Status code is not OK");
      }
      var json = jsonDecode(response.body);
      return _getPokemonListFromJson(json);
    });
  }

  Future<PokemonDetail> getPokemon(String detailUrl) async {
    return _tryRequest(() async {
      final response = await get(
          Uri.parse(detailUrl)
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode != 200) {
        throw const HttpException("Status code is not OK");
      }
      var json = jsonDecode(response.body);
      return _getPokemonDetailFromJson(json);
    });
  }
}