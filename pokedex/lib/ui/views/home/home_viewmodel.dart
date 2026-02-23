import 'package:pokedex/app/app.locator.dart';
import 'package:pokedex/ui/models/pokemon_model.dart';
import 'package:pokedex/ui/services/pokemon_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'home_view.form.dart';

class HomeViewModel extends FormViewModel {
  final _service = PokemonService();
  final navigationService = locator<NavigationService>();

  static const int _limit = 20;
  int _currentOffset = 0;

  List<PokemonModel> _allPokemons = [];

  // Filtre la liste complète selon la saisie utilisateur
  List<PokemonModel> get _filtered {
    final query = searchValue?.toLowerCase().trim() ?? '';
    if (query.isEmpty) return _allPokemons;

    return _allPokemons.where((pokemon) {
      return pokemon.name.toLowerCase().contains(query) ||
          pokemon.id.toString() == query;
    }).toList();
  }

  // Renvoie uniquement la page courante des résultats filtrés
  List<PokemonModel> get pokemons {
    final list = _filtered;
    if (list.isEmpty) return [];

    final start = _currentOffset.clamp(0, list.length);
    final end = (_currentOffset + _limit).clamp(start, list.length);
    return list.sublist(start, end);
  }

  int get currentPage => (_currentOffset ~/ _limit) + 1;
  int get totalPages => (_filtered.length / _limit).ceil().clamp(1, 9999);
  bool get canGoPrevious => _currentOffset >= _limit;
  bool get canGoNext => _currentOffset + _limit < _filtered.length;
  bool get hasResults => _filtered.isNotEmpty;

  @override
  void setFormStatus() {
    // Retour à la première page dès que le texte de recherche change
    _currentOffset = 0;
  }

  Future<void> init() async {
    setBusy(true);
    try {
      _allPokemons = await _service.fetchPokemonList(limit: 1025, offset: 0);
    } finally {
      setBusy(false);
    }
  }

  void next() {
    if (canGoNext) {
      _currentOffset += _limit;
      notifyListeners();
    }
  }

  void previous() {
    if (canGoPrevious) {
      _currentOffset -= _limit;
      notifyListeners();
    }
  }
}
