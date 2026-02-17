class PokemonSpeciesInfoResponse {
  final String description;

  PokemonSpeciesInfoResponse({required this.description});

  factory PokemonSpeciesInfoResponse.fromJson(Map<String, dynamic> json) {
    final flavorTextEntries =
        (json['flavor_text_entries'] as List).cast<Map<String, dynamic>>();
    // Find English description
    final englishEntry = flavorTextEntries.firstWhere(
      (entry) => entry['language']['name'] == 'en',
      orElse: () => flavorTextEntries.first,
    );

    final String description = englishEntry['flavor_text'];

    // Clean up text (remove form feeds and newlines)
    final cleanDescription = description.replaceAll(RegExp(r'[\n\f]'), ' ');

    return PokemonSpeciesInfoResponse(description: cleanDescription);
  }
}
