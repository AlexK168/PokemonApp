import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pokemon_app/repository/repository_impl.dart';
import 'package:pokemon_app/services/pokemon_api_service.dart';
import 'package:pokemon_app/services/pokemon_db_service.dart';
import 'hive_models/hive_pokemon.dart';
import 'pages/pokemon_list_page.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HivePokemonAdapter());
  var box = await Hive.openBox('pokemon_box');
  runApp(
    RepositoryProvider(
      create: (context) => box,
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PokemonRepositoryImpl(
        PokemonApiService(),
        PokemonDbService(RepositoryProvider.of<Box>(context))
      ),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        home: const PokemonListPage(),
      ),
    );
  }
}
