import 'package:flutter/material.dart';

import '../../constant/color.dart';
import '../../service/discord_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {loginWithDiscord();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.primaryText,
                backgroundColor: AppColors.discordButton,
                fixedSize: Size(182, 45), // Largeur de 50 px et hauteur de 45 px
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Le Row prend juste la place nécessaire
                mainAxisAlignment: MainAxisAlignment.center, // Centre le contenu
                children: [
                  Image.asset(
                    'assets/logo/logo_discord.png', // Chemin de votre asset
                    height: 24, // Taille de l'icône
                  ),
                  SizedBox(width: 8), // Espacement entre l'icône et le texte
                  Text(
                    "Se Connecter".toUpperCase(),
                    style: TextStyle(
                      color: AppColors.primaryText, // Assurez-vous que le texte est visible
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
