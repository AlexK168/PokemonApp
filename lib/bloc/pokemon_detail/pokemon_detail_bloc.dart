import 'package:bloc/bloc.dart';
import 'package:pokemon_app/bloc/pokemon_detail/pokemon_detail_event.dart';
import 'package:pokemon_app/bloc/pokemon_detail/pokemon_detail_state.dart';
import 'package:pokemon_app/exceptions.dart';
import 'package:pokemon_app/entities/pokemon_detail.dart';
import 'package:pokemon_app/services/pokemon_service.dart';

class PokemonDetailBloc extends Bloc<PokemonDetailEvent, PokemonDetailState> {
  final PokemonService _pokemonApiService;

  PokemonDetailBloc(this._pokemonApiService) : super(LoadingState()) {
    on<LoadDetailFromApiEvent>((event, emit) async {
      emit(LoadingState());
      try {
        PokemonDetail pokemon = await _pokemonApiService.getPokemon(event.pokemonDetailUrl);
        emit(LoadedState(pokemon));
      } on Failure catch(f) {
        if (f == Failure.unknownError) {
          emit(const ErrorState(ErrorState.unknownError));
        } else if (f == Failure.networkError) {
          emit(const ErrorState(ErrorState.networkError));
        } else if (f == Failure.dbError){
          emit(const ErrorState(ErrorState.dbError));
        } else {
          emit(const ErrorState(ErrorState.noInternetError));
        }
      }
    });
  }
}