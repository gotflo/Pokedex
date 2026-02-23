import 'package:flutter/material.dart';
import 'package:pokedex/ui/common/app_colors.dart';

class PokemonCard extends StatelessWidget {
  final int id;
  final String name;
  final String imageUrl;
  final VoidCallback onTap;

  const PokemonCard({
    super.key,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedId = '#${id.toString().padLeft(3, '0')}';
    final displayName = name[0].toUpperCase() + name.substring(1);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 5,
              right: 5,
              child: Opacity(
                opacity: 0.04,
                child: Image.asset(
                  'assets/icons/pokeball_black.png',
                  width: 80,
                  height: 80,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      formattedId,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: subtitleColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Hero(
                      tag: 'pokemon-$id',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          frameBuilder: (_, child, frame, wasSync) {
                            if (wasSync) return child;
                            return AnimatedOpacity(
                              opacity: frame == null ? 0 : 1,
                              duration: const Duration(milliseconds: 300),
                              child: child,
                            );
                          },
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.catching_pokemon,
                            size: 48,
                            color: lightColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displayName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: darkColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
