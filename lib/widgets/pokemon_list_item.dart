import 'package:flutter/material.dart';

class PokemonListItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double imageWidth = 65;
  const PokemonListItem({Key? key, required this.title, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: imageWidth,
          height: imageWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.contain
            )
          ),
        ),
        Text(title),
      ],
    );
  }
}
