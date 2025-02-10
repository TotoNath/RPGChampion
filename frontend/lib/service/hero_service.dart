import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/database/model/hero_model.dart';
import 'package:http/http.dart' as http;

final String ip = dotenv.env["BACKEND_IP"] ?? "http://192.168.4.220:8080";

Future<List<HeroModel>> fetchHeroes(String userId, String guildId) async {
  final url = Uri.parse("$ip/api/heroes/list?userId=$userId&guildId=$guildId");

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> heroJson = jsonDecode(response.body);
    return heroJson.map((json) => HeroModel.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load heroes");
  }
}

Future<http.Response> deleteHeroes(
    String userId, String guildId, String heroName) async {
  return await http.delete(
    Uri.parse('$ip/api/heroes/delete'),
    body: {
      'heroName': heroName,
      'userId': userId,
      'guildId': guildId,
    },
  );
}

Future<http.Response> createHeroes(
    String userId, String username, String guildId, String heroName) async {
  return await http.post(
    Uri.parse('$ip/api/heroes/create'),
    body: {
      'heroName': heroName,
      'userId': userId,
      'username': username,
      'guildId': guildId,
    },
  );
}

Future<http.Response> renameHeroApi(
    String newHeroName, String userId, String guildId) async {
  return await http.post(
    Uri.parse('$ip/api/heroes/rename'),
    body: {
      'newHeroName': newHeroName,
      'userId': userId,
      'guildId': guildId,
    },
  );
}

Future<http.Response> selectHeroes(
    String userId, String guildId, String heroesName) async {
  return await http.post(Uri.parse('$ip/api/heroes/select'), body: {
    'heroName': heroesName,
    'userId': userId,
    'guildId': guildId,
  });
}

Future<String?> getSelectedHero(String userId, String guildId) async {
  final url =
      Uri.parse("$ip/api/heroes/selected?userId=$userId&guildId=$guildId");

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    return null;
  }
}

Future<String> getHeroCount() async {
  final url = Uri.parse("$ip/api/heroes/count");

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception("Failed to get hero count");
  }
}

Future<http.Response> fightPVE(String userId, String guildId) async {
  return await http.post(
    Uri.parse('$ip/api/heroes/pve'),
    body: {
      'userId': userId,
      'guildId': guildId,
    },
  );
}

Future<http.Response> afkHero(String userId, String guildId) async {
  return await http.post(
    Uri.parse('$ip/api/heroes/afk'),
    body: {
      'userId': userId,
      'guildId': guildId,
    },
  );
}

Future<http.Response> wakeUpHero(String userId, String guildId) async {
  return await http.post(
    Uri.parse('$ip/api/heroes/wakeUp'),
    body: {
      'userId': userId,
      'guildId': guildId,
    },
  );
}

Future<String> getLeaderboard(String guildId) async {
  final url = Uri.parse("$ip/api/heroes/leaderboard?guildId=$guildId");

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception("Failed to get leaderboard");
  }
}

Future<http.Response> setAvatar(String newAvatar, String userId, String guildId) async {
  return await http.post(
    Uri.parse('$ip/api/heroes/setAvatar'),
    body: {
      'newAvatar': newAvatar,
      'userId': userId,
      'guildId': guildId,
    },
  );
}
