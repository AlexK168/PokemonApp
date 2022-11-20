import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/bloc/pokemon_detail/pokemon_detail_event.dart';
import 'package:pokemon_app/bloc/pokemon_detail/pokemon_detail_state.dart';
import 'package:pokemon_app/utils/show_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bloc/pokemon_detail/pokemon_detail_bloc.dart';
import '../widgets/avatar.dart';

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
      create: (context) => PokemonDetailBloc()..add(LoadDetailEvent(widget.pokemonDetailUrl)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.pokemonDetailTitle),
        ),
        body: BlocConsumer<PokemonDetailBloc, PokemonDetailState>(
          listener: (context, state) {
            if (state is ErrorState) {
              String errMsg = getErrorString(state);
              showSnackBar(context, errMsg);
            }
          },
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
                          Avatar(url: state.pokemonDetail.image ?? ""),
                          const SizedBox(height: 8),
                          Text(
                            state.pokemonDetail.name ?? AppLocalizations.of(context)!.unknown,
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
                              "${AppLocalizations.of(context)!.heightWithColon}"
                              "${state.pokemonDetail.height?.toString() ?? AppLocalizations.of(context)!.unknown}",
                                style: const TextStyle(
                                  fontSize: 16
                                ),
                              ),
                              Text(
                                "${AppLocalizations.of(context)!.weightWithColon}"
                                "${state.pokemonDetail.weight?.toString() ?? AppLocalizations.of(context)!.unknown}",
                                style: const TextStyle(
                                  fontSize: 16
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8,),
                          Text(
                            AppLocalizations.of(context)!.pokemonTypesWithColon,
                            style: const TextStyle(
                                fontSize: 16
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.pokemonDetail.types?.length ?? 0,
                              itemBuilder: (context, index) => ListTile(
                                title: Text(
                                  state.pokemonDetail.types?[index] ?? AppLocalizations.of(context)!.blank
                                ),
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

  String getErrorString(ErrorState state) {
    switch(state.errorCode) {
      case PokemonDetailErrorCode.networkError:
        return AppLocalizations.of(context)!.networkErrorMsg;
      case PokemonDetailErrorCode.dbError:
        return AppLocalizations.of(context)!.cacheErrorMsg;
      case PokemonDetailErrorCode.unknownError:
        return AppLocalizations.of(context)!.unknownErrorMsg;
      case PokemonDetailErrorCode.noInternetError:
        return AppLocalizations.of(context)!.noInternetErrorMsg;
      default:
        return AppLocalizations.of(context)!.unknownErrorMsg;
    }
  }
}
