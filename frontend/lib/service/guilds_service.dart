import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> fetchBotGuilds() async {
  try {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/getBotGuilds'),
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
