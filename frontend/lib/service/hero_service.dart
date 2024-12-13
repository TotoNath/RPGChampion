import 'dart:convert';
import 'package:frontend/database/model/hero_model.dart';
import 'package:http/http.dart' as http;

Future<List<HeroModel>> fetchHeroes(String userId, String guildId) async {
  final url = Uri.parse("http://10.0.2.2:8080/api/heroes/list?userId=$userId&guildId=$guildId");

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> heroJson = jsonDecode(response.body);
    return heroJson.map((json) => HeroModel.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load heroes");
  }
}
