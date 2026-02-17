import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/features/nav/cubit/nav_cubit.dart';
import 'package:pokedex/features/pokemon/data/repositories/pokemon_repository.dart';
import 'package:pokedex/features/pokemon/data/models/pokemon_info.dart';

class PokemonSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final queryText = query.toLowerCase().trim();
    if (queryText.isEmpty) {
      return Center(child: Text('Enter a Pokemon name or ID'));
    }

    // Attempt to fetch pokemon by name or ID
    return FutureBuilder<PokemonInfoResponse>(
      future: PokemonRepository().getPokemonInfo(int.tryParse(queryText) ?? -1),
      // Note: getPokemonInfo currently expects int ID.
      // We need to support name search in repo or handle it here.
      // Since repo only has getPokemonInfo(int), let's see if we can modify repo
      // OR try to parse ID. If query is string, we might need a new repo method
      // or just try to pass the string if the API supports it (PokeAPI does).
      // Let's assume we update repo to accept string or dynamic.
      // Actually, better to check repo first.
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Try to fetch by name if ID failed or if input was string
          // But wait, the repo method gets ID.
          // Let's rely on suggestion for now or a direct lookup UI.
          return Center(
              child:
                  Text('Pokemon "$query" not found.\nTry using ID for now.'));
        } else if (snapshot.hasData) {
          final pokemon = snapshot.data!;
          // Auto-navigate or show details card
          WidgetsBinding.instance.addPostFrameCallback((_) {
            close(context, query);
            BlocProvider.of<NavCubit>(context).showPokemonDetails(pokemon.id);
          });
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(child: Text('No results'));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // We could show recent searches or a list of pokemon from the Bloc
    return Center(child: Text('Search by Pokemon ID (e.g. 1, 25, 150)'));
  }
}
