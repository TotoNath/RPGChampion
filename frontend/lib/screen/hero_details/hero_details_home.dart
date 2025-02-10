import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/constant/color.dart';
import 'package:frontend/constant/values.dart';
import 'package:frontend/database/database.dart';
import 'package:frontend/database/model/hero_model.dart';
import 'package:frontend/database/model/user_model.dart';
import 'package:frontend/screen/home/home.dart';
import 'package:frontend/service/hero_service.dart';
import 'package:frontend/widgets/buttons/avatar_button.dart';
import 'package:get/get.dart';

class HeroDetailsHome extends StatefulWidget {
  const HeroDetailsHome({
    super.key,
    required this.onUpdate,
    required this.hero,
    required this.guild, required this.userId,
  });

  final HeroModel hero;
  final String userId;
  final Guild guild;
  final VoidCallback onUpdate;

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.background, AppColors.backgroundgrad],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  // Utilisation d'un Column pour éviter l'overflow
                  children: [
                    Expanded(
                      // Permet à SingleChildScrollView de prendre toute la place disponible
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => const HomePage(),
                                  transition: Transition.rightToLeftWithFade,
                                  duration: const Duration(
                                      milliseconds:
                                          AppValues.TransitionDurationTO),
                                );
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        widget.guild.iconUrl),
                                    backgroundColor: Colors.grey.shade200,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    widget.guild.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(thickness: 1, color: Colors.white30),
                            Center(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                      widget.hero.name,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  HeroAvatar(hero: widget.hero),
                                  const SizedBox(
                                      height: AppValues.SizedBoxHeight),
                                  StatsRow(label: "❤️ Vie", value: widget.hero.hp),
                                  StatsRow(
                                      label: "🏋️ Force", value: widget.hero.strength),
                                  StatsRow(
                                      label: "🤸 Agilité", value: widget.hero.ability),
                                  StatsRow(
                                      label: "🎯 Niveau", value: widget.hero.level),
                                  StatsRow(
                                      label: "⭐ Expérience",
                                      value: widget.hero.experience),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () async {
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
                                          widget.hero.name,
                                          user.discordId,
                                          widget.guild.guildId);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isSelected
                                          ? Colors.green
                                          : AppColors.info,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 20),
                                    ),
                                    child: Text(
                                      isSelected
                                          ? "✅ Héros sélectionné"
                                          : "Sélectionner ce héros",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: AvatarButton(
                  userId: widget.userId,
                  guildId: widget.guild.guildId,
                  heroName: widget.hero.name,
                  onAvatarUpdated: widget.onUpdate,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget pour afficher l'avatar du héros
class HeroAvatar extends StatelessWidget {
  final dynamic hero;

  const HeroAvatar({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [const BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: hero.Avatar.isEmpty
          ? const Icon(Icons.person, size: 100, color: Colors.white)
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(hero.Avatar, fit: BoxFit.cover),
            ),
    );
  }
}

/// Widget pour afficher une statistique du héros
class StatsRow extends StatelessWidget {
  final String label;
  final dynamic value;

  const StatsRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Text("$value",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70)),
        ],
      ),
    );
  }
}
