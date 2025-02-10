import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/model/user_model.dart';
import 'package:frontend/screen/home/home.dart';
import 'package:frontend/screen/login/login.dart';
import 'package:frontend/screen/onboarding/onboarding_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../database/database.dart';
import '../../utils/onboarding_utils.dart';

/// `SplashScreen` est un widget `StatefulWidget` qui gère l'affichage de l'écran de démarrage de l'application.
/// Cet écran est utilisé pour vérifier si l'utilisateur a déjà vu l'écran d'introduction (onboarding) et si un utilisateur existe dans la base de données.
/// Selon ces conditions, l'utilisateur est redirigé soit vers la page d'onboarding, la page de connexion, ou la page d'accueil.
///
/// ### Fonctionnalités :
/// - Vérifie si l'utilisateur a vu l'écran d'introduction (`onboarding`) à l'aide de la méthode `hasSeenOnboarding`.
/// - Si l'utilisateur a vu l'onboarding, il vérifie s'il y a un utilisateur dans la base de données.
///   - Si un utilisateur existe, il redirige vers la page d'accueil (`HomePage`).
///   - Si aucun utilisateur n'est trouvé, il redirige vers la page de connexion (`LoginPage`).
/// - Si l'utilisateur n'a pas vu l'onboarding, il est redirigé vers la page d'introduction (`OnboardingPage`).
///
/// ### Méthodes :
/// - **initState** : Initialise l'écran et vérifie le statut de l'onboarding.
/// - **_checkOnboardingStatus** : Vérifie l'état de l'onboarding et redirige l'utilisateur en fonction des données.
/// - **build** : Affiche un écran avec un `CircularProgressIndicator` en attendant la vérification de l'état.
///
/// ### Auteur : Nguiquerro
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    bool hasSeen = await hasSeenOnboarding();
    if (hasSeen) {
      final db = Database();
      await db.init();
      final userCollection = db.isar.users;
      final userCount = await userCollection.count();

      if (userCount != 0) {
        Get.off(() => const HomePage());
      } else {
        Get.off(() => const LoginPage(title: "LoginPage"));
      }
    } else {
      Get.off(() => const OnboardingPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}