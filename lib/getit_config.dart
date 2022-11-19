import 'package:get_it/get_it.dart';
import 'package:pokemon_app/constants.dart';
import 'package:pokemon_app/repository/repository.dart';
import 'package:pokemon_app/repository/repository_impl.dart';
import 'package:pokemon_app/services/pagination_service.dart';
import 'package:pokemon_app/services/pokemon_api_service.dart';
import 'package:pokemon_app/services/pokemon_db_service.dart';

void setupGetIt() {
  GetIt.instance.registerSingleton<PokemonApiService>(const PokemonApiService());
  GetIt.instance.registerSingleton<PaginationService>(PaginationService(limit: itemsOnPokemonListPage));
  GetIt.instance.registerSingletonAsync<PokemonDbService>(() async => PokemonDbService()..init());
  GetIt.instance.registerSingletonWithDependencies<PokemonRepository>(
    () => PokemonRepositoryImpl(),
    dependsOn: [PokemonDbService]
  );
}