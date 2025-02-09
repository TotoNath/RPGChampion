import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/database/database.dart';
import 'package:frontend/database/model/hero_model.dart';
import 'package:frontend/database/model/user_model.dart';
import 'package:frontend/screen/hero_details/hero_details.dart';
import 'package:frontend/service/hero_service.dart';
import 'package:get/get.dart';

class GuildDetailsPage extends StatefulWidget {
  final Guild guild;

  const GuildDetailsPage({Key? key, required this.guild}) : super(key: key);

  @override
  _GuildDetailsPageState createState() => _GuildDetailsPageState();
}

class _GuildDetailsPageState extends State<GuildDetailsPage> {
  late Future<List<HeroModel>> _heroesFuture = Future.value([]);
  String? selectedHeroName;
  late String curUserId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSelectedHero();
  }

  Future<void> _loadUserData() async {
    final db = Database();
    await db.init();
    final isar = db.isar;

    final user = await isar.users.get(1);
    curUserId = user!.discordId;

    if (user != null) {
      setState(() {
        _heroesFuture = fetchHeroes(user.discordId, widget.guild.guildId);
      });
    } else {
      setState(() {
        _heroesFuture = Future.value([]);
      });
      print('User not found');
    }
  }

  Future<void> _loadSelectedHero() async {
    final db = Database();
    await db.init();
    final isar = db.isar;

    final user = await isar.users.get(1);

    if (user != null) {
      final selectedHero =
          await getSelectedHero(user.discordId, widget.guild.guildId);
      setState(() {
        selectedHeroName = selectedHero;
      });
    }
  }

  Future<void> createHero(String heroName) async {
    try {
      // Les données utilisateur nécessaires
      final db = Database();
      await db.init();
      final isar = db.isar;
      final user = await isar.users.get(1);

      if (user == null) {
        Fluttertoast.showToast(
            msg: "Utilisateur introuvable.", gravity: ToastGravity.BOTTOM);
        return;
      }

      final response = await createHeroes(
          user.discordId, user.username, widget.guild.guildId, heroName);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Héros \"$heroName\" créé avec succès!",
          gravity: ToastGravity.BOTTOM,
        );

        // Rafraîchir la liste des héros après 100 ms
        Future.delayed(const Duration(milliseconds: 100), _loadUserData);
      } else {
        Fluttertoast.showToast(
          msg: "Erreur lors de la création du héros.",
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Erreur réseau : $e",
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> renameHero(HeroModel hero, String newHeroName) async {
    try {
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

      final response = await renameHeroApi(
        newHeroName,
        user.discordId,
        widget.guild.guildId,
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Héros renommé avec succès en \"$newHeroName\"!",
          gravity: ToastGravity.BOTTOM,
        );
        _loadUserData(); // Rafraîchir les données après la modification
      } else {
        Fluttertoast.showToast(
          msg: "Erreur lors du renommage du héros.",
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Erreur réseau : $e",
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> deleteHero(HeroModel hero) async {
    try {
      // Récupération des données utilisateur nécessaires
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

      final response =
      await deleteHeroes(user.discordId, widget.guild.guildId, hero.name);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Héros \"${hero.name}\" supprimé avec succès!",
          gravity: ToastGravity.BOTTOM,
        );

        // Rafraîchir la liste des héros
        _loadUserData();
      } else {
        Fluttertoast.showToast(
          msg: "Erreur lors de la suppression du héros.",
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Erreur réseau : $e",
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _showRenameHeroDialog(HeroModel hero) {
    final TextEditingController _renameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Renommer le héros"),
          content: TextField(
            controller: _renameController,
            decoration: const InputDecoration(
              labelText: "Nouveau nom",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                final newHeroName = _renameController.text.trim();
                if (newHeroName.isNotEmpty) {
                  renameHero(hero, newHeroName);
                  Navigator.of(context).pop();
                } else {
                  Fluttertoast.showToast(
                    msg: "Veuillez entrer un nouveau nom valide.",
                    gravity: ToastGravity.BOTTOM,
                  );
                }
              },
              child: const Text("Renommer"),
            ),
          ],
        );
      },
    );
  }

  void _showCreateHeroDialog() {
    final TextEditingController _heroNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Créer un nouveau héros"),
          content: TextField(
            controller: _heroNameController,
            decoration: const InputDecoration(
              labelText: "Nom du héros",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                final heroName = _heroNameController.text.trim();
                if (heroName.isNotEmpty) {
                  createHero(heroName);
                  Navigator.of(context).pop();
                } else {
                  Fluttertoast.showToast(
                    msg: "Veuillez entrer un nom de héros valide.",
                    gravity: ToastGravity.BOTTOM,
                  );
                }
              },
              child: const Text("Créer"),
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
                    return const Center(child: Text("Aucun héros trouvé."));
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
                                hero: hero,
                                guild: widget.guild,
                                isSelected: selectedHeroName,
                            userId: curUserId),
                            transition: Transition.rightToLeftWithFade,
                            duration: const Duration(milliseconds: 500),
                          );
                        },
                        child: Center(
                          child: HeroCard(
                            hero: hero,
                            onDelete: (heroToDelete) {
                              // Confirmation avant suppression
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title:
                                        const Text("Confirmer la suppression"),
                                    content: Text(
                                        "Voulez-vous vraiment supprimer le héros \"${heroToDelete.name}\" ?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text("Annuler"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          deleteHero(heroToDelete);
                                        },
                                        child: const Text("Supprimer"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            onRename: (heroToRename) =>
                                _showRenameHeroDialog(heroToRename),
                            isSelected: hero.name == selectedHeroName,
                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateHeroDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class HeroCard extends StatelessWidget {
  final HeroModel hero;
  final Function onDelete;
  final Function onRename;
  final bool isSelected;

  const HeroCard(
      {Key? key,
      required this.hero,
      required this.onDelete,
      required this.isSelected,
      required this.onRename})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Carte principale
        Container(
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
                  color: hero.Avatar.isEmpty ? Colors.grey.shade400 : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: hero.Avatar.isEmpty
                    ? null
                    : Image.network(hero.Avatar),
              ),
              const SizedBox(height: 10),
              // Nom du héros
              Text(hero.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              // Stats
              Text("${hero.hp}\t\t❤️"),
              Text("${hero.experience}\t\t ⭐ XP"),
              Text("${hero.level}\t\t 🎯 Level"),
              const SizedBox(height: 10),
              if (isSelected)
                const Text(
                  "Ce héros est sélectionné",
                  style: TextStyle(color: Colors.green, fontSize: 14),
                ),
            ],
          ),
        ),
        Positioned(
          bottom: 30,
          right: 20,
          child: GestureDetector(
            onTap: () => onDelete(hero),
            child: const Icon(Icons.delete, color: Colors.red),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 20,
          child: GestureDetector(
            onTap: () => onRename(hero),
            child: const Icon(Icons.edit, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
