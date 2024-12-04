import 'package:flutter/material.dart';
import 'package:frontend/constant/color.dart';
import 'package:frontend/database/model/hero_model.dart';
import 'package:frontend/database/model/user_model.dart';
import 'package:frontend/screen/hero_details/hero_details.dart';
import 'package:get/get.dart';

class GuildDetailsPage extends StatefulWidget {
  final Guild guild;

  const GuildDetailsPage({Key? key, required this.guild}) : super(key: key);

  @override
  _GuildDetailsPageState createState() => _GuildDetailsPageState();
}

class _GuildDetailsPageState extends State<GuildDetailsPage> {
  // Liste de héros (exemple)
  List<HeroModel> heroes = [
    HeroModel("Hero 1", 100, 10, 5),
    HeroModel("Hero 2", 54, 9, 10),
  ];

  // Méthode pour afficher le formulaire de création de héros
  void _showAddHeroPopup(BuildContext context) {
    final TextEditingController heroNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ajouter un héros"),
          content: TextField(
            controller: heroNameController,
            decoration: const InputDecoration(
              labelText: "Nom du héros",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la popup
              },
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(AppColors.success),
                foregroundColor: WidgetStateProperty.all(AppColors.buttonText),
              ),
              onPressed: () {
                if (heroNameController.text.trim().isNotEmpty) {
                  setState(() {
                    heroes.add(
                        HeroModel(heroNameController.text.trim(), 100, 10, 10));
                  });
                  Navigator.of(context).pop(); // Fermer la popup
                }
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            // Titre du serveur
            CircleAvatar(
              backgroundImage: NetworkImage(widget.guild.iconUrl),
              backgroundColor: Colors.grey.shade200,
            ),
            Text(
              widget.guild.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
                thickness: 1, color: Colors.grey, indent: 20, endIndent: 20),
            const SizedBox(height: 20),

            // Liste des héros
            Expanded(
              child: ListView.builder(
                itemCount: heroes.length,
                itemBuilder: (context, index) {
                  final hero = heroes[index];
                  return GestureDetector(
                    onTap: () {
                      // Aller vers la page HeroDetailsPage
                      Get.to(
                        () => HeroDetailsPage(
                          hero: hero,
                          guild: widget.guild,
                        ),
                        transition: Transition.rightToLeftWithFade,
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                    child: Center(
                      child: Container(
                        width: 250,
                        height: 250,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image de héros (placeholder)
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Nom du héros
                            Text(
                              hero.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Statistiques du héros
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("${hero.hp} HP",
                                    style: const TextStyle(fontSize: 16)),
                                Text("${hero.ability} Ability",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("${hero.strength} Strength",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Section des pièces d'or et bouton d'action
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Pièces d'or
                  const Row(
                    children: [
                      Icon(Icons.monetization_on, color: Colors.amber),
                      SizedBox(width: 5),
                      Text(
                        "50",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  // Bouton flottant (ajouter)
                  FloatingActionButton(
                    backgroundColor: AppColors.success,
                    onPressed: () => _showAddHeroPopup(context),
                    child: const Icon(
                      Icons.add,
                      size: 30,
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
