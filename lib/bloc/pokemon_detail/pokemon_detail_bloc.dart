import 'package:bloc/bloc.dart';
import 'package:pokemon_app/bloc/pokemon_detail/pokemon_detail_event.dart';
import 'package:pokemon_app/bloc/pokemon_detail/pokemon_detail_state.dart';
import 'package:pokemon_app/exceptions.dart';
import 'package:pokemon_app/repository/repository.dart';
import '../../entities/pokemon_detail.dart';

class PokemonDetailBloc extends Bloc<PokemonDetailEvent, PokemonDetailState> {
  final PokemonRepository _pokemonRepository;

  PokemonDetailBloc(this._pokemonRepository) : super(LoadingState()) {
    on<LoadDetailEvent>(_onLoadDetail);
  }

  void _onLoadDetail(LoadDetailEvent event, Emitter<PokemonDetailState> emit) async {
    emit(LoadingState());
    final response = await _pokemonRepository.getPokemon(event.pokemonDetailUrl);
    List<Failure> errors = response.errors;

    for (Failure f in errors) {
      emit(ErrorState(f));
    }

    PokemonDetail? pokemon = response.data;
    if (pokemon != null) {
      emit(LoadedState(pokemon));
    } else if (errors.isEmpty) {
      emit(const ErrorState(Failure.unknownError));
    }
  }
}