import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesCubit extends Cubit<Set<int>> {
  FavoritesCubit() : super({});

  void toggleFavorite(int pokemonId) {
    final currentFavorites = Set<int>.from(state);
    if (currentFavorites.contains(pokemonId)) {
      currentFavorites.remove(pokemonId);
    } else {
      currentFavorites.add(pokemonId);
    }
    emit(currentFavorites);
  }
}
