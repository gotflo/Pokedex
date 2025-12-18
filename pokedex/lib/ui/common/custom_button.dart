import 'package:flutter/material.dart';
import 'package:pokedex/ui/common/app_colors.dart';

Widget customButton({required String text, required VoidCallback onPressed}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    onPressed: onPressed,
    child: Text(text,
        style: const TextStyle(
          color: whiteColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        )),
  );
}
