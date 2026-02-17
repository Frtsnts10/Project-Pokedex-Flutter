import 'package:pokedex/core/navigation/app_navigator.dart';
import 'package:pokedex/features/pokemon/bloc/pokemon_bloc.dart';
import 'package:pokedex/features/pokemon/bloc/pokemon_details_cubit.dart';
import 'package:pokedex/features/pokemon/bloc/pokemon_event.dart';
import 'package:pokedex/features/nav/cubit/nav_cubit.dart';
import 'package:pokedex/features/nav/cubit/bottom_nav_cubit.dart';
import 'package:pokedex/features/favorites/bloc/favorites_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pokemonDetailsCubit = PokemonDetailsCubit();

    return MaterialApp(
      theme: Theme.of(context)
          .copyWith(primaryColor: Colors.red, hintColor: Colors.redAccent),
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(providers: [
        BlocProvider(
            create: (context) =>
                PokemonBloc()..add(PokemonPageRequest(page: 0))),
        BlocProvider(
            create: (context) =>
                NavCubit(pokemonDetailsCubit: pokemonDetailsCubit)),
        BlocProvider(create: (context) => pokemonDetailsCubit),
        BlocProvider(create: (context) => BottomNavCubit()),
        BlocProvider(create: (context) => FavoritesCubit())
      ], child: AppNavigator()),
    );
  }
}
