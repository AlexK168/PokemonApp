import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:pokemon_app/exceptions.dart';
import 'package:pokemon_app/model/pokemon_list_item.dart';
import 'package:pokemon_app/services/api_services/constants.dart';

class PokemonListService {
  Future<List<PokemonListItem>> getPokemonList() async {
      try {
        final response = await get(
            Uri.parse(apiBaseurl)
        ).timeout(const Duration(seconds: 5));
        List<dynamic> parsedJson = jsonDecode(response.body)['results'];
        List<PokemonListItem> pokemonList = parsedJson.map(
          (i) => PokemonListItem.fromJson(i)
        ).toList();
        return pokemonList;
      } on SocketException {
        throw Failure.networkError;
      } on HttpException {
        throw Failure.networkError;
      } on FormatException {
        throw Failure.networkError;
      } on TimeoutException {
        throw Failure.networkError;
      } catch(e) {
        throw Failure.unknownError;
      }
  }
}