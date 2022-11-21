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
    _registerSwitchFavoriteEvent();
  }

  void _getRepository() {
    _pokemonRepository = GetIt.instance<PokemonRepository>();
  }

  void _registerLoadNextEvent() {
    on<LoadNextEvent>((event, emit) async {
      _pokemonRepository.scrollToNext();
      add(const LoadListEvent());
    });
  }

  void _registerLoadPrevEvent() {
    on<LoadPrevEvent>((event, emit) async {
      _pokemonRepository.scrollToPrev();
      add(const LoadListEvent());
    });
  }

  void _emitErrors(Emitter<PokemonListState> emit , List<Failure> errors) {
    for (Failure f in errors) {
      if (f == Failure.noInternetError) {
        emit(const ErrorState(PokemonListPageErrorCode.noInternetError));
      } else if (f == Failure.networkError) {
        emit(const ErrorState(PokemonListPageErrorCode.networkError));
      } else if (f == Failure.dbError){
        emit(const ErrorState(PokemonListPageErrorCode.dbError));
      } else {
        emit(const ErrorState(PokemonListPageErrorCode.unknownError));
      }
    }
  }

  void _registerSwitchFavoriteEvent() {
    on<SwitchFavoriteEvent>((event, emit) async {
      emit(LoadingState());
      final response = await _pokemonRepository.switchFavorite(event.url);

      List<Failure> errors = response.errors;
      _emitErrors(emit, errors);

      add(LoadListEvent(loadFavorite: event.isFavoriteActive));
    });
  }

  void _registerLoadListEvent() {
    on<LoadListEvent>((event, emit) async {
      emit(LoadingState());
      // event.loadFavorite;

      final response = await _pokemonRepository.getPokemonListWithBoundaries();

      List<Failure> errors = response.errors;
      _emitErrors(emit, errors);

      PokemonListWithBoundaries? pokemonList = response.data;

      if (pokemonList != null) {
        emit(LoadedState(
          pokemonList: pokemonList.pokemonList,
          startOfList: pokemonList.startOfList,
          endOfList: pokemonList.endOfList,
          favoritesActive: event.loadFavorite
        ));
      } else if (errors.isEmpty) {
        emit(const ErrorState(PokemonListPageErrorCode.unknownError));
      }
    });
  }
}