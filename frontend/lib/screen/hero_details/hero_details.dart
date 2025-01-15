import 'package:flutter/material.dart';
import 'package:frontend/constant/color.dart';
import 'package:frontend/database/model/hero_model.dart';
import 'package:frontend/database/model/user_model.dart';
import 'package:frontend/screen/hero_details/hero_details_home.dart';
import 'package:frontend/service/hero_service.dart';

class HeroDetailsPage extends StatefulWidget {
  final HeroModel hero;
  final Guild guild;
  final String? isSelected;

  const HeroDetailsPage(
      {super.key,
      required this.hero,
      required this.guild,
      required this.isSelected});

  @override
  State<HeroDetailsPage> createState() => _HeroDetailsPageState();
}

class _HeroDetailsPageState extends State<HeroDetailsPage> {
  // Page active (par défaut sur 'home')
  String activePage = 'home';
  String heroCount = "0";

  String leaderboard = "Loading ...";

  @override
  void initState() {
    super.initState();
    _fetchHeroCount();
    _fetchLeaderboard();
  }

  Future<void> _fetchHeroCount() async {
    try {
      final count = await getHeroCount();
      setState(() {
        heroCount = count;
      });
    } catch (e) {
      setState(() {
        heroCount = "Error";
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
        leaderboard = "Error";
      });
    }
  }

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
                      _buildDrawerIcon(
                        context: context,
                        page: 'home',
                        icon: Icons.home,
                        selectedIcon: Icons.home_outlined,
                        onPressed: () {
                          setState(() {
                            activePage = 'home';
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildDrawerIcon(
                        context: context,
                        page: 'emotions',
                        icon: Icons.emoji_emotions,
                        selectedIcon: Icons.emoji_emotions_outlined,
                        onPressed: () {
                          setState(() {
                            activePage = 'emotions';
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildDrawerIcon(
                        context: context,
                        page: 'shield',
                        icon: Icons.shield,
                        selectedIcon: Icons.shield_outlined,
                        onPressed: () {
                          setState(() {
                            activePage = 'shield';
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                const SizedBox(height: 20),
                _buildDrawerIcon(
                  context: context,
                  page: 'info',
                  icon: Icons.info,
                  selectedIcon: Icons.info_outline,
                  onPressed: () {
                    setState(() {
                      activePage = 'info';
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildDrawerIcon(
                  context: context,
                  page: 'settings',
                  icon: Icons.settings,
                  selectedIcon: Icons.settings_outlined,
                  onPressed: () {
                    setState(() {
                      activePage = 'settings';
                    });
                  },
                ),
                const SizedBox(height: 20),

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

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    // Légère animation latérale
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: _buildPageContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerIcon({
    required BuildContext context,
    required String page,
    required IconData icon,
    required IconData selectedIcon,
    required VoidCallback onPressed,
  }) {
    final bool isActive = (activePage == page);

    return TweenAnimationBuilder<double>(
      tween:
          Tween<double>(begin: isActive ? 1.3 : 0.8, end: isActive ? 1.3 : 0.8),
      duration: const Duration(milliseconds: 200),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon),
            iconSize: 30,
            color: Colors.white,
            splashRadius: 30,
            splashColor: Colors.white,
            selectedIcon: Icon(selectedIcon),
            isSelected: !isActive,
            highlightColor: Colors.transparent,
            tooltip: page,
          ),
        );
      },
    );
  }

  Widget _buildPageContent() {
    switch (activePage) {
      case 'home':
        return HeroDetailsHome(widget: widget);
      case 'emotions':
        return Center(child: Text("Emotions Page", key: ValueKey("emotions")));
      case 'shield':
        return Center(child: Text("Shield Page", key: ValueKey("shield")));
      case 'info':
        return _buildInfoPage();
      case 'settings':
        return _buildSettingsPage();
      default:
        return Center(child: Text("Unknown Page", key: ValueKey("unknown")));
    }
  }

  Widget _buildInfoPage() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Informations RPGChampion",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              " $heroCount",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              "Leaderboard du serveur :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  leaderboard,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsPage() {
    return Center(
      child: Text("Page des paramètres"),
    );
  }
}
