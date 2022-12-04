import 'package:get_it/get_it.dart';
import 'package:pokemon_app/auth_repository/auth_repository.dart';
import 'package:pokemon_app/repository/repository.dart';
import 'package:pokemon_app/repository/repository_impl.dart';
import 'package:pokemon_app/services/favorites_service.dart';
import 'package:pokemon_app/services/pokemon_api_service.dart';
import 'package:pokemon_app/services/pokemon_db_service.dart';

void setupGetIt() {
  GetIt.instance.registerSingleton<PokemonApiService>(const PokemonApiService());
  GetIt.instance.registerSingletonAsync<PokemonDbService>(() async => PokemonDbService()..init());
  GetIt.instance.registerSingletonAsync<FavoritesService>(() async => FavoritesService()..init());
  GetIt.instance.registerSingletonWithDependencies<PokemonRepository>(
    () => PokemonRepositoryImpl(
        apiService: GetIt.instance<PokemonApiService>(),
        dbService: GetIt.instance<PokemonDbService>(),
        favoritesService: GetIt.instance<FavoritesService>()),
    dependsOn: [PokemonDbService, FavoritesService],
  );
  GetIt.instance.registerSingletonAsync<AuthenticationRepository>(
    () async => AuthenticationRepository()..user.first
  );
}