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
  bool _isLoading = false; // État de chargement

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await loginWithDiscord(); // Fonction asynchrone de connexion
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.primaryText,
                backgroundColor: AppColors.discordButton,
                fixedSize: const Size(182, 45),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                color: Colors.white,
              )
                  : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo/logo_discord.png',
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Se Connecter".toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
