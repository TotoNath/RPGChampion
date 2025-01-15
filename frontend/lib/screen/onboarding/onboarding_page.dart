import 'package:flutter/material.dart';
import 'package:frontend/constant/color.dart';
import 'package:frontend/screen/login/login.dart';
import 'package:frontend/widgets/staggeredview_widget.dart';
import 'package:get/get.dart';

import '../../utils/onboarding_utils.dart';
import 'animated_dots.dart';

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
        Spacer(flex: 1),
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
        Spacer(),
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
        Spacer(flex: 2),
        ElevatedButton(
          onPressed: () {
            setHasSeenOnboarding();
            Get.off(() => LoginPage(title: "LoginPage",));
            },
          child: Text("Commencer".toUpperCase()),
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.buttonText,
            backgroundColor: AppColors.button, // Couleur du texte
          ),
        ),
        Spacer()
      ],
    ));
  }
}

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
          SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            // Ajouter un padding à gauche et à droite
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
