import 'package:pokedex/app/app.locator.dart';
import 'package:pokedex/ui/models/pokemon_model.dart';
import 'package:pokedex/ui/services/pokemon_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends FormViewModel {
  final _service = PokemonService();
  final navigationService = locator<NavigationService>();
  int _currentOffset = 0;
  final int _limit = 20;

  List<PokemonModel> _pokemons = [];
  List<PokemonModel> get pokemons => _pokemons;

  Future<void> init() => _loadPage();

  Future<void> _loadPage() async {
    setBusy(true);
    try {
      _pokemons = await _service.fetchPokemonList(
          limit: _limit, offset: _currentOffset);
    } finally {
      setBusy(false);
    }
  }

  void next() {
    _currentOffset += _limit;
    _loadPage();
  }

  void previous() {
    if (_currentOffset >= _limit) {
      _currentOffset -= _limit;
      _loadPage();
    }
  }
}
