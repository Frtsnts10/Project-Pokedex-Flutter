import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/features/favorites/bloc/favorites_cubit.dart';
import 'package:pokedex/features/pokemon/presentation/widgets/pokemon_card.dart';
// We'll need access to the pokemon list to show them.
// For now, we might need to fetch them or rely on the main bloc state if available.
// A simple way is to use the PokemonBloc state if it's preserved.
import 'package:pokedex/features/pokemon/bloc/pokemon_bloc.dart';
import 'package:pokedex/features/pokemon/bloc/pokemon_state.dart';

import 'package:pokedex/features/nav/cubit/nav_cubit.dart'; // For navigation to details

import 'package:pokedex/features/pokemon/data/repositories/pokemon_repository.dart';
import 'package:pokedex/features/pokemon/data/models/pokemon_page.dart';

class FavoritesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FavoritesCubit, Set<int>>(
        builder: (context, favorites) {
          if (favorites.isEmpty) {
            return Center(child: Text('No favorites yet!'));
          }

          return FutureBuilder<List<PokemonListing>>(
            future: _fetchFavoritePokemon(context, favorites),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error loading favorites'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No favorites data found'));
              }

              final favoritePokemon = snapshot.data!;

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
                    padding: const EdgeInsets.all(12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: favoritePokemon.length,
                    itemBuilder: (context, index) {
                      final pokemon = favoritePokemon[index];
                      return GestureDetector(
                        onTap: () => BlocProvider.of<NavCubit>(context)
                            .showPokemonDetails(pokemon.id),
                        child: PokemonCard(
                          id: pokemon.id,
                          name: pokemon.name,
                          imageUrl: pokemon.imageUrl,
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<PokemonListing>> _fetchFavoritePokemon(
      BuildContext context, Set<int> ids) async {
    final repository =
        PokemonRepository(); // Should ideally come from DI/RepositoryProvider
    final List<PokemonListing> pokemonList = [];

    // Optimization: Check if we have them in the PokemonBloc state
    final pokemonBlocState = BlocProvider.of<PokemonBloc>(context).state;
    List<PokemonListing> cachedPokemon = [];
    if (pokemonBlocState is PokemonPageLoadSuccess) {
      cachedPokemon = pokemonBlocState.pokemonListings;
    }

    for (final id in ids) {
      try {
        // Try to find in cache first
        final cached = cachedPokemon.firstWhere(
          (p) => p.id == id,
          orElse: () => PokemonListing(id: -1, name: ''),
        );

        if (cached.id != -1) {
          pokemonList.add(cached);
        } else {
          // Fetch from API
          final info = await repository.getPokemonInfo(id);
          pokemonList.add(PokemonListing(id: info.id, name: info.name));
        }
      } catch (e) {
        print('Error fetching pokemon $id: $e');
      }
    }
    return pokemonList;
  }
}
