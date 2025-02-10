import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// `CustomDrawerButton` est un widget personnalisé utilisé dans un tiroir (drawer) de l'application.
/// Il permet de créer un bouton de navigation avec un effet de mise en surbrillance pour indiquer la page active.
///
/// ### Paramètres :
/// - `activePage` : La page actuellement active, utilisée pour comparer avec la page du bouton.
/// - `context` : Le contexte de l'application pour le rendu du bouton.
/// - `page` : La page associée au bouton. Cela est utilisé pour identifier la page et déterminer si ce bouton est actif.
/// - `icon` : L'icône à afficher lorsque le bouton n'est pas sélectionné.
/// - `selectedIcon` : L'icône à afficher lorsque le bouton est sélectionné (page active).
/// - `onPressed` : La fonction de rappel qui sera exécutée lorsque l'utilisateur appuie sur le bouton.
///
/// ### Fonctionnalités :
/// - **Animation** : Le bouton utilise un effet de mise à l'échelle (`TweenAnimationBuilder`) pour grossir lorsque la page est active et rétrécir lorsqu'elle ne l'est pas.
/// - **Comportement visuel** : Lorsque la page associée au bouton est active, l'icône est agrandie (scalée à 1.3), sinon elle est réduite à 0.8. Cela est réalisé à l'aide de l'animation de mise à l'échelle.
/// - **Icône sélectionnée** : Lorsqu'une page est active, l'icône de l'état sélectionné (`selectedIcon`) est affichée.
/// - **Interaction** : Le bouton peut être pressé, déclenchant la fonction passée en paramètre via `onPressed`.
///
/// ### Méthodes :
/// - **build** : Construit l'interface utilisateur du bouton, applique l'animation de mise à l'échelle et configure l'icône en fonction de l'état de la page.
///
/// ### Auteur : Nguiquerro
class CustomDrawerButton extends StatelessWidget {
  const CustomDrawerButton({
    super.key,
    required this.activePage,
    required this.context,
    required this.page,
    required this.icon,
    required this.selectedIcon,
    required this.onPressed,
  });

  final String activePage;
  final BuildContext context;
  final String page;
  final IconData icon;
  final IconData selectedIcon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bool isActive = (activePage == page);

    return TweenAnimationBuilder<double>(
      tween:
      Tween<double>(begin: isActive ? 1.3 : 0.8, end: isActive ? 1.3 : 0.8),
      duration: const Duration(milliseconds: 200),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon),
            iconSize: 30,
            color: Colors.white,
            splashRadius: 30,
            splashColor: Colors.white,
            selectedIcon: Icon(selectedIcon),
            isSelected: !isActive,
            highlightColor: Colors.transparent,
            tooltip: page,
          ),
        );
      },
    );
  }
}