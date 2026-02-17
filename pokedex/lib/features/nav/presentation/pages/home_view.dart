import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/features/nav/cubit/bottom_nav_cubit.dart';
import 'package:pokedex/features/pokemon/presentation/pages/pokedex_view.dart';
import 'package:pokedex/features/favorites/presentation/pages/favorites_view.dart';
import 'package:pokedex/shared/widgets/profile_icon.dart';

import 'package:pokedex/features/notifications/presentation/pages/notifications_view.dart';
import 'package:pokedex/features/pokemon/presentation/widgets/pokemon_search_delegate.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(_getTitle(currentIndex)),
            backgroundColor: Colors.redAccent,
          ),
          body: IndexedStack(
            index: currentIndex,
            children: [
              PokedexView(),
              FavoritesView(),
              Container(), // Dummy for Search gap
              NotificationsView(),
              Profile(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              if (index == 2) return; // Do nothing for Search (FAB handles it)
              BlocProvider.of<BottomNavCubit>(context).updateIndex(index);
            },
            type: BottomNavigationBarType.fixed, // Needed for >3 items
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_rounded),
                label: 'Pokedex',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_rounded),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: SizedBox.shrink(), // Empty item for FAB
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_rounded),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
            selectedItemColor: Colors.redAccent,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: PokemonSearchDelegate(),
              );
            },
            child: Icon(Icons.search),
            backgroundColor: Colors.redAccent,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Pokedex';
      case 1:
        return 'Favorites';
      case 3: // Index 2 is Search/Empty
        return 'Notifications';
      case 4:
        return 'Profile';
      default:
        return 'Pokedex';
    }
  }
}
