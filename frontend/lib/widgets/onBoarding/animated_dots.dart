import 'package:flutter/cupertino.dart';

/// `AnimatedDot` est un widget qui représente un point animé utilisé pour des indicateurs de pagination ou des étapes dans une interface utilisateur.
///
/// ### Paramètres :
/// - `isActive` : Un booléen qui détermine si le point doit être affiché comme actif ou non. Si `true`, le point sera plus grand et de couleur blanche, sinon il sera plus petit et de couleur grise avec une opacité légère.
///
/// ### Fonctionnalités :
/// - **Animation de la taille** : Le widget utilise un `AnimatedContainer` pour animer les changements de taille du point en fonction de la valeur de `isActive`. La durée de l'animation est de 300 millisecondes.
/// - **Changement de couleur et de taille** :
///   - Lorsque `isActive` est `true`, la largeur du point est de 20 et la couleur est blanche (`#FFFFFF`).
///   - Lorsque `isActive` est `false`, la largeur est de 6 et la couleur devient grise claire avec une opacité de 0.15 (`#DFDFDF`).
///
/// ### Méthodes :
/// - **build** : Construit et affiche l'élément visuel. Utilise un `AnimatedContainer` pour rendre le point interactif et animé lorsqu'il change d'état.
class AnimatedDot extends StatelessWidget {
  const AnimatedDot({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds : 300),
      height: 6,
      width: isActive ? 20 : 6,
      decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFFFFFFFF)
              : const Color(0xFFDFDFDF).withOpacity(0.15),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }
}