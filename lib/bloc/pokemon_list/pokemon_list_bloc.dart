import 'package:bloc/bloc.dart';
import 'package:pokemon_app/DTO/bloc_pokemon_list.dart';
import 'package:pokemon_app/bloc/pokemon_list/pokemon_list_event.dart';
import 'package:pokemon_app/bloc/pokemon_list/pokemon_list_state.dart';
import 'package:pokemon_app/exceptions.dart';
import 'package:pokemon_app/repository/repository.dart';
import '../../services/mode_controller.dart';
import '../../services/pagination_service.dart';

class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  final PokemonRepository _pokemonRepository;
  final PaginationService _paginationService = PaginationService();
  final ModeController _modeController = ModeController();

  PokemonListBloc(this._pokemonRepository) : super(LoadingState()) {
    on<LoadListEvent>(_onLoadList);
    on<LoadPrevEvent>(_onLoadPrev);
    on<LoadNextEvent>(_onLoadNext);
    on<SwitchFavoritePokemonEvent>(_onFavoritePokemonSwitch);
    on<SwitchFavoriteModeEvent>(_onFavoriteModeSwitch);
  }

  void _emitErrors(Emitter<PokemonListState> emit , List<Failure> errors) {
    for (Failure f in errors) {
      emit(ErrorState(f));
    }
  }

  void _onLoadNext(LoadNextEvent event, Emitter<PokemonListState> emit) {
    _paginationService.toNextPage();
    add(const LoadListEvent());
  }

  void _onLoadPrev(LoadPrevEvent event, Emitter<PokemonListState> emit) {
    _paginationService.toPrevPage();
    add(const LoadListEvent());
  }

  void _onLoadList(LoadListEvent event, Emitter<PokemonListState> emit) async {
    emit(LoadingState());
    final response = _modeController.mode == Mode.showAll ?
    await _pokemonRepository.getPokemonListWithCount(
      limit: _paginationService.limit,
      offset: _paginationService.currentOffset,
    ):
    await _pokemonRepository.getFavoritePokemonListWithCount(
      limit: _paginationService.limit,
      offset: _paginationService.currentOffset,
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
          favoritesActive: _modeController.mode == Mode.showFavoritesOnly
      ));
    } else if (errors.isEmpty) {
      emit(const ErrorState(Failure.unknownError));
    }
  }

  void _onFavoriteModeSwitch(SwitchFavoriteModeEvent event, Emitter<PokemonListState> emit) {
    _modeController.switchMode();
    _paginationService.currentOffset = 0;
    add(const LoadListEvent());
  }

  void _onFavoritePokemonSwitch(SwitchFavoritePokemonEvent event, Emitter<PokemonListState> emit) async {
    emit(LoadingState());
    final response = await _pokemonRepository.switchFavorite(event.url);
    List<Failure> errors = response.errors;
    _emitErrors(emit, errors);
    add(const LoadListEvent());
  }
}
