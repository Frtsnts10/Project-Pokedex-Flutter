import 'package:pokedex/features/pokemon/data/models/pokemon_details.dart';
import 'package:pokedex/features/pokemon/data/models/pokemon_info.dart';
import 'package:pokedex/features/pokemon/data/repositories/pokemon_repository.dart';
import 'package:pokedex/features/pokemon/data/models/pokemon_species.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class PokemonDetailsCubit extends Cubit<PokemonDetails?> {
  final _pokemonRepository = PokemonRepository();

  PokemonDetailsCubit() : super(null);

  void getPokemonDetails(int pokemonId) async {
    final responses = await Future.wait([
      _pokemonRepository.getPokemonInfo(pokemonId),
      _pokemonRepository.getPokemonSpeciesInfo(pokemonId)
    ]);

    final pokemonInfo = responses[0] as PokemonInfoResponse;
    final speciesInfo = responses[1] as PokemonSpeciesInfoResponse;

    emit(PokemonDetails(
        id: pokemonInfo.id,
        name: pokemonInfo.name,
        imageUrl: pokemonInfo.imageUrl,
        types: pokemonInfo.types,
        height: pokemonInfo.height,
        weight: pokemonInfo.weight,
        description: speciesInfo.description));
  }

  void clearPokemonDetails() => emit(null);
}
