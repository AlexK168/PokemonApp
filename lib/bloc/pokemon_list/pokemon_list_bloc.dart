import 'package:bloc/bloc.dart';
import 'package:pokemon_app/bloc/pokemon_list/pokemon_list_event.dart';
import 'package:pokemon_app/bloc/pokemon_list/pokemon_list_state.dart';
import 'package:pokemon_app/exceptions.dart';
import 'package:pokemon_app/services/api_services/pokemon_api_service.dart';

class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  final PokemonApiService _pokemonApiService;
  int currentOffset = 0;
  final int limit = 20;
  int count = 0;

  PokemonListBloc(this._pokemonApiService) : super(LoadingState()) {
    on<LoadListFromApiEvent>((event, emit) async {
      emit(LoadingState());
      try {
        // TODO: inverse dependency. BLOC class should NOT depend on low-level service
        final serviceResponse = await _pokemonApiService.getPokemonListWithCount(
          offset: currentOffset,
          limit: limit
        );
        count = serviceResponse.count;
        emit(LoadedState(
          pokemonList: serviceResponse.pokemonList,
          startOfList: currentOffset <= 0,
          endOfList: currentOffset >= count - limit,
        ));
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

    on<LoadNextFromApiEvent>((event, emit) async {
      if (currentOffset < count - limit) {
        currentOffset += limit;
        add(LoadListFromApiEvent());
      }
    });

    on<LoadPrevFromApiEvent>((event, emit) async {
      if (currentOffset >= limit) {
        currentOffset -= limit;
        add(LoadListFromApiEvent());
      }
    });
  }



}