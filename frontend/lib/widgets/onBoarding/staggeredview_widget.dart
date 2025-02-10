import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// `StaggeredViewWidget` est un widget stateless qui affiche un ensemble d'éléments dans une grille en utilisant une disposition décalée, ce qui signifie que les éléments peuvent avoir des tailles variables et s'ajuster de manière irrégulière dans la grille.
///
/// ### Paramètres :
/// - `title` : Le titre à afficher en haut de la page.
/// - `text` : Le texte explicatif à afficher sous le titre.
///
/// ### Fonctionnalités :
/// - **Grille Staggered** : Le widget utilise un `MasonryGridView` (fourni par le package `flutter_staggered_grid_view`), qui est une grille où les éléments peuvent avoir des tailles différentes. Cela crée une vue en grille où les images sont placées de manière irrégulière.
/// - **Animation d'opacité** : Un effet d'opacité est appliqué au `MasonryGridView` avec une valeur d'opacité de 0.8.
/// - **Disposition des éléments** : Les éléments de la grille sont des images d'assets (`'assets/onBoarding/*.png'` ou `'assets/onBoarding/*.jpg'`), et chaque image a un contour spécifique avec `ClipRRect`, où les coins sont arrondis. Cela crée un effet esthétique avec des images bien découpées.
/// - **Affichage du Titre et du Texte** : Après la grille d'images, le titre et le texte sont affichés, avec un espace entre eux pour une meilleure lisibilité.
///
/// ### Méthodes :
/// - **build** : Le `build` crée une grille avec 11 éléments, chacun représentant une image différente. Les images sont disposées dans la grille en fonction de la logique de `MasonryGridView`. Le titre et le texte sont ajoutés en bas de la grille.
///
/// ### Structure :
/// 1. **MasonryGridView** : Affiche les éléments sous forme de grille en utilisant un délégué simple pour la disposition, avec des espacements entre les éléments. La grille est fixe avec un `crossAxisCount` de 3 (3 colonnes).
/// 2. **ClipRRect** : Chaque élément de la grille (image) est encapsulé dans un `ClipRRect`, qui permet de donner un effet d'angle arrondi aux images.
/// 3. **Titre et Texte** : Après la grille, un titre est affiché avec un style en gras, suivi d'un texte centré.
class StaggeredViewWidget extends StatelessWidget {
  const StaggeredViewWidget({
    super.key,
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Expanded(
            child: Opacity(
          opacity: 0.8,
          child: MasonryGridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            itemCount: 11,
            itemBuilder: (context, index) {
              return [
                () => ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(16),
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(16),
                      ),
                      child: Image.asset(
                        'assets/onBoarding/sword.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                () => ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/onBoarding/potion.png',
                        width: 120,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                () => ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(16),
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(16),
                      ),
                      child: Image.asset(
                        'assets/onBoarding/bow.png',
                        width: 100,
                        height: 0,
                        fit: BoxFit.cover,
                      ),
                    ),
                () => ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(0),
                      ),
                      child: Image.asset(
                        'assets/onBoarding/wow_knight.png',
                        width: 80,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                () => ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/onBoarding/wand.png',
                        width: 120,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                () => ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/onBoarding/bandit.png',
                        width: 120,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                () => ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(0),
                      ),
                      child: Image.asset(
                        'assets/onBoarding/goblin.png',
                        width: 120,
                        height: 190,
                        fit: BoxFit.cover,
                      ),
                    ),
                () => ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/onBoarding/magician.jpg',
                        width: 120,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                () => ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/onBoarding/bag.png',
                        width: 120,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                () => ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(0),
                      ),
                      child: Image.asset(
                        'assets/onBoarding/bow.png',
                        width: 120,
                        height: 190,
                        fit: BoxFit.cover,
                      ),
                    ),
                () => ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        'https://imgcdn.stablediffusionweb.com/2024/4/14/5de25de5-8b79-4831-aad2-e13fa5489ad5.jpg',
                        width: 120,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
              ][index]();
            },
          ),
        )),
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Align(
            alignment: Alignment.center, // Centrer le texte
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    ));
  }
}
