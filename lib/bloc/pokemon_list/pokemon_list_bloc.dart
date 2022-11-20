import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_app/DTO/pokemon_list_with_boundaries.dart';
import 'package:pokemon_app/bloc/pokemon_list/pokemon_list_event.dart';
import 'package:pokemon_app/bloc/pokemon_list/pokemon_list_state.dart';
import 'package:pokemon_app/exceptions.dart';
import 'package:pokemon_app/repository/repository.dart';

class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  late PokemonRepository _pokemonRepository;

  PokemonListBloc() : super(LoadingState()) {
    _getRepository();
    _registerLoadListEvent();
    _registerLoadPrevEvent();
    _registerLoadNextEvent();
  }

  void _getRepository() {
    _pokemonRepository = GetIt.instance<PokemonRepository>();
  }

  void _registerLoadNextEvent() {
    on<LoadNextEvent>((event, emit) async {
      add(const LoadListEvent(toNext: true));
    });
  }

  void _registerLoadPrevEvent() {
    on<LoadPrevEvent>((event, emit) async {
      add(const LoadListEvent(toPrev: true));
    });
  }

  void _registerLoadListEvent() {
    on<LoadListEvent>((event, emit) async {
      emit(LoadingState());
      final response = await _pokemonRepository.getPokemonListWithBoundaries(
        toPrevPage: event.toPrev,
        toNextPage: event.toNext,
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

      PokemonListWithBoundaries? pokemonList = response.data;

      if (pokemonList != null) {
        emit(LoadedState(
          pokemonList: pokemonList.pokemonList,
          startOfList: pokemonList.startOfList,
          endOfList: pokemonList.endOfList,
        ));
      }
    });
  }
}