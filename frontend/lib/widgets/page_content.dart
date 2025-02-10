import 'package:flutter/cupertino.dart';
import 'package:frontend/database/model/hero_model.dart';
import 'package:frontend/screen/hero_details/hero_details.dart';
import 'package:frontend/screen/hero_details/hero_details_afk.dart';
import 'package:frontend/screen/hero_details/hero_details_fightpve.dart';
import 'package:frontend/screen/hero_details/hero_details_home.dart';
import 'package:frontend/screen/hero_details/hero_details_info.dart';
import 'package:frontend/screen/hero_details/hero_details_params.dart';
import 'package:frontend/screen/hero_details/hero_details_wake.dart';

/// `PageContent` est un widget qui permet de rendre différentes pages en fonction de l'état `activePage` passé en paramètre.
/// Ce widget sert de container pour afficher différentes sections du profil d'un héros, comme les informations du héros, les paramètres, ou encore les pages liées à des actions spécifiques.
///
/// ### Paramètres :
/// - `activePage` : Une chaîne de caractères qui détermine quelle page doit être affichée. Les pages disponibles incluent : `'home'`, `'afk'`, `'coffee'`, `'sword'`, `'info'`, et `'settings'`.
/// - `widget` : Un objet `HeroDetailsPage`, qui contient les informations nécessaires pour afficher les pages spécifiques du héros.
/// - `heroCount` : Un nombre sous forme de chaîne représentant le nombre de héros dans l'équipe.
/// - `leaderboard` : Un nombre sous forme de chaîne représentant le classement du héros dans le leaderboard.
///
/// ### Fonctionnalités :
/// - **Rendu dynamique des pages** : En fonction de la valeur de `activePage`, le widget affiche une page différente, permettant ainsi de naviguer entre différentes sections du profil d'un héros. Les pages disponibles incluent :
///   - `HeroDetailsHome` : Page d'accueil du héros.
///   - `AfkPage` : Page des héros inactifs.
///   - `WakeUpPage` : Page pour réactiver un héros inactif.
///   - `FightPVEPage` : Page pour les combats contre des ennemis PvE.
///   - `InfoPage` : Page d'information contenant le nombre de héros et le classement du leaderboard.
///   - `Params` : Page des paramètres.
/// - **Gestion des erreurs** : Si la valeur de `activePage` ne correspond à aucune page définie, un message par défaut "Unknown Page" sera affiché.
///
/// ### Méthodes :
/// - **build** : Construit l'interface utilisateur en fonction de la valeur de `activePage` et rend la page correspondante.
class PageContent extends StatelessWidget {
  const PageContent({
    super.key,
    required this.activePage,
    required this.widget,
    required this.heroCount,
    required this.leaderboard,
    required this.heroModel,
    required this.onUpdate,
  });

  final String activePage;
  final HeroDetailsPage widget;
  final String heroCount;
  final HeroModel heroModel;
  final String leaderboard;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    switch (activePage) {
      case 'home':
        return HeroDetailsHome(userId: widget.userId,hero: heroModel,guild: widget.guild, onUpdate: onUpdate);
      case 'afk':
        return AfkPage(userId: widget.userId, guildId: widget.guild.guildId);
      case 'coffee':
        return WakeUpPage(userId: widget.userId, guildId: widget.guild.guildId);
      case 'sword':
        return FightPVEPage(
          userId: widget.userId, guildId: widget.guild.guildId, heroModel:heroModel);
      case 'info':
        return InfoPage(heroCount: heroCount, leaderboard: leaderboard);
      case 'settings':
        return const ParamsPage();
      default:
        return const Center(child: Text("Unknown Page", key: ValueKey("unknown")));
    }
  }
}
