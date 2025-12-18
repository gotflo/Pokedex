import 'package:flutter/material.dart';
import 'package:pokedex/app/app.router.dart';
import 'package:pokedex/ui/common/custom_button.dart';
import 'package:pokedex/ui/common/pokemon_card.dart';
import 'package:stacked/stacked.dart';
import 'package:pokedex/ui/common/app_colors.dart';
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            backgroundColor: primaryColor,
            centerTitle: false,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Image.asset("assets/icons/pokeball_black.png",
                  color: whiteColor),
            ),
            leadingWidth: 34,
            title: const Text(
              "Pokedex",
              style: TextStyle(
                color: whiteColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(80.0),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      //* Search bar
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: Material(
                            elevation: 4,
                            shadowColor: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                            child: TextField(
                              controller: searchController,
                              cursorColor: primaryColor,
                              cursorHeight: 20,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: primaryColor,
                                ),
                                hintText: "Search",
                                fillColor: whiteColor,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      //* Sort button
                      Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Text("#",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor))),
                    ],
                  ),
                )),
          ),
        ),
        body: viewModel.isBusy
            ? const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                        ),
                        itemCount: viewModel.pokemons.length,
                        itemBuilder: (context, index) {
                          final pokemon = viewModel.pokemons[index];

                          return GestureDetector(
                            onTap: () {
                              viewModel.navigationService
                                  .navigateToDetailsView(pokemon: pokemon);
                            },
                            child: pokemonCard(
                                pokemon.id.toString().padLeft(3, '0'),
                                pokemon.name,
                                pokemon.image),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          customButton(
                            text: "Back",
                            onPressed: () {
                              viewModel.previous();
                            },
                          ),
                          customButton(
                            text: "Next",
                            onPressed: () {
                              viewModel.next();
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
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
