import 'package:bloc/bloc.dart';
import 'package:pokemon_app/bloc/pokemon_detail/pokemon_detail_event.dart';
import 'package:pokemon_app/bloc/pokemon_detail/pokemon_detail_state.dart';
import 'package:pokemon_app/exceptions.dart';
import 'package:pokemon_app/repository/repository.dart';

import '../../entities/pokemon_detail.dart';


class PokemonDetailBloc extends Bloc<PokemonDetailEvent, PokemonDetailState> {
  final PokemonRepository _pokemonRepository;

  PokemonDetailBloc(this._pokemonRepository) : super(LoadingState()) {
    on<LoadDetailEvent>((event, emit) async {
      emit(LoadingState());
      final response = await _pokemonRepository.getPokemon(event.pokemonDetailUrl);
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

      PokemonDetail? pokemon = response.data;
      if (pokemon != null) {
        emit(LoadedState(
          pokemon
        ));
      }
    });
  }
}