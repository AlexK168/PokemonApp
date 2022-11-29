import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_app/bloc/pokemon_detail/pokemon_detail_event.dart';
import 'package:pokemon_app/bloc/pokemon_detail/pokemon_detail_state.dart';
import 'package:pokemon_app/exceptions.dart';
import 'package:pokemon_app/repository/repository.dart';
import '../../entities/pokemon_detail.dart';

class PokemonDetailBloc extends Bloc<PokemonDetailEvent, PokemonDetailState> {
  late PokemonRepository _pokemonRepository;

  PokemonDetailBloc() : super(LoadingState()) {
    _getRepository();
    _registerLoadDetailEvent();
  }

  void _getRepository() {
    _pokemonRepository = GetIt.instance<PokemonRepository>();
  }

  void _registerLoadDetailEvent() {
    on<LoadDetailEvent>((event, emit) async {
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
    });
  }
}