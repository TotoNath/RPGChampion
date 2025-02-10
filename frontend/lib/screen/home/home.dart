import 'package:flutter/material.dart';
import 'package:frontend/constant/values.dart';
import 'package:frontend/screen/guild_details/guild_details.dart';
import 'package:get/get.dart';
import 'package:frontend/database/database.dart';
import 'package:frontend/database/model/user_model.dart';
import 'package:isar/isar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Map<String, dynamic>> fetchData() async {
    final db = Database();
    await db.init();

    final user = await db.isar.users.get(1);
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
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E1E2C), Color(0xFF23232F)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: FutureBuilder<Map<String, dynamic>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingSkeleton();
              }

              if (snapshot.hasError) {
                return Center(child: Text("Erreur: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
              }

              if (snapshot.hasData) {
                final user = snapshot.data!["user"] as User;
                final guilds = snapshot.data!["guilds"] as List<Guild>;

                return Column(
                  children: [
                    // Section utilisateur améliorée
                    _buildUserHeader(user),

                    // Liste des guildes
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: guilds.length,
                        itemBuilder: (context, index) => _buildGuildCard(guilds[index]),
                      ),
                    ),
                  ],
                );
              }

              return const Center(child: Text("Aucune donnée trouvée", style: TextStyle(color: Colors.white)));
            },
          ),
        ),
      ),
    );
  }

  /// Widget d'en-tête utilisateur avec un design amélioré
  Widget _buildUserHeader(User user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(user.avatarUrl),
            backgroundColor: Colors.grey.shade800,
          ),
          const SizedBox(height: 10),
          Text(
            capitalize(user.username),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 5),
          const Divider(color: Colors.white24, thickness: 1.2),
        ],
      ),
    );
  }

  /// Widget d'affichage des guildes sous forme de cartes stylisées
  Widget _buildGuildCard(Guild guild) {
    return GestureDetector(
      onTap: () {
        Get.to(
              () => GuildDetailsPage(guild: guild),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: AppValues.TransitionDurationTO),
        );
      },
      child: Card(
        color: const Color(0xFF2C2C3C),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(guild.iconUrl),
                backgroundColor: Colors.grey.shade700,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  guild.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Effet de squelette pour le chargement
  Widget _buildLoadingSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const CircleAvatar(radius: 50),
                const SizedBox(height: AppValues.SizedBoxHeight),
                Container(height: 20, width: 150, color: Colors.grey.shade700),
              ],
            ),
          ),
          const Divider(color: Colors.white24, thickness: 1.2),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  color: Colors.grey.shade800,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: const ListTile(
                    leading: CircleAvatar(),
                    title: SizedBox(height: 16, width: 100, child: DecoratedBox(decoration: BoxDecoration())),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Fonction pour capitaliser la première lettre d'un mot
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
