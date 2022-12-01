import 'package:flutter/material.dart';
import 'package:pokemon_app/pages/login_page.dart';
import 'package:pokemon_app/pages/pokemon_list_page.dart';

import 'bloc/app/app_state.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AuthStatus state,
  List<Page<dynamic>> pages,
  ){
  switch (state) {
    case AuthStatus.authenticated:
      return [PokemonListPage.page()];
    case AuthStatus.unauthenticated:
      return [LoginPage.page()];
  }
}