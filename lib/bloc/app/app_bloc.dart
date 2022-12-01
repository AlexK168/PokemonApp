import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pokemon_app/bloc/app/app_state.dart';
import '../../auth_repository/auth_repository.dart';
import '../../entities/user.dart';
import 'app_event.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;

  AppBloc(this._authenticationRepository) : super(
    _authenticationRepository.currentUser.isNotEmpty
      ? AppState.authenticated(_authenticationRepository.currentUser)
      : const AppState.unauthenticated(),
  ) {
    on<UserChangedEvent>(_onUserChanged);
    on<LogoutRequestedEvent>(_onLogoutRequested);
    _subscribeForUserChanges();
  }

  void _subscribeForUserChanges() {
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(UserChangedEvent(user)),
    );
  }

  void _onUserChanged(UserChangedEvent event, Emitter<AppState> emit) {
    emit(
      event.user.isNotEmpty
        ? AppState.authenticated(event.user)
        : const AppState.unauthenticated(),
    );
  }

  void _onLogoutRequested(LogoutRequestedEvent event, Emitter<AppState> emit) async {
    try {
      await _authenticationRepository.logOut();
    } catch (e) {
      // TODO: possible signout error
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
