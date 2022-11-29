import 'package:flutter/material.dart';
import 'package:pokemon_app/getit_config.dart';
import 'package:pokemon_app/pages/login_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  setupGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const LoginPage(),
    );
  }
}
