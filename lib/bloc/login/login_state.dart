import 'package:formz/formz.dart';

import '../../formz_models/email.dart';
import '../../formz_models/password.dart';

class LoginState {
  final Email email;
  final Password password;
  final FormzStatus status;
  final String? errorMessage;
  final bool isPasswordVisible;

  LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
    this.isPasswordVisible = false,
  });

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzStatus? status,
    String? errorMessage,
    bool? isPasswordVisible,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}