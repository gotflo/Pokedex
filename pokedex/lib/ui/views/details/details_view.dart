import 'package:flutter/material.dart';
import 'package:pokedex/ui/models/pokemon_model.dart';
import 'package:stacked/stacked.dart';
import 'details_viewmodel.dart';

class DetailsView extends StackedView<DetailsViewModel> {
  final PokemonModel pokemon;

  const DetailsView({Key? key, required this.pokemon}) : super(key: key);

  @override
  void onViewModelReady(DetailsViewModel viewModel) {
    viewModel.init(pokemon.id);
  }

  @override
  Widget builder(
      BuildContext context, DetailsViewModel viewModel, Widget? child) {
    if (viewModel.isBusy || viewModel.fullPokemon == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.red)),
      );
    }

    final fullPokemon = viewModel.fullPokemon!;
    Color mainColor = _getColorFromType(fullPokemon.types.first);

    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          fullPokemon.name[0].toUpperCase() + fullPokemon.name.substring(1),
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 10),
            child: Text(
              "#${fullPokemon.id.toString().padLeft(3, '0')}",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: _buildDetailsCard(fullPokemon, mainColor),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () {
                viewModel.playCry(fullPokemon.cryUrl);
              },
              child: SizedBox(
                height: 200,
                width: 200,
                child: Image.network(
                  fullPokemon.image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(PokemonModel pokemon, Color mainColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                pokemon.types.map((type) => _buildTypeChip(type)).toList(),
          ),
          const SizedBox(height: 20),
          Text("About",
              style: TextStyle(
                  color: mainColor, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _infoSpec("${pokemon.weight} kg", "Weight", Icons.scale),
              _infoSpec("${pokemon.height} m", "Height", Icons.straighten),
            ],
          ),
          const SizedBox(height: 30),
          Text("Base Stats",
              style: TextStyle(
                  color: mainColor, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 15),
          ...pokemon.stats.entries
              .map((s) => _buildStatRow(s.key, s.value, mainColor))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int value, Color color) {
    final Map<String, String> statLabels = {
      'hp': 'HP',
      'attack': 'ATK',
      'defense': 'DEF',
      'special-attack': 'SATK',
      'special-defense': 'SDEF',
      'speed': 'SPD'
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
              width: 45,
              child: Text(statLabels[label] ?? label.toUpperCase(),
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12))),
          const SizedBox(
              height: 20,
              child: VerticalDivider(thickness: 1, color: Colors.grey)),
          SizedBox(width: 35, child: Text(value.toString().padLeft(3, '0'))),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 160, // Normalisé sur une base de 160
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  //* Common components

  Widget _buildTypeChip(String type) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          color: _getColorFromType(type),
          borderRadius: BorderRadius.circular(20)),
      child: Text(type[0].toUpperCase() + type.substring(1),
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _infoSpec(String value, String label, IconData icon) {
    return Column(
      children: [
        Row(children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 8),
          Text(value)
        ]),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Color _getColorFromType(String type) {
    switch (type.toLowerCase()) {
      case 'grass':
        return const Color(0xFF74CB48);
      case 'fire':
        return const Color(0xFFF57D31);
      case 'water':
        return const Color(0xFF6493EB);
      case 'bug':
        return const Color(0xFFA7B723);
      case 'normal':
        return const Color(0xFFAAA67F);
      case 'poison':
        return const Color(0xFFA43E9E);
      case 'electric':
        return const Color(0xFFF9CF30);
      case 'ground':
        return const Color(0xFFDEC16B);
      case 'fairy':
        return const Color(0xFFE69EAC);
      case 'fighting':
        return const Color(0xFFC12239);
      case 'psychic':
        return const Color(0xFFFB5584);
      case 'rock':
        return const Color(0xFFB69E31);
      case 'ghost':
        return const Color(0xFF70559B);
      case 'ice':
        return const Color(0xFF9AD6DF);
      case 'dragon':
        return const Color(0xFF7037FF);
      default:
        return Colors.grey;
    }
  }

  @override
  DetailsViewModel viewModelBuilder(BuildContext context) => DetailsViewModel();
}
