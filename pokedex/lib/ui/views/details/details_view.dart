import 'package:flutter/material.dart';
import 'package:pokedex/ui/common/app_colors.dart';
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
        body: Center(
          child: CircularProgressIndicator(color: primaryColor, strokeWidth: 2.5),
        ),
      );
    }

    final poke = viewModel.fullPokemon!;
    final typeColor = getTypeColor(poke.types.first);

    return Scaffold(
      backgroundColor: typeColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Pokeball watermark
            Positioned(
              top: 30,
              right: -30,
              child: Opacity(
                opacity: 0.12,
                child: Image.asset(
                  'assets/icons/pokeball_black.png',
                  width: 200,
                  height: 200,
                  color: Colors.white,
                ),
              ),
            ),

            Column(
              children: [
                _buildHeader(context, poke),
                _buildPokemonImage(poke, viewModel),
                _buildDetailsSheet(poke, typeColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PokemonModel poke) {
    final displayName = poke.name[0].toUpperCase() + poke.name.substring(1);
    final formattedId = '#${poke.id.toString().padLeft(3, '0')}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 4),
          Text(
            displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            formattedId,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPokemonImage(PokemonModel poke, DetailsViewModel viewModel) {
    return GestureDetector(
      onTap: () => viewModel.playCry(poke.cryUrl),
      child: Hero(
        tag: 'pokemon-${poke.id}',
        child: SizedBox(
          height: 200,
          width: 200,
          child: Image.network(poke.image, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildDetailsSheet(PokemonModel poke, Color typeColor) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
          child: Column(
            children: [
              _buildTypeChips(poke.types),
              const SizedBox(height: 24),
              _sectionTitle('About', typeColor),
              const SizedBox(height: 16),
              _buildAboutRow(poke),
              const SizedBox(height: 28),
              _sectionTitle('Base Stats', typeColor),
              const SizedBox(height: 16),
              ...poke.stats.entries.map(
                (stat) => _buildStatBar(stat.key, stat.value, typeColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChips(List<String> types) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: types.map((type) {
        final color = getTypeColor(type);
        final label = type[0].toUpperCase() + type.substring(1);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _buildAboutRow(PokemonModel poke) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _aboutItem(Icons.scale_rounded, '${poke.weight} kg', 'Weight'),
          const VerticalDivider(width: 1, thickness: 1, color: lightColor),
          _aboutItem(Icons.straighten_rounded, '${poke.height} m', 'Height'),
        ],
      ),
    );
  }

  Widget _aboutItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: mediumColor),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: darkColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: subtitleColor,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildStatBar(String statKey, int value, Color color) {
    const statLabels = {
      'hp': 'HP',
      'attack': 'ATK',
      'defense': 'DEF',
      'special-attack': 'SATK',
      'special-defense': 'SDEF',
      'speed': 'SPD',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 42,
            child: Text(
              statLabels[statKey] ?? statKey.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
            child: VerticalDivider(width: 1, thickness: 1, color: lightColor),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 32,
            child: Text(
              value.toString().padLeft(3, '0'),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: darkColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: value / 255,
                backgroundColor: color.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  DetailsViewModel viewModelBuilder(BuildContext context) => DetailsViewModel();
}
