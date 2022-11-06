import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/bloc/pokemon_list/pokemon_list_bloc.dart';
import 'package:pokemon_app/bloc/pokemon_list/pokemon_list_event.dart';
import 'package:pokemon_app/bloc/pokemon_list/pokemon_list_state.dart';
import 'package:pokemon_app/pages/pokemon_detail_page.dart';
import 'package:pokemon_app/utils/show_snackbar.dart';

import '../repository/repository_impl.dart';

class PokemonListPage extends StatefulWidget {
  final String title = "Pokemons";
  const PokemonListPage({Key? key}) : super(key: key);

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonListBloc(
        RepositoryProvider.of<PokemonRepositoryImpl>(context)
      )..add(LoadListEvent()),
      child: BlocConsumer<PokemonListBloc, PokemonListState>(
        listener: (context, state) {
          if (state is ErrorState) {
            String errMsg = getErrorString(state);
            showSnackBar(context, errMsg);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              actions: [
                IconButton(
                  onPressed: () async {
                    BlocProvider.of<PokemonListBloc>(context).add(LoadListEvent());
                  },
                  icon: const Icon(Icons.refresh))
              ],
            ),
            body: Builder(
              builder: (context) {
                if (state is LoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else if(state is LoadedState) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemCount: state.pokemonList.length,
                            itemBuilder: ((context, index) => ListTile(
                              title: Text(state.pokemonList[index].name),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => PokemonDetailPage(
                                    pokemonDetailUrl: state.pokemonList[index].url,
                                  )),
                                );
                              },
                            )),
                            separatorBuilder: (context, index) => const Divider(),
                          )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: state.startOfList ? null : () {
                                BlocProvider.of<PokemonListBloc>(context).add(LoadPrevEvent());
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                            IconButton(
                              onPressed: state.endOfList ? null : () {
                                BlocProvider.of<PokemonListBloc>(context).add(LoadNextEvent());
                              },
                              icon: const Icon(Icons.arrow_forward),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }
                else if (state is ErrorState) {
                  return Center(
                    child: Text(getErrorString(state)),
                  );
                }
                return Container();
              }
            ),
          );
        }
      ),
    );
  }

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