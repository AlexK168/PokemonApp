import '../../entities/user.dart';

abstract class AppEvent {
  const AppEvent();
}

class LogoutRequestedEvent extends AppEvent {
  const LogoutRequestedEvent();
}

class UserChangedEvent extends AppEvent {
  const UserChangedEvent(this.user);

  final User user;
}
