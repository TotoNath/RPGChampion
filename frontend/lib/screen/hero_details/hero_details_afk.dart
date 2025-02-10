import 'package:flutter/material.dart';
import 'package:frontend/constant/color.dart';
import 'package:frontend/constant/values.dart';

import '../../service/hero_service.dart';

/// `AfkPage` est une page permettant à l'utilisateur de mettre son héros en mode vadrouille (AFK).
///
/// ### Fonctionnalités :
/// - Envoie une requête pour activer le mode AFK du héros.
/// - Affiche le résultat de l'action après l'exécution.
///
/// ### Paramètres :
/// - `userId` : Identifiant de l'utilisateur.
/// - `guildId` : Identifiant de la guilde à laquelle appartient le héros.
///
/// ### Auteur : Nguiquerro
class AfkPage extends StatefulWidget {
  final String userId;
  final String guildId;

  const AfkPage({super.key, required this.userId, required this.guildId});

  @override
  _AfkPageState createState() => _AfkPageState();
}

class _AfkPageState extends State<AfkPage> {
  String afkResult = "";

  Future<void> afk() async {
    final response = await afkHero(widget.userId, widget.guildId);
    setState(() {
      afkResult = response.body;
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
              onPressed: afk,
              child: const Text("🏃‍♂️ Vadrouiller 🏃‍♂️"),
            ),
            const SizedBox(height: AppValues.SizedBoxHeight),
            Text(
              afkResult,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
