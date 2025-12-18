import 'package:audioplayers/audioplayers.dart';
import 'package:pokedex/ui/models/pokemon_model.dart';
import 'package:pokedex/ui/services/pokemon_service.dart';
import 'package:stacked/stacked.dart';

class DetailsViewModel extends BaseViewModel {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final _pokemonService = PokemonService();
  PokemonModel? _fullPokemon;

  PokemonModel? get fullPokemon => _fullPokemon;

  Future<void> playCry(String url) async {
    if (url.isEmpty) return;
    await _audioPlayer.play(UrlSource(url));
  }

  Future<void> init(int id) async {
    setBusy(true);
    try {
      _fullPokemon = await _pokemonService.fetchPokemonDetails(id);
    } catch (e) {
      print("Erreur: $e");
    }
    setBusy(false);
  }
}
