import 'package:flutter/material.dart';
import 'package:pokedex/app/app.router.dart';
import 'package:pokedex/ui/common/app_colors.dart';
import 'package:pokedex/ui/common/pokemon_card.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'home_viewmodel.dart';
import 'home_view.form.dart';

@FormView(fields: [
  FormTextField(name: 'search'),
])
class HomeView extends StackedView<HomeViewModel> with $HomeView {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            _buildRedHeader(),
            const SizedBox(height: 12),
            Expanded(child: _buildBody(viewModel)),
            if (!viewModel.isBusy && viewModel.totalPages > 1)
              _buildPagination(viewModel),
          ],
        ),
      ),
    );
  }

  // ─── Header rouge (titre + barre de recherche) ───

  Widget _buildRedHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/icons/pokeball_black.png',
                    width: 28,
                    height: 28,
                    color: whiteColor,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Pokédex',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSearchBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: searchController,
        cursorColor: primaryColor,
        style: const TextStyle(fontSize: 14, color: darkColor),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          prefixIcon: const Icon(Icons.search_rounded, color: primaryColor),
          hintText: 'Rechercher un Pokémon...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // ─── Contenu principal ───

  Widget _buildBody(HomeViewModel viewModel) {
    if (viewModel.isBusy) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor, strokeWidth: 2.5),
      );
    }

    if (!viewModel.hasResults) {
      return _buildEmptyState();
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.82,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: viewModel.pokemons.length,
      itemBuilder: (context, index) {
        final pokemon = viewModel.pokemons[index];
        return PokemonCard(
          id: pokemon.id,
          name: pokemon.name,
          imageUrl: pokemon.image,
          onTap: () {
            viewModel.navigationService.navigateToDetailsView(pokemon: pokemon);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.catching_pokemon, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          const Text(
            'Aucun Pokémon trouvé',
            style: TextStyle(
              color: mediumColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Pagination ───

  Widget _buildPagination(HomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: _navButton(
              'Back',
              enabled: viewModel.canGoPrevious,
              onPressed: viewModel.previous,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${viewModel.currentPage} / ${viewModel.totalPages}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: mediumColor,
              ),
            ),
          ),
          Expanded(
            child: _navButton(
              'Next',
              enabled: viewModel.canGoNext,
              onPressed: viewModel.next,
            ),
          ),
        ],
      ),
    );
  }

  Widget _navButton(
    String label, {
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        disabledBackgroundColor: primaryColor.withValues(alpha: 0.35),
        foregroundColor: whiteColor,
        disabledForegroundColor: whiteColor.withValues(alpha: 0.6),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    syncFormWithViewModel(viewModel);
    viewModel.init();
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onDispose(HomeViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }
}
