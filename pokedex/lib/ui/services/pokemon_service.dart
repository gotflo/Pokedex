import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex/ui/models/pokemon_model.dart';

class PokemonService {
  //* GET POKEMON LIST
  Future<List<PokemonModel>> fetchPokemonList(
      {int limit = 20, int offset = 0}) async {
    final response = await http.get(Uri.parse(
        'https://pokeapi.co/api/v2/pokemon?limit=$limit&offset=$offset'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];

      return results.asMap().entries.map((entry) {
        int pokemonId = entry.key + 1 + offset;

        return PokemonModel(
          id: pokemonId,
          name: entry.value['name'],
          image:
              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png",
          height: 0,
          weight: 0,
          types: [],
          stats: {}, cryUrl: '',
        );
      }).toList();
    } else {
      throw Exception('Échec du chargement de la liste');
    }
  }

  //* GET POKEMON DETAILS
  Future<PokemonModel> fetchPokemonDetails(int id) async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return PokemonModel.fromJson(json);
    } else {
      throw Exception('Détails introuvables');
    }
  }
}
