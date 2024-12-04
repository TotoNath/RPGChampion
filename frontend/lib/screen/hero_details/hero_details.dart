import 'package:flutter/material.dart';
import 'package:frontend/constant/color.dart';
import 'package:frontend/database/model/hero_model.dart';
import 'package:frontend/database/model/user_model.dart';
import 'package:frontend/screen/guild_details/guild_details.dart';

class HeroDetailsPage extends StatelessWidget {
  final HeroModel hero;
  final Guild guild;

  const HeroDetailsPage({Key? key, required this.hero, required this.guild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Drawer Toujours Ouvert
          Container(
            width: 100,
            color: AppColors.background, // Couleur de fond du Drawer
            child: Column(
              children: [
                // Icônes en haut du Drawer
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Redirection vers GuildDetailsPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GuildDetailsPage(guild: guild),
                            ),
                          );
                        },
                        icon: const Icon(Icons.home),
                        iconSize: 30,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.emoji_emotions),
                        iconSize: 30,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.shield),
                        iconSize: 30,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Pièces d'or en bas du Drawer
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.monetization_on, color: Colors.amber),
                      SizedBox(width: 5),
                      Text(
                        "50",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Séparation Blanche
          Container(
            width: 0.5,
            color: Colors.grey,
          ),

          // Contenu Principal
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informations sur le serveur
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(guild.iconUrl),
                          backgroundColor: Colors.grey.shade200,
                        ),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          guild.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 1, color: Colors.grey),

                    // Informations du héros
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        hero.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Image et statistiques
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Image du héros
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 100,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Statistiques du héros
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "HP: ${hero.hp}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Ability: ${hero.ability}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Strength: ${hero.strength}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
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
