import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:pokemon_app/bloc/login/login_cubit.dart';
import 'package:pokemon_app/bloc/login/login_state.dart';
import 'package:pokemon_app/exceptions.dart';
import 'package:pokemon_app/utils/get_failure_message.dart';
import 'package:pokemon_app/utils/get_validation_error_message.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pokemon_app/utils/show_snackbar.dart';
import 'package:pokemon_app/widgets/greeting.dart';

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
              const Greeting(),
              const SizedBox(height: 20),
              _EmailInput(),
              const SizedBox(height: 8),
              _PasswordInput(),
              const SizedBox(height: 8),
              _LoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            labelText: AppLocalizations.of(context)!.email,
            errorText: state.email.invalid
              ? AppLocalizations.of(context)!.invalidEmailErrorMsg
              : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
        previous.password != current.password || previous.isPasswordVisible != current.isPasswordVisible,
      builder: (context, state) {
        return TextField(
          onChanged: (password) =>
            context.read<LoginCubit>().passwordChanged(password),
          obscureText: !state.isPasswordVisible,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
                icon: state.isPasswordVisible
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
                onPressed: () => context.read<LoginCubit>().togglePasswordVisibility()
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            labelText: AppLocalizations.of(context)!.password,
            errorText: state.password.invalid
              ? getPasswordErrorMessage(context, state.password.error)
              : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
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


