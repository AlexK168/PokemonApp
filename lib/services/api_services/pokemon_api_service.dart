import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:pokemon_app/exceptions.dart';
import 'package:pokemon_app/model/pokemon_detail.dart';

import '../../model/pokemon_list.dart';

class PokemonApiService {
  static const String _apiBaseurl = "https://pokeapi.co/api/v2/pokemon/";

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

  Future<PokemonList> getPokemonListWithCount({int offset=0, int limit=20}) async {
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
      return PokemonList.fromJson(json);
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
      return PokemonDetail.fromJson(json);
    });
  }
}