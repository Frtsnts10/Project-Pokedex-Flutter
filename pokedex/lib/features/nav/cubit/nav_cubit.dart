// ignore_for_file: unused_import

import 'package:pokedex/features/pokemon/bloc/pokemon_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavCubit extends Cubit<int> {
  PokemonDetailsCubit pokemonDetailsCubit;

  NavCubit({required this.pokemonDetailsCubit}) : super(0);

  void showPokemonDetails(int pokemonId) {
    print(pokemonId);
    pokemonDetailsCubit.getPokemonDetails(pokemonId);
    emit(pokemonId);
  }

  void popToPokedex() {
    emit(0);
    pokemonDetailsCubit.clearPokemonDetails();
  }
}
