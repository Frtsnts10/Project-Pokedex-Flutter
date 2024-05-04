import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/bloc/navCubit.dart';
import 'bloc/pokeBloc.dart';
import 'bloc/pokeState.dart';
import 'prof.dart';


class PokedexView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Pokedex'),
        backgroundColor: Colors.redAccent,
      ),
      
      body: BlocBuilder<PokemonBloc, PokemonState>(
        builder: (context, state) {
          if (state is PokemonLoadInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          else if (state is PokemonPageLoadSuccess) {
            return GridView.builder(
              padding: const EdgeInsets.all(30),

              gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),

                itemCount: state.pokemonListings.length,
                itemBuilder: (context, index) {

                  return GestureDetector(
                    onTap: () => BlocProvider.of<NavCubit>(context)
                    .showPokemonDetails(state.pokemonListings[index].id),
                    child: Card(
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: InkWell(
                    splashColor: Colors.lightBlue.withAlpha(30),

                    child: GridTile(
                      child: Column(
                        children: [
                          Image.network(state.pokemonListings[index].imageUrl),
                          Text(state.pokemonListings[index].name)
                        ],
                      ),
                    ),

                  ),
                ),
              );
            },
          );
        } 
          
        else if (state is PokemonPageLoadFailed) {
          return Center(
            child: Text(state.error.toString()),
          );
        } 
          
        else {
          return Container();
        }
      },
    ),

    bottomNavigationBar: BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            onPressed: () {
              Profile();
            }, 
            icon: Icon(Icons.home),
          ),

          IconButton(
            onPressed: (){
              
            },
            icon: Icon(Icons.person),
          ),

        ],
      ),
    ),
      
    floatingActionButton: FloatingActionButton(
      child: Icon(
        Icons.search), 
        onPressed: (){},
      ),
      
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}