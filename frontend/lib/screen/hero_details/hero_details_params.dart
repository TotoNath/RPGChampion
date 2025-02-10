import 'package:flutter/material.dart';
import 'package:frontend/constant/color.dart';

/// `ParamsPage` est un widget affichant la page des paramètres.
///
/// ### Fonctionnalités :
/// - Affiche une liste de paramètres génériques.
/// - Design moderne avec icônes et séparation des sections.
/// - Ne contient aucune action fonctionnelle.
///
/// ### Auteur : Nguiquerro
class ParamsPage extends StatelessWidget {
  const ParamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          SizedBox(height: 10),

          // 🔹 Section "Apparence"
          _SettingsSection(title: "🎨 Apparence"),
          _SettingsTile(icon: Icons.dark_mode, title: "Mode sombre"),
          _SettingsTile(icon: Icons.format_size, title: "Taille de la police"),
          Divider(),

          // 🔹 Section "Notifications"
          _SettingsSection(title: "🔔 Notifications"),
          _SettingsTile(icon: Icons.notifications, title: "Notifications push"),
          _SettingsTile(icon: Icons.email, title: "E-mails de mise à jour"),
          Divider(),

          // 🔹 Section "Préférences"
          _SettingsSection(title: "⚙️ Préférences"),
          _SettingsTile(icon: Icons.language, title: "Langue"),
          _SettingsTile(icon: Icons.lock, title: "Confidentialité"),
          _SettingsTile(icon: Icons.info, title: "À propos de l'application"),
        ],
      ),
    );
  }
}

/// 🔹 Widget pour afficher une section de paramètres avec un titre
class _SettingsSection extends StatelessWidget {
  final String title;

  const _SettingsSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.info,
        ),
      ),
    );
  }
}

/// 🔹 Widget pour afficher un élément de la liste des paramètres
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SettingsTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.info),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {}, // Ne fait rien, comme demandé
    );
  }
}
