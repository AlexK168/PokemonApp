import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:pokemon_app/exceptions.dart';
import 'package:pokemon_app/model/pokemon_list_item.dart';
import 'package:pokemon_app/services/api_services/constants.dart';

import '../../model/pokemon_list.dart';

class PokemonListService {
  Future<PokemonList> getPokemonListWithCount({int offset=0, int limit=20}) async {
    var queryParams = {
      'offset': offset.toString(),
      'limit': limit.toString()
    };
    try {
      final response = await get(
        Uri.parse(apiBaseurl).replace(queryParameters: queryParams)
      ).timeout(const Duration(seconds: 5));
      int parsedCount = jsonDecode(response.body)['count'];
      List<dynamic> parsedList = jsonDecode(response.body)['results'];
      List<PokemonListItem> pokemonList = parsedList.map(
        (i) => PokemonListItem.fromJson(i)
      ).toList();
      return PokemonList(pokemonList, parsedCount);
    } on SocketException {
      throw Failure.noInternetError;
    } on HttpException {
      throw Failure.networkError;
    } on FormatException {
      throw Failure.networkError;
    } on TimeoutException {
      throw Failure.networkError;
    }
    catch(e) {
      throw Failure.unknownError;
    }
  }
}