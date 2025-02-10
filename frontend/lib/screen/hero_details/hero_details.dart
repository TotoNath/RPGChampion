import 'package:flutter/material.dart';
import 'package:frontend/constant/color.dart';
import 'package:frontend/constant/values.dart';
import 'package:frontend/database/model/hero_model.dart';
import 'package:frontend/database/model/user_model.dart';
import 'package:frontend/service/hero_service.dart';
import 'package:frontend/service/refresh_service.dart';
import 'package:frontend/widgets/buttons/drawer_button.dart';
import 'package:frontend/widgets/page_content.dart';

/// `HeroDetailsPage` est une page affichant les détails d'un héros dans un contexte de jeu.
/// Elle permet à l'utilisateur de naviguer entre différentes sections via un menu latéral.
///
/// ### Fonctionnalités :
/// - Affiche les informations du héros et du classement.
/// - Permet de naviguer entre plusieurs sections via des icônes (home, combat, repos, réveil, etc.).
/// - Charge dynamiquement le contenu en fonction de la page active.
/// - Utilise des animations pour la transition entre les pages.
///
/// ### Paramètres :
/// - `hero` : Le modèle de données représentant le héros.
/// - `guild` : Informations sur la guilde à laquelle appartient le héros.
/// - `isSelected` : Indique si le héros est sélectionné.
/// - `userId` : Identifiant de l'utilisateur courant.
///
/// ### Auteur : Nguiquerro
class HeroDetailsPage extends StatefulWidget {
  final HeroModel hero;
  final Guild guild;
  final String? isSelected;
  final String userId;

  const HeroDetailsPage(
      {super.key,
      required this.hero,
      required this.guild,
      required this.isSelected,
      required this.userId});

  @override
  State<HeroDetailsPage> createState() => _HeroDetailsPageState();
}

class _HeroDetailsPageState extends State<HeroDetailsPage> {
  String activePage = 'home';
  String heroCount = "0";
  late HeroModel hero;

  String leaderboard = "En cours de chargement ...";

  @override
  void initState() {
    super.initState();
    _fetchHeroCount();
    _fetchLeaderboard();
    hero = widget.hero;
  }

  Future<void> _refreshHeroData() async {
    final updatedHero = await fetchHeroByName(
      widget.userId,
      widget.guild.guildId,
      hero.name,
    );

    if (updatedHero != null) {
      setState(() {
        hero = updatedHero;
      });
    }
  }

  Future<void> _fetchHeroCount() async {
    try {
      final count = await getHeroCount();
      setState(() {
        heroCount = count;
      });
    } catch (e) {
      setState(() {
        heroCount = "Erreur";
      });
    }
  }

  Future<void> _fetchLeaderboard() async {
    try {
      final board = await getLeaderboard(widget.guild.guildId);
      setState(() {
        leaderboard = board;
      });
    } catch (e) {
      setState(() {
        leaderboard = "Erreur";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 100,
            color: AppColors.background,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: AppValues.PaddingTop),
                  child: Column(
                    children: [
                      CustomDrawerButton(
                          activePage: activePage,
                          context: context,
                          page: 'home',
                          icon: Icons.home,
                          selectedIcon: Icons.home_outlined,
                          onPressed: () {
                            setState(() {
                              activePage = 'home';
                            });
                          }),
                      const SizedBox(height: AppValues.SizedBoxHeight),
                      CustomDrawerButton(
                          activePage: activePage,
                          context: context,
                          page: 'sword',
                          icon: Icons.sports_kabaddi,
                          selectedIcon: Icons.sports_kabaddi_outlined,
                          onPressed: () {
                            setState(() {
                              activePage = 'sword';
                            });
                          }),
                      const SizedBox(height: AppValues.SizedBoxHeight),
                      CustomDrawerButton(
                          activePage: activePage,
                          context: context,
                          page: 'afk',
                          icon: Icons.local_hotel,
                          selectedIcon: Icons.local_hotel_outlined,
                          onPressed: () {
                            setState(() {
                              activePage = 'afk';
                            });
                          }),
                      const SizedBox(height: AppValues.SizedBoxHeight),
                      CustomDrawerButton(
                          activePage: activePage,
                          context: context,
                          page: 'coffee',
                          icon: Icons.coffee,
                          selectedIcon: Icons.coffee_outlined,
                          onPressed: () {
                            setState(() {
                              activePage = 'coffee';
                            });
                          }),
                    ],
                  ),
                ),
                const Spacer(),
                const SizedBox(height: AppValues.SizedBoxHeight),
                CustomDrawerButton(
                    activePage: activePage,
                    context: context,
                    page: 'info',
                    icon: Icons.info,
                    selectedIcon: Icons.info_outline,
                    onPressed: () {
                      setState(() {
                        activePage = 'info';
                      });
                    }),
                const SizedBox(height: AppValues.SizedBoxHeight),
                CustomDrawerButton(
                    activePage: activePage,
                    context: context,
                    page: 'settings',
                    icon: Icons.settings,
                    selectedIcon: Icons.settings_outlined,
                    onPressed: () {
                      setState(() {
                        activePage = 'settings';
                      });
                    }),
                const SizedBox(height: AppValues.SizedBoxHeight),
                const Padding(
                  padding: EdgeInsets.only(bottom: AppValues.PaddingBottom),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.monetization_on, color: Colors.amber),
                      SizedBox(width: AppValues.SizedBoxWidth),
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

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: AppValues.TransitionDurationTO),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: PageContent(
                  activePage: activePage,
                  widget: widget,
                  heroCount: heroCount,
                  leaderboard: leaderboard,
                heroModel: hero,
                onUpdate: _refreshHeroData,

              ),
            ),
          ),
        ],
      ),
    );
  }
}
