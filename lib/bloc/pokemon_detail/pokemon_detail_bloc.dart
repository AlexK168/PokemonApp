import 'package:bloc/bloc.dart';
import 'package:pokemon_app/bloc/pokemon_detail/pokemon_detail_event.dart';
import 'package:pokemon_app/bloc/pokemon_detail/pokemon_detail_state.dart';
import 'package:pokemon_app/exceptions.dart';
import 'package:pokemon_app/repository/repository.dart';

class PokemonDetailBloc extends Bloc<PokemonDetailEvent, PokemonDetailState> {
  final PokemonRepository _pokemonRepository;

  PokemonDetailBloc(this._pokemonRepository) : super(LoadingState()) {
    on<LoadDetailEvent>(_onLoadDetail);
  }

  void _onLoadDetail(LoadDetailEvent event, Emitter<PokemonDetailState> emit) async {
    emit(LoadingState());
    try {
      final pokemon = await _pokemonRepository.getPokemon(event.pokemonDetailUrl);
      emit(LoadedState(pokemon));
    } on PokemonRepositoryError catch (e) {
      List<Failure> errors = e.errors;
      for (Failure f in errors) {
        emit(ErrorState(f));
      }
      if (e.data != null) {
        emit(LoadedState(e.data));
      } else if (errors.isEmpty) {
        emit(const ErrorState(Failure.unknownError));
      }
    }
  }
}