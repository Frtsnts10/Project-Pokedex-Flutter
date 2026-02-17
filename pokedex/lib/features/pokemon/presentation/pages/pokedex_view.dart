import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/features/nav/cubit/nav_cubit.dart';
import 'package:pokedex/features/pokemon/bloc/pokemon_bloc.dart';
import 'package:pokedex/features/pokemon/bloc/pokemon_state.dart';
import 'package:pokedex/features/pokemon/presentation/widgets/pokemon_card.dart';

class PokedexView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonBloc, PokemonState>(
      builder: (context, state) {
        if (state is PokemonLoadInProgress) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PokemonPageLoadSuccess) {
          return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 2;
              if (constraints.maxWidth > 1100) {
                crossAxisCount = 5;
              } else if (constraints.maxWidth > 800) {
                crossAxisCount = 4;
              } else if (constraints.maxWidth > 450) {
                crossAxisCount = 3;
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: state.pokemonListings.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => BlocProvider.of<NavCubit>(context)
                        .showPokemonDetails(state.pokemonListings[index].id),
                    child: PokemonCard(
                      id: state.pokemonListings[index].id,
                      name: state.pokemonListings[index].name,
                      imageUrl: state.pokemonListings[index].imageUrl,
                    ),
                  );
                },
              );
            },
          );
        } else if (state is PokemonPageLoadFailed) {
          return Center(
            child: Text(state.error.toString()),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
