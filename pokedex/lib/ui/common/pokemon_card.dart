import 'package:flutter/material.dart';
import 'package:pokedex/ui/common/app_colors.dart';

Widget pokemonCard(
    String pokemonNumber, String pokemonName, String pokemonImage) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: SizedBox(
      width: 130,
      height: 130,
      child: Card(
        margin: EdgeInsets.zero,
        color: whiteColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            //* 1. Le fond gris en bas (le rectangle arrondi)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            //* 2. Le contenu de la carte
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //* Numéro du Pokémon (en haut à droite)
                Padding(
                  padding: const EdgeInsets.only(top: 4, right: 8),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "#$pokemonNumber",
                      style: const TextStyle(color: mediumColor),
                    ),
                  ),
                ),

                //* Image du Pokémon
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Image.network(
                      pokemonImage,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),

                //* Nom du Pokémon
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: Text(
                    "${pokemonName[0].toUpperCase()}${pokemonName.substring(1)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: darkColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
