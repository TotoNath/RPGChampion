import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/service/hero_service.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

class FightPVEPage extends StatefulWidget {
  final String userId;
  final String guildId;

  const FightPVEPage({super.key, required this.userId, required this.guildId});

  @override
  _FightPVEPageState createState() => _FightPVEPageState();
}

class _FightPVEPageState extends State<FightPVEPage> {
  String fightResult = "";
  bool showConfetti = false;
  bool isShaking = false;
  final ConfettiController _confettiController =
  ConfettiController(duration: const Duration(seconds: 2));

  Future<void> fight() async {
    setState(() {
      isShaking = true;
    });

    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        isShaking = false;
      });
    });

    final response = await fightPVE(widget.userId, widget.guildId);

    if (response.statusCode == 200) {
      final result = response.body;
      setState(() {
        fightResult = result;
        if (fightResult.contains("Bandit is dead")) {
          showConfetti = true;
          _confettiController.play();
        } else {
          showConfetti = false;
        }
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
          child:Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text("Hero"),
                    ),
                    const SizedBox(width: 20),
                    const Text("VS"),
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text("Bandit"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: fight,
                  child: const Text("Fight"),
                ),
                const SizedBox(height: 20),
                Text(
                  fightResult,
                  style: TextStyle(
                    fontSize: 18,
                    color: fightResult.contains("Bandit is dead")
                        ? Colors.green
                        : Colors.red,
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
                createParticlePath: (size) {
                  return Path()
                    ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
                },
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.1,
              ),
            ),
        ],
      ),
    );
  }
}
