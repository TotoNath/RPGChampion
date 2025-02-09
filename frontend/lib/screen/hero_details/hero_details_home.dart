import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/database/database.dart';
import 'package:frontend/database/model/user_model.dart';
import 'package:frontend/screen/hero_details/hero_details.dart';
import 'package:frontend/screen/home/home.dart';
import 'package:frontend/service/hero_service.dart';
import 'package:get/get.dart';

class HeroDetailsHome extends StatefulWidget {
  const HeroDetailsHome({
    super.key,
    required this.widget,
  });

  final HeroDetailsPage widget;

  @override
  _HeroDetailsHomeState createState() => _HeroDetailsHomeState();
}

class _HeroDetailsHomeState extends State<HeroDetailsHome> {
  bool isSelected = false;

  Future<void> selectHero(
      String heroName, String userId, String guildId) async {
    final response = await selectHeroes(userId, guildId, heroName);

    if (response.statusCode == 200) {
      setState(() {
        isSelected = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informations sur le serveur
            GestureDetector(
              onTap: () {
                Get.to(
                  () => const HomePage(),
                  transition: Transition.rightToLeftWithFade,
                  duration: const Duration(milliseconds: 500),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.widget.guild.iconUrl),
                    backgroundColor: Colors.grey.shade200,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  Text(
                    widget.widget.guild.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1, color: Colors.grey),

            // Informations du héros
            GestureDetector(
              onTap: () async {
                final db = Database();
                await db.init();
                final isar = db.isar;
                final user = await isar.users.get(1);

                if (user == null) {
                  Fluttertoast.showToast(
                    msg: "Utilisateur introuvable.",
                    gravity: ToastGravity.BOTTOM,
                  );
                  return;
                }

                await selectHero(
                  widget.widget.hero.name,
                  user.discordId,
                  widget.widget.guild.guildId,
                );
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.widget.hero.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Image et statistiques
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Image du héros

                        Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: widget.widget.hero.Avatar.isEmpty ? Colors.grey.shade400 : null,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: widget.widget.hero.Avatar.isEmpty
                                ? const Icon(
                              Icons.person,
                              size: 100,
                              color: Colors.white,
                            )
                                : Image.network(widget.widget.hero.Avatar)
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "❤️ : ${widget.widget.hero.hp}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              "🏋️‍♂️️ : ${widget.widget.hero.strength}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "🤸 : ${widget.widget.hero.ability}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Gender : ${widget.widget.hero.gender}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Level 🎯 : ${widget.widget.hero.level}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "XP ⭐ : ${widget.widget.hero.experience}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        if (isSelected || widget.widget.isSelected == widget.widget.hero.name) ...[
                          const SizedBox(height: 10),
                          const Text(
                            "Ce héros est sélectionné",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ],
                    ),
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
