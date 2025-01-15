import 'package:flutter/material.dart';
import 'package:frontend/screen/guild_details/guild_details.dart';
import 'package:get/get.dart';
import 'package:frontend/database/database.dart';
import 'package:frontend/database/model/user_model.dart';
import 'package:isar/isar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Map<String, dynamic>> fetchData() async {
    final db = Database();
    await db.init();

    // Récupérer l'utilisateur (un seul dans la base)
    final user = await db.isar.users.get(1);

    // Récupérer les guilds associées et les trier par nom
    final guilds = (await db.isar.guilds.where().findAll())
      ..sort((a, b) => a.name.compareTo(b.name));

    return {
      "user": user,
      "guilds": guilds,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Erreur: ${snapshot.error}"));
            }

            if (snapshot.hasData) {
              final user = snapshot.data!["user"] as User;
              final guilds = snapshot.data!["guilds"] as List<Guild>;

              return Column(
                children: [
                  // Section utilisateur
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(user.avatarUrl),
                        ),
                        const SizedBox(height: 10),
                        // Nom d'utilisateur
                        Text(
                          capitalize(user.username),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 1, color: Colors.grey),

                  // Liste des serveurs
                  Expanded(
                    child: ListView.builder(
                      itemCount: guilds.length,
                      itemBuilder: (context, index) {
                        final guild = guilds[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(guild.iconUrl),
                            backgroundColor: Colors.grey.shade200,
                          ),
                          title: Text(
                            guild.name,
                            style: const TextStyle(fontSize: 18),
                          ),
                          onTap: () {
                            // Navigation vers la page de détails
                            Get.to(
                                  () => GuildDetailsPage(guild: guild),
                              transition: Transition.topLevel,
                              duration: const Duration(milliseconds: 500),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            return const Center(child: Text("Aucune donnée trouvée"));
          },
        ),
      ),
    );
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
