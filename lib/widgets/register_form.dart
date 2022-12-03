import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:pokemon_app/bloc/register/register_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pokemon_app/widgets/password_form_field.dart';
import '../bloc/register/register_state.dart';
import '../exceptions.dart';
import '../utils/get_failure_message.dart';
import '../utils/get_validation_error_message.dart';
import '../utils/show_snackbar.dart';
import 'email_form_field.dart';
import 'greeting.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          showSnackBar(context, getErrorMessageFromFailure(
            context, state.error ?? Failure.signUpError
          ));
        }
        if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: const Alignment(0, -1/3),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Greeting(caption: AppLocalizations.of(context)!.welcome),
              const SizedBox(height: 20),
              const _EmailInput(),
              const SizedBox(height: 8),
              const _PasswordInput(),
              const SizedBox(height: 8),
              const _PasswordConfirmationInput(),
              const SizedBox(height: 8),
              const _RegisterButton(),
              const _LoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return EmailFormField(
          onChanged: (email) => context
              .read<RegisterCubit>()
              .emailChanged(email),
          errorText: state.email.invalid
            ? AppLocalizations.of(context)!.invalidEmailErrorMsg
            : null,
        );
      },
    );
  }
}


class _PasswordInput extends StatelessWidget {
  const _PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) =>
      previous.password != current.password || previous.isPasswordVisible != current.isPasswordVisible,
      builder: (context, state) {
        return PasswordFormField(
          onChanged: (password) =>
              context.read<RegisterCubit>().passwordChanged(password),
          errorText: state.password.invalid
              ? getPasswordErrorMessage(context, state.password.error)
              : null,
          isObscure: !state.isPasswordVisible,
          onVisibilityToggle: () => context
              .read<RegisterCubit>()
              .togglePasswordVisibility(),
        );
      },
    );
  }
}

class _PasswordConfirmationInput extends StatelessWidget {
  const _PasswordConfirmationInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) =>
        previous.password != current.password ||
        previous.isPasswordVisible != current.isPasswordVisible ||
        previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return PasswordFormField(
          onChanged: (confirmPassword) => context
              .read<RegisterCubit>()
              .confirmedPasswordChanged(confirmPassword),
          errorText: state.confirmedPassword.invalid
            ? AppLocalizations.of(context)!.passwordNotMatching
            : null,
          isObscure: !state.isPasswordVisible,
        );
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return SizedBox(
          height: 40,
          child: state.status.isSubmissionInProgress
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: state.status.isValidated
                    ? () => context.read<RegisterCubit>().signUp()
                    : null,
                child: Text(AppLocalizations.of(context)!.registerCapitalized),
              ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.alreadyHaveAccount),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.login)
        ),
      ],
    );
  }
}


