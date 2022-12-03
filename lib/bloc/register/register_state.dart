import 'package:formz/formz.dart';
import 'package:pokemon_app/formz_models/confirmed_password.dart';

import '../../exceptions.dart';
import '../../formz_models/email.dart';
import '../../formz_models/password.dart';

class RegisterState {
  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FormzStatus status;
  final Failure? error;
  final bool isPasswordVisible;

  RegisterState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzStatus.pure,
    this.error,
    this.isPasswordVisible = false,
  });

  RegisterState copyWith({
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    FormzStatus? status,
    Failure? error,
    bool? isPasswordVisible,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      error: error ?? this.error,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
    );
  }
}