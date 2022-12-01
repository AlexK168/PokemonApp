import 'package:flutter/material.dart';

class Pokeball extends StatelessWidget {
  static const String _pokeballImagePath = "assets/images/pokeball.png";
  const Pokeball({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Image.asset(_pokeballImagePath),
    );
  }
}
