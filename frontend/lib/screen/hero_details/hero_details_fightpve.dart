import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/constant/color.dart';
import 'package:frontend/constant/values.dart';
import 'package:frontend/database/model/hero_model.dart';
import 'package:frontend/service/hero_service.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

class FightPVEPage extends StatefulWidget {
  final String userId;
  final String guildId;
  final HeroModel heroModel;

  const FightPVEPage({super.key, required this.userId, required this.guildId, required this.heroModel});

  @override
  _FightPVEPageState createState() => _FightPVEPageState();
}

class _FightPVEPageState extends State<FightPVEPage> {
  String fightResult = "";
  bool showConfetti = false;
  bool isShaking = false;
  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 2));

  Future<void> fight() async {
    setState(() {
      isShaking = true;
    });

    Timer(const Duration(milliseconds: AppValues.TransitionDurationTO), () {
      setState(() {
        isShaking = false;
      });
    });

    final response = await fightPVE(widget.userId, widget.guildId);

    if (response.statusCode == 200) {
      final result = response.body;
      setState(() {
        fightResult = result;
        showConfetti = fightResult.contains("Bandit is dead");
        if (showConfetti) _confettiController.play();
      });
    } else {
      setState(() {
        fightResult = "Error: ${response.body}";
        showConfetti = false;
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ShakeWidget(
            shakeConstant: ShakeLittleConstant1(),
            autoPlay: isShaking,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCharacterCard(widget.heroModel.Avatar, widget.heroModel.name),
                      const SizedBox(width: AppValues.SizedBoxHeight),
                      const Text("VS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(width: AppValues.SizedBoxHeight),
                      _buildCharacterCard("https://cdnb.artstation.com/p/assets/images/images/079/571/635/large/ben-hudson-bandit.jpg?1725281428", "Bandit"),
                    ],
                  ),
                  const SizedBox(height: AppValues.SizedBoxHeight),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.info,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: fight,
                    child: const Text("⚔️ Fight ⚔️"),
                  ),
                  const SizedBox(height: AppValues.SizedBoxHeight),
                  Text(
                    fightResult,
                    style: TextStyle(
                      fontSize: 18,
                      color: fightResult.contains("Bandit is dead") ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showConfetti)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: 3.14 / 2,
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.yellow,
                  Colors.red,
                  Colors.purple,
                  Colors.orange
                ],
                emissionFrequency: 0.05,
                numberOfParticles: 50,
                gravity: 0.1,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCharacterCard(String imageUrl, String name) {
    return Column(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 2),
            image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 5),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
