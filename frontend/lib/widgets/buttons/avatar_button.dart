import 'package:flutter/material.dart';
import 'package:frontend/constant/values.dart';
import 'package:frontend/service/hero_service.dart';

class AvatarButton extends StatelessWidget {
  final String userId;
  final String guildId;
  final String heroName;
  final VoidCallback onAvatarUpdated;

  AvatarButton({required this.userId, required this.guildId, required this.heroName, required this.onAvatarUpdated});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FloatingActionButton(
        onPressed: () => _showAvatarDialog(context),
        backgroundColor: Colors.blueAccent,
        elevation: 6,
        child: const Icon(Icons.image, size: 28, color: Colors.white),
      ),
    );
  }

  void _showAvatarDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.edit, color: Colors.blueAccent),
            SizedBox(width: 10),
            Text("Changer l'avatar", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Wrap(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Entrer l'URL des l'image",
                  prefixIcon: const Icon(Icons.link, color: Colors.blueAccent),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler", style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              String url = controller.text.trim();
              if (Uri.parse(url).isAbsolute && (url.endsWith(".png") || url.endsWith(".jpg") || url.endsWith(".jpeg"))) {
                await setAvatar(url, userId, guildId);
                Navigator.pop(context);
                onAvatarUpdated();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Avatar mis à jour avec succès!",style: TextStyle(color: Colors.white),),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("URL invalide, veuillez entrer une image valide!",style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: const Text("Valider", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

}
