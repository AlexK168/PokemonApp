import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/bloc/pokemon_detail/pokemon_detail_event.dart';
import 'package:pokemon_app/bloc/pokemon_detail/pokemon_detail_state.dart';
import 'package:pokemon_app/services/pokemon_type_image_service.dart';
import 'package:pokemon_app/utils/get_failure_message.dart';
import 'package:pokemon_app/utils/show_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pokemon_app/widgets/property.dart';
import 'package:pokemon_app/widgets/type.dart';
import '../bloc/pokemon_detail/pokemon_detail_bloc.dart';
import '../widgets/avatar.dart';

class PokemonDetailPage extends StatefulWidget {
  final String pokemonDetailUrl;
  const PokemonDetailPage({Key? key, required this.pokemonDetailUrl}) : super(key: key);

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> with TickerProviderStateMixin{
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  static const int _avatarAnimationDuration = 1300;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _avatarAnimationDuration),
    )..forward();
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuart,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
              showSnackBar(
                context,
                getErrorMessageFromFailure(context, state.error),
              );
            }
          },
          builder: (context, state) {
            if (state is LoadedState) {
              return Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Expanded(
                      child: RotationTransition(
                        turns: _animation,
                        child: ScaleTransition(
                          scale: _animation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Avatar(url: state.pokemonDetail.image ?? ""),
                              const SizedBox(height: 8),
                              Text(
                                state.pokemonDetail.name ?? AppLocalizations.of(context)!.unknown,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 65,
                            child: ListView.separated(
                              separatorBuilder: (_, __) => const SizedBox(width: 8,),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: state.pokemonDetail.types?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) => TypeWidget(
                                imgUrl: PokemonTypeImageService.getTypeImagePath(
                                  state.pokemonDetail.types![index],
                                ),
                                type: state.pokemonDetail.types![index],
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8,),
                          Expanded(
                            child: ListView(
                              children: [
                                Property(
                                  leading: const Icon(Icons.height, size: 40,),
                                  text: "${AppLocalizations.of(context)!.heightWithColon}"
                                    "${state.pokemonDetail.height?.toString() ?? AppLocalizations.of(context)!.unknown}",
                                  textStyle: const TextStyle(
                                    fontSize: 16
                                  ),
                                ),
                                Property(
                                  leading: const Icon(Icons.scale, size: 40,),
                                  text: "${AppLocalizations.of(context)!.weightWithColon}"
                                    "${state.pokemonDetail.weight?.toString() ?? AppLocalizations.of(context)!.unknown}",
                                  textStyle: const TextStyle(
                                    fontSize: 16
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
                child: Text(getErrorMessageFromFailure(context, state.error)),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
