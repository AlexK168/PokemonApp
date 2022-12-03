import 'package:flutter/material.dart';
import 'package:pokemon_app/widgets/pokeball.dart';

class Greeting extends StatelessWidget {
  final String caption;
  const Greeting({Key? key, required this.caption}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Pokeball(),
        Text(
          caption,
          style: const TextStyle(
            fontSize: 40,
          ),
        )
      ],
    );
  }
}
