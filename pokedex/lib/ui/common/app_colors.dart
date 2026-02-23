import 'package:flutter/material.dart';

// Identity
const Color primaryColor = Color(0xFFDC0A2D);

// Pokemon Types Colors
const Color bugTypeColor = Color(0xFFA7B723);
const Color darkTypeColor = Color(0xFF75574C);
const Color dragonTypeColor = Color(0xFF7037FF);
const Color electricTypeColor = Color(0xFFF9CF30);
const Color fairyTypeColor = Color(0xFFE69EAC);
const Color fightingTypeColor = Color(0xFFC12239);
const Color fireTypeColor = Color(0xFFF57D31);
const Color flyingTypeColor = Color(0xFFA891EC);
const Color ghostTypeColor = Color(0xFF70559B);
const Color normalTypeColor = Color(0xFFAAA67F);
const Color grassTypeColor = Color(0xFF74CB48);
const Color groundTypeColor = Color(0xFFDEC16B);
const Color iceTypeColor = Color(0xFF9AD6DF);
const Color poisonTypeColor = Color(0xFFA43E9E);
const Color psychicTypeColor = Color(0xFFFB5584);
const Color rockTypeColor = Color(0xFFB69E31);
const Color steelTypeColor = Color(0xFFB7B9D0);
const Color waterTypeColor = Color(0xFF6493EB);

// Grayscale
const Color darkColor = Color(0xFF303943);
const Color mediumColor = Color(0xFF666666);
const Color lightColor = Color(0xFFE0E0E0);
const Color backgroundColor = Color(0xFFF5F5F5);
const Color whiteColor = Color(0xFFFFFFFF);
const Color subtitleColor = Color(0xFFAAAAAA);

Color getTypeColor(String type) {
  switch (type.toLowerCase()) {
    case 'grass':
      return grassTypeColor;
    case 'fire':
      return fireTypeColor;
    case 'water':
      return waterTypeColor;
    case 'bug':
      return bugTypeColor;
    case 'normal':
      return normalTypeColor;
    case 'poison':
      return poisonTypeColor;
    case 'electric':
      return electricTypeColor;
    case 'ground':
      return groundTypeColor;
    case 'fairy':
      return fairyTypeColor;
    case 'fighting':
      return fightingTypeColor;
    case 'psychic':
      return psychicTypeColor;
    case 'rock':
      return rockTypeColor;
    case 'ghost':
      return ghostTypeColor;
    case 'ice':
      return iceTypeColor;
    case 'dragon':
      return dragonTypeColor;
    case 'dark':
      return darkTypeColor;
    case 'steel':
      return steelTypeColor;
    case 'flying':
      return flyingTypeColor;
    default:
      return normalTypeColor;
  }
}
