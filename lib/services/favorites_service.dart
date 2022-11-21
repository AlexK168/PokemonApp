import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../exceptions.dart';

class FavoritesService{
  late final Box _box;
  static const String _favoritesBoxName = 'favorites_box';

  Future init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_favoritesBoxName);
  }

  Future<R> _tryRequest<R>(Future<R> Function() body) async {
    try {
      return await body();
    }
    catch(e) {
      throw Failure.dbError;
    }
  }

  Future<bool> isFavorite(String url) async {
    return _tryRequest(() async {
      return _box.values.contains(url);
    });
  }

  Future removeFromFavorites(String url) async {
    return _tryRequest(() async {
      var boxValues = _box.values;
      if (boxValues.contains(url)) {
        int index = boxValues.toList().indexOf(url);
        _box.deleteAt(index);
      }
    });
  }

  Future addToFavorites(String url) async {
    return _tryRequest(() async {
      if (!_box.values.contains(url)) {
        _box.add(url);
      }
    });
  }
}