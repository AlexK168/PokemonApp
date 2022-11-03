import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/bloc/pokemon_detail/pokemon_detail_event.dart';
import 'package:pokemon_app/bloc/pokemon_detail/pokemon_detail_state.dart';

import '../bloc/pokemon_detail/pokemon_detail_bloc.dart';
import '../services/api_services/pokemon_api_service.dart';

class PokemonDetailPage extends StatefulWidget {
  final String pokemonDetailUrl;
  const PokemonDetailPage({Key? key, required this.pokemonDetailUrl}) : super(key: key);

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonDetailBloc(
        RepositoryProvider.of<PokemonApiService>(context)
      )..add(LoadDetailFromApiEvent(widget.pokemonDetailUrl)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pokemon detail'),
        ),
        body: BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
          builder: (context, state) {
            if (state is LoadedState) {
              return Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            // TODO: consider network error loading image
                            backgroundImage: NetworkImage(state.pokemonDetail.image),
                            radius: 70,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.pokemonDetail.name,
                            style: const TextStyle(
                              fontSize: 18
                            ),
                          )
                        ],
                      )
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Height: ${state.pokemonDetail.height}",
                                style: const TextStyle(
                                  fontSize: 16
                                ),
                              ),
                              Text(
                                "Weight: ${state.pokemonDetail.weight}",
                                style: const TextStyle(
                                  fontSize: 16
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8,),
                          const Text(
                            'Pokemon types:',
                            style: TextStyle(
                                fontSize: 16
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.pokemonDetail.types.length,
                              itemBuilder: (context, index) => ListTile(
                                title: Text(state.pokemonDetail.types[index]),
                              )
                            )
                          )
                        ],
                      )
                    )
                  ],
                ),
              );
            }
            else if (state is LoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else if (state is ErrorState) {
              return Center(
                child: Text(getErrorString(state)),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  // TODO: ELIMINATE CODE DUPLICATION (Same function in pokemon list page)
  String getErrorString(ErrorState state) {
    switch(state.errorCode) {
      case ErrorState.networkError:
        return "Network error occurred :(";
      case ErrorState.dbError:
        return "Can't load data from cache :(";
      case ErrorState.unknownError:
        return "Some unknown error occurred. Sry :(";
      case ErrorState.noInternetError:
        return "No internet connection.";
    }
    return "Some unknown error occurred. Sry :(";
  }
}
