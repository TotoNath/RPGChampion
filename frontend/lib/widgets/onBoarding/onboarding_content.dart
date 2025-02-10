import 'package:flutter/material.dart';
import 'package:frontend/widgets/onBoarding/staggeredview_widget.dart';

/// `OnboardingContent` est un widget stateless qui représente une page de contenu dans l'onboarding de l'application. Ce widget permet d'afficher une illustration, un titre et un texte d'introduction, avec une logique spécifique selon l'index de la page.
///
/// ### Paramètres :
/// - `illustration` : Le chemin de l'illustration à afficher (une image asset).
/// - `text` : Le texte à afficher sous l'illustration, qui explique le contenu de la page d'onboarding.
/// - `title` : Le titre de la page d'onboarding.
/// - `index` : L'index de la page dans la séquence d'onboarding. Cela détermine quel contenu spécifique sera montré (par exemple, une animation spéciale sur la première page).
///
/// ### Fonctionnalités :
/// - **Affichage d'illustration** : Selon l'index, si l'index est 0, un widget spécial `StaggeredViewWidget` est affiché avec le titre et le texte.
/// - **Affichage classique des pages d'onboarding** : Si l'index n'est pas 0, la page d'onboarding affiche une image, suivie du titre et du texte. Ce texte est centré grâce à l'utilisation de `Align` et un `Padding` est appliqué pour améliorer la lisibilité.
/// - **AspectRatio** : Utilisation de `AspectRatio` pour rendre l'illustration carrée et bien proportionnée, peu importe la taille de l'écran.
///
/// ### Méthodes :
/// - **build** : Construit et affiche le contenu de la page en fonction de l'index. Si l'index est 0, un widget `StaggeredViewWidget` est utilisé. Sinon, une image avec un texte centré est affichée.
class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.illustration,
    required this.text,
    required this.title,
    required this.index,
  });

  final String illustration, text, title;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return StaggeredViewWidget(title: title, text: text);
    } else {
      return SafeArea(
          child: Column(
        children: [
          Expanded(
              child: AspectRatio(
                  aspectRatio: 1, child: Image.asset(illustration))),
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
              alignment: Alignment.center,
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
}
