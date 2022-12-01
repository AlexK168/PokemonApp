import 'package:formz/formz.dart';

import '../../exceptions.dart';
import '../../formz_models/email.dart';
import '../../formz_models/password.dart';

class LoginState {
  final Email email;
  final Password password;
  final FormzStatus status;
  final Failure? error;
  final bool isPasswordVisible;

  LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.error,
    this.isPasswordVisible = false,
  });

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzStatus? status,
    Failure? error,
    bool? isPasswordVisible,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      error: error ?? this.error,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}