import 'package:flutter/material.dart';
import 'package:frontend/constant/color.dart';

import '../../service/hero_service.dart';

/// `WakeUpPage` est un widget de type `StatefulWidget` permettant de réveiller un héros.
///
/// Il envoie une requête pour réveiller un héros associé à un utilisateur et un guild, puis affiche le résultat de cette action.
///
/// ### Paramètres :
/// - `userId` : Identifiant de l'utilisateur pour lequel le héros est réveillé.
/// - `guildId` : Identifiant du guild auquel le héros appartient.
///
/// ### Fonctionnalités :
/// - Le bouton "Rentrer" déclenche la fonction `wake` pour envoyer la requête de réveil.
/// - Le résultat de la requête est affiché sous forme de texte.
///
/// ### Méthodes :
/// - `wake` : Envoie une requête pour réveiller le héros, puis met à jour l'UI avec la réponse.
///
/// ### Auteur : Nguiquerro
class WakeUpPage extends StatefulWidget {
  final String userId;
  final String guildId;

  const WakeUpPage({super.key, required this.userId, required this.guildId});

  @override
  _WakeUpPageState createState() => _WakeUpPageState();
}

class _WakeUpPageState extends State<WakeUpPage> {
  String wakeResult = "";

  Future<void> wake() async {
    final response = await wakeUpHero(widget.userId, widget.guildId);
    setState(() {
      wakeResult = response.body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.info,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: wake,
                child: const Text("🏠 Rentrer 🏠"),
              ),
              Text(
                wakeResult,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),],)


      ),
    );
  }
}
