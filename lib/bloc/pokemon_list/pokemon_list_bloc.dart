import 'package:bloc/bloc.dart';
import 'package:pokemon_app/bloc/pokemon_list/pokemon_list_event.dart';
import 'package:pokemon_app/bloc/pokemon_list/pokemon_list_state.dart';
import 'package:pokemon_app/exceptions.dart';
import 'package:pokemon_app/services/api_services/pokemon_list_service.dart';

class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  final PokemonListService _pokemonListService;

  PokemonListBloc(this._pokemonListService) : super(LoadingState()) {
    on<LoadFromApiEvent>((event, emit) async {
      emit(LoadingState());
      try {
        final pokemonList = await _pokemonListService.getPokemonList();
        emit(LoadedState(pokemonList));
      } on Failure catch(f) {
        if (f == Failure.unknownError) {
          emit(const ErrorState(ErrorState.unknownError));
        } else if (f == Failure.networkError) {
          emit(const ErrorState(ErrorState.networkError));
        } else {
          emit(const ErrorState(ErrorState.dbError));
        }
      }
    });
  }

}