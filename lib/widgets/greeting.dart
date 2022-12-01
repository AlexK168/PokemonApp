import 'package:flutter/material.dart';
import 'package:pokemon_app/widgets/pokeball.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Greeting extends StatelessWidget {
  const Greeting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Pokeball(),
        Text(
          AppLocalizations.of(context)!.greeting,
          style: const TextStyle(
            fontSize: 40,
          ),
        )
      ],
    );
  }
}
