import 'package:pokemon_app/bloc/register/register_state.dart';

import '../../auth_repository/auth_repository.dart';
import '../../exceptions.dart';
import '../../formz_models/confirmed_password.dart';
import '../../formz_models/email.dart';
import '../../formz_models/password.dart';

import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthenticationRepository _authenticationRepository;

  RegisterCubit(this._authenticationRepository) : super(RegisterState());

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([
          email,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    emit(
      state.copyWith(
        password: password,
        confirmedPassword: confirmedPassword,
        status: Formz.validate([
          state.email,
          password,
          confirmedPassword,
        ]),
      ),
    );
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        status: Formz.validate([
          state.email,
          state.password,
          confirmedPassword,
        ]),
      ),
    );
  }

  void togglePasswordVisibility() {
    emit(
      state.copyWith(
        isPasswordVisible: !state.isPasswordVisible,
        status: Formz.validate([
          state.email,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  Future<void> signUp() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.signUp(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));

      await _authenticationRepository.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );

    } on Failure catch (e) {
      emit(
        state.copyWith(
          error: e,
          status: FormzStatus.submissionFailure,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          error: Failure.signUpError,
          status: FormzStatus.submissionFailure
        )
      );
    }
  }
}
