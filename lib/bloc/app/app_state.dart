import '../../entities/user.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
}

class AppState{
  const AppState._({
    required this.status,
    this.user = User.empty,
  });

  const AppState.authenticated(User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AppState.unauthenticated() : this._(status: AuthStatus.unauthenticated);

  final AuthStatus status;
  final User user;
}
