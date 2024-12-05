import 'package:flutter/material.dart';
import 'package:frontend/constant/color.dart';
import 'package:frontend/database/database.dart';
import 'package:frontend/database/model/hero_model.dart';
import 'package:frontend/database/model/user_model.dart';
import 'package:frontend/screen/hero_details/hero_details.dart';
import 'package:get/get.dart';
import 'package:frontend/service/hero_service.dart';
import 'package:isar/isar.dart';

class GuildDetailsPage extends StatefulWidget {
  final Guild guild;

  const GuildDetailsPage({Key? key, required this.guild}) : super(key: key);

  @override
  _GuildDetailsPageState createState() => _GuildDetailsPageState();
}

class _GuildDetailsPageState extends State<GuildDetailsPage> {
  late Future<List<HeroModel>> _heroesFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Initialiser la base de données et sauvegarder l'utilisateur
    final db = Database();
    await db.init();
    final isar = db.isar;

    // Récupérer l'utilisateur connecté en utilisant discordId ou une autre clé
    final user = await isar.users.get(0);

    if (user != null) {
      // Utiliser les informations récupérées pour appeler fetchHeroes
      setState(() {
        _heroesFuture = fetchHeroes(user.discordId, widget.guild.id as String);
      });
    } else {
      // Gérer le cas où l'utilisateur n'est pas trouvé
      setState(() {
        _heroesFuture = Future.value([]); // Définit une liste vide
      });
      print('User not found');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // En-tête du serveur
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
              child: FutureBuilder<List<HeroModel>>(
                future: _heroesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Erreur: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Aucun héros trouvé."));
                  }

                  final heroes = snapshot.data!;

                  return ListView.builder(
                    itemCount: heroes.length,
                    itemBuilder: (context, index) {
                      final hero = heroes[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                                () => HeroDetailsPage(
                                hero: hero, guild: widget.guild),
                            transition: Transition.rightToLeftWithFade,
                            duration: const Duration(milliseconds: 500),
                          );
                        },
                        child: Center(
                          child: HeroCard(hero: hero),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeroCard extends StatelessWidget {
  final HeroModel hero;

  const HeroCard({Key? key, required this.hero}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Image de héros
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
          Text(hero.name,
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          // Stats
          Text("${hero.hp} HP"),
          Text("${hero.strength} Strength"),
          Text("${hero.ability} Agility"),
        ],
      ),
    );
  }
}
