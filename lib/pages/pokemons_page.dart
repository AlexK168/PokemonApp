import 'package:flutter/material.dart';
import 'package:pokemon_app/data.dart';
import 'package:pokemon_app/widgets/pokemon_list_item.dart';

class PokemonsPage extends StatefulWidget {
  final String title = "Pokemons";
  const PokemonsPage({Key? key}) : super(key: key);

  @override
  State<PokemonsPage> createState() => _PokemonsPageState();
}

class _PokemonsPageState extends State<PokemonsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: 20,
                itemBuilder: ((context, index) => PokemonListItem(
                  title: "Pokemon number ${index + 1}",
                  imageUrl: testImageUrl
                )),
                separatorBuilder: (context, index) => const Divider(),
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
