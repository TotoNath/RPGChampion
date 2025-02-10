import 'package:flutter/material.dart';
import 'package:frontend/constant/values.dart';

import '../../constant/color.dart';
import '../../service/discord_auth.dart';

/// `LoginPage` est un widget de type `StatefulWidget` qui gère la page de connexion via Discord.
///
/// Cette page permet à l'utilisateur de se connecter à l'application en utilisant l'authentification Discord. Un bouton est affiché pour initier la connexion, et un indicateur de chargement est montré pendant le processus de connexion.
///
/// ### Fonctionnalités :
/// - Affichage d'un bouton de connexion à Discord.
/// - Un indicateur de chargement pendant la connexion.
/// - Gestion des erreurs de connexion.
///
/// ### Méthodes :
/// - `_handleLogin` : Tente de connecter l'utilisateur via Discord et gère l'état de chargement.
///
/// ### Composants :
/// - **ElevatedButton** : Bouton qui déclenche la tentative de connexion avec Discord.
/// - **CircularProgressIndicator** : Indicateur de chargement qui s'affiche lors de la connexion.
/// - **Image.asset** : Affiche le logo Discord dans le bouton de connexion.
///
/// ### Auteur : Nguiquerro
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:frontend/constant/values.dart';
import '../../constant/color.dart';
import '../../service/discord_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await loginWithDiscord();
    } catch (e) {
      print("Erreur de connexion: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Page de Connexion",
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColors.primaryText,
                        backgroundColor: AppColors.discordButton,
                        fixedSize: const Size(250, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        shadowColor: Colors.black.withOpacity(0.3),
                        elevation: 6,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo/logo_discord.png',
                            height: 24,
                          ),
                          const SizedBox(width: AppValues.SizedBoxWidth),
                          Text(
                            "Se Connecter".toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
