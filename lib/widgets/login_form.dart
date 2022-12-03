import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:pokemon_app/bloc/login/login_cubit.dart';
import 'package:pokemon_app/bloc/login/login_state.dart';
import 'package:pokemon_app/exceptions.dart';
import 'package:pokemon_app/pages/register_page.dart';
import 'package:pokemon_app/utils/get_failure_message.dart';
import 'package:pokemon_app/utils/get_validation_error_message.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pokemon_app/utils/show_snackbar.dart';
import 'package:pokemon_app/widgets/greeting.dart';
import 'package:pokemon_app/widgets/password_form_field.dart';

import 'email_form_field.dart';

class LoginForm extends StatelessWidget {

  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          showSnackBar(context, getErrorMessageFromFailure(
            context, state.error ?? Failure.loginError
          ));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: const Alignment(0, -1/3),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Greeting(caption: AppLocalizations.of(context)!.helloAgain),
              const SizedBox(height: 20),
              const _EmailInput(),
              const SizedBox(height: 8),
              const _PasswordInput(),
              const SizedBox(height: 8),
              const _LoginButton(),
              const SizedBox(height: 8),
              const _RegisterButton(),
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
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return EmailFormField(
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
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
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
        previous.password != current.password || previous.isPasswordVisible != current.isPasswordVisible,
      builder: (context, state) {
        return PasswordFormField(
          onChanged: (password) =>
            context.read<LoginCubit>().passwordChanged(password),
          errorText: state.password.invalid
              ? getPasswordErrorMessage(context, state.password.error)
              : null,
          isObscure: !state.isPasswordVisible,
          onVisibilityToggle: () =>
            context.read<LoginCubit>().togglePasswordVisibility(),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
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
                  ? () => context.read<LoginCubit>().logInWithCredentials()
                  : null,
                child: Text(AppLocalizations.of(context)!.loginCapitalized),
          ),
        );
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.noAccount),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RegisterPage())
            );
          },
          child: Text(AppLocalizations.of(context)!.registerNow)
        ),
      ],
    );
  }
}



