import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


final String ip = dotenv.env["BACKEND_IP"] ?? "http://192.168.4.220:8080";

Future<List<String>> fetchBotGuilds() async {
  try {
    final response = await http.get(
      Uri.parse('$ip/api/getBotGuilds'),
    );

    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      print('Failed to fetch bot guilds: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error fetching bot guilds: $e');
    return [];
  }
}
