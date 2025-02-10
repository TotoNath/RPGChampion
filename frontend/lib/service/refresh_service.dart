import 'dart:convert';
import 'package:frontend/service/hero_service.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/database/model/hero_model.dart';

Future<HeroModel?> fetchHeroByName(String userId, String guildId, String heroName) async {
  try {
    List<HeroModel> heroes = await fetchHeroes(userId, guildId);

    // Recherche du héros par son nom
    HeroModel? hero = heroes.firstWhere(
          (hero) => hero.name.toLowerCase() == heroName.toLowerCase(),
    );

    return hero;
  } catch (e) {
    print("Erreur lors de la récupération du héros: $e");
    return null;
  }
}
