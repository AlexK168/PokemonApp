import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_app/DTO/bloc_pokemon_list.dart';
import 'package:pokemon_app/bloc/pokemon_list/pokemon_list_event.dart';
import 'package:pokemon_app/bloc/pokemon_list/pokemon_list_state.dart';
import 'package:pokemon_app/exceptions.dart';
import 'package:pokemon_app/repository/repository.dart';
import '../../services/pagination_service.dart';

class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  late PokemonRepository _pokemonRepository;
  late PaginationService _paginationService;

  PokemonListBloc() : super(LoadingState()) {
    _getDependencies();
    _registerLoadListEvent();
    _registerLoadPrevEvent();
    _registerLoadNextEvent();
    _registerSwitchFavoriteEvent();
  }

  void _getDependencies() {
    _pokemonRepository = GetIt.instance<PokemonRepository>();
    _paginationService = GetIt.instance<PaginationService>();
  }

  void _registerLoadNextEvent() {
    on<LoadNextEvent>((event, emit) async {
      _paginationService.toNextPage();
      add(const LoadListEvent());
    });
  }

  void _registerLoadPrevEvent() {
    on<LoadPrevEvent>((event, emit) async {
      _paginationService.toPrevPage();
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

      add(const LoadListEvent());
    });
  }

  void _registerLoadListEvent() {
    on<LoadListEvent>((event, emit) async {
      emit(LoadingState());

      final response = await _pokemonRepository.getPokemonListWithCount(
        limit: _paginationService.limit,
        offset: _paginationService.currentOffset
      );

      List<Failure> errors = response.errors;
      _emitErrors(emit, errors);

      BlocPokemonList? pokemonList = response.data;

      if (pokemonList != null) {
        _paginationService.updateCount(pokemonList.count);
        emit(LoadedState(
          pokemonList: pokemonList.pokemonList,
          startOfList: _paginationService.startOfList(),
          endOfList: _paginationService.endOfList(),
          favoritesActive: false
        ));
      } else if (errors.isEmpty) {
        emit(const ErrorState(PokemonListPageErrorCode.unknownError));
      }
    });
  }
}