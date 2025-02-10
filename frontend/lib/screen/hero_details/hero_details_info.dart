import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constant/color.dart';
import 'package:frontend/constant/values.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({
    super.key,
    required this.heroCount,
    required this.leaderboard,
  });

  final String heroCount;
  final String leaderboard;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🎮 Informations RPGChampion",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppValues.SizedBoxHeight),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info, width: 2),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.person_3_fill,
                      color: AppColors.info, size: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    // Ajout de Expanded ici pour éviter l'overflow
                    child: Text(
                      "$heroCount",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppValues.SizedBoxHeight),
            const Text(
              "🏆 Classement du serveur :",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: leaderboard
                        .split('\n')
                        .where((line) => line.trim().isNotEmpty)
                        .map((player) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  const Icon(Icons.emoji_events,
                                      color: Colors.orange, size: 24),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    // Ajout de Expanded ici aussi
                                    child: Text(
                                      player,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow
                                          .ellipsis, // Ajout d'ellipsis
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
