import 'package:flutter/material.dart';
import 'package:frontend/constant/color.dart';
import 'package:frontend/screen/login/login.dart';
import 'package:frontend/widgets/onBoarding/onboarding_content.dart';
import 'package:get/get.dart';

import '../../utils/onboarding_utils.dart';
import '../../widgets/onBoarding/animated_dots.dart';

/// `OnboardingPage` est un widget `StatefulWidget` qui gère la page d'introduction de l'application.
/// Cette page sert à guider l'utilisateur à travers plusieurs écrans d'introduction avant de passer à la page de connexion.
///
/// ### Fonctionnalités :
/// - Affichage d'une séquence de plusieurs pages d'introduction.
/// - Permet de changer de page à l'aide du `PageView`.
/// - Affiche un indicateur sous forme de points animés pour indiquer la page actuelle.
/// - Bouton permettant de passer à la page de connexion après la fin de l'introduction.
///
/// ### Méthodes :
/// - **build** : Construit la page d'onboarding avec les pages d'introduction et un bouton pour démarrer.
///
/// ### Composants :
/// - **PageView.builder** : Crée et affiche les pages d'introduction.
/// - **OnboardingContent** : Affiche le contenu de chaque page d'introduction.
/// - **AnimatedDot** : Affiche un point animé pour représenter la page actuelle.
/// - **ElevatedButton** : Permet de passer à la page de connexion une fois l'introduction terminée.
///
/// ### Liste `demoData` :
/// Contient les données nécessaires pour l'affichage des pages d'introduction.
/// Chaque élément de la liste contient une illustration, un titre et un texte descriptif.
///
/// ### Auteur : Nguiquerro
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<StatefulWidget> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const Spacer(flex: 1),
        SizedBox(
          height: 500,
          child: PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              itemCount: demoData.length,
              itemBuilder: (context, index) {
                return OnboardingContent(
                    illustration: demoData[index]['illustration'],
                    text: demoData[index]['text'],
                    title: demoData[index]['title'],
                    index: index);
              }),
        ),
        const Spacer(),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                demoData.length,
                (index) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: AnimatedDot(
                        isActive: _selectedIndex == index,
                      ),
                    ))),
        const Spacer(flex: 2),
        ElevatedButton(
          key: const Key('onboarding_continue_button'),
          onPressed: () {
            setHasSeenOnboarding();
            Get.off(() => const LoginPage(
                  title: "LoginPage",
                ));
          },
          child: Text("Commencer".toUpperCase()),
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.buttonText,
            backgroundColor: AppColors.button,
          ),
        ),
        const Spacer()
      ],
    ));
  }
}

List<Map<String, dynamic>> demoData = [
  {
    "illustration": "",
    "title": "Bienvenue sur RPGChampion",
    "text":
        "Un jeu de gestion de héros sur le quel vous pouvez créer votre héro et écrire l'histoire"
  },
  {
    "illustration": "assets/Illustrations/I1.png",
    "title": "Connectez-vous",
    "text":
        "Afin de commencer a jouer veuillez vous connecter en utilisant discord"
  },
  {
    "illustration": "assets/Illustrations/I2.png",
    "title": "Informations Complémentaires",
    "text":
        "Il sera nécessaire d'être connecté en préambule sur le même serveur que le bot RPGChampion"
  }
];
