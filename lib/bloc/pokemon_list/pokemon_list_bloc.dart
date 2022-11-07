import 'package:bloc/bloc.dart';
import 'package:pokemon_app/DTO/pokemon_list.dart';
import 'package:pokemon_app/bloc/pokemon_list/pokemon_list_event.dart';
import 'package:pokemon_app/bloc/pokemon_list/pokemon_list_state.dart';
import 'package:pokemon_app/exceptions.dart';
import 'package:pokemon_app/repository/repository.dart';

class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  final PokemonRepository _pokemonRepository;
  int currentOffset = 0;
  final int limit = 20;
  int count = 0;

  PokemonListBloc(this._pokemonRepository) : super(LoadingState()) {
    on<LoadListEvent>((event, emit) async {
      emit(LoadingState());
      final response = await _pokemonRepository.getPokemonListWithCount(
        offset: currentOffset,
        limit: limit
      );

      List<Failure> errors = response.errors;

      for (Failure f in errors) {
        if (f == Failure.noInternetError) {
          emit(const ErrorState(ErrorState.noInternetError));
        } else if (f == Failure.networkError) {
          emit(const ErrorState(ErrorState.networkError));
        } else if (f == Failure.dbError){
          emit(const ErrorState(ErrorState.dbError));
        } else {
          emit(const ErrorState(ErrorState.unknownError));
        }
      }

      PokemonList? pokemonList = response.data;

      if (pokemonList != null) {
        count = pokemonList.count;
        while(currentOffset >= count && currentOffset > limit) {
            currentOffset -= limit;
        }
        emit(LoadedState(
          pokemonList: pokemonList.pokemonList,
          startOfList: currentOffset <= 0,
          endOfList: currentOffset >= count - limit,
        ));
      }
    });

    on<LoadNextEvent>((event, emit) async {
      if (currentOffset < count - limit) {
        currentOffset += limit;
        add(LoadListEvent());
      }
    });

    on<LoadPrevEvent>((event, emit) async {
      if (currentOffset >= limit) {
        currentOffset -= limit;
        add(LoadListEvent());
      }
    });
  }
}