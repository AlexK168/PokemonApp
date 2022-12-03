import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_app/bloc/register/register_cubit.dart';
import 'package:pokemon_app/widgets/register_form.dart';

import '../auth_repository/auth_repository.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocProvider(
            create: (_) => RegisterCubit(
              GetIt.instance<AuthenticationRepository>(),
            ),
            child: const RegisterForm(),
          ),
        ),
      ),
    );
  }
}
