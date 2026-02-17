// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:pokedex/features/nav/presentation/pages/home_view.dart';
import 'package:pokedex/features/pokemon/presentation/pages/pokemon_details_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/features/nav/cubit/nav_cubit.dart';

class AppNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavCubit, int>(builder: (context, pokemonId) {
      return Navigator(
        pages: [
          MaterialPage(child: HomeView()),
          if (pokemonId != null && pokemonId != 0)
            MaterialPage(child: PokemonDetailsView())
        ],
        onPopPage: (route, result) {
          BlocProvider.of<NavCubit>(context).popToPokedex();
          return route.didPop(result);
        },
      );
    });
  }
}
