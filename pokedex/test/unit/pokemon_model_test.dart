import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/features/pokemon/data/models/pokemon_page.dart';
import 'package:pokedex/features/pokemon/data/models/pokemon_species.dart';

void main() {
  group('PokemonListing', () {
    test('fromJson extraction of ID from URL', () {
      final json = {
        'name': 'bulbasaur',
        'url': 'https://pokeapi.co/api/v2/pokemon/1/'
      };
      final listing = PokemonListing.fromJson(json);
      expect(listing.id, 1);
      expect(listing.name, 'bulbasaur');
    });

    test('fromJson extraction of ID from URL with extra slashes', () {
      final json = {
        'name': 'ivysaur',
        'url': 'https://pokeapi.co/api/v2/pokemon/2' // missing trailing slash
      };
      final listing = PokemonListing.fromJson(json);
      expect(listing.id, 2);
    });
  });

  group('PokemonSpecies', () {
    test('fromJson cleans up description text', () {
      final json = {
        'flavor_text_entries': [
          {
            'flavor_text': 'A weird\npokemon description\fwith chars.',
            'language': {'name': 'en'}
          }
        ]
      };

      final species = PokemonSpeciesInfoResponse.fromJson(json);
      expect(species.description, 'A weird pokemon description with chars.');
    });

    test('fromJson fallback to first entry if english missing', () {
      final json = {
        'flavor_text_entries': [
          {
            'flavor_text': 'Hola mundo',
            'language': {'name': 'es'}
          }
        ]
      };

      final species = PokemonSpeciesInfoResponse.fromJson(json);
      expect(species.description, 'Hola mundo');
    });
  });
}
