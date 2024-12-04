import 'dart:convert';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:frontend/database/database.dart';
import 'package:frontend/database/model/user_model.dart';
import 'package:frontend/screen/home/home.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final FlutterAppAuth appAuth = FlutterAppAuth();

Future<void> loginWithDiscord() async {
  try {
    final AuthorizationTokenResponse? result =
        await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        '1261009296339111968', // Discord bot client id
        'rpgchampion://auth',
        serviceConfiguration: AuthorizationServiceConfiguration(
          authorizationEndpoint: 'https://discord.com/api/oauth2/authorize',
          tokenEndpoint: 'https://discord.com/api/oauth2/token',
        ),
        scopes: [
          'identify', // Récupérer les infos de base utilisateur
          'guilds', // Accéder aux guildes de l'utilisateur
          'guilds.members.read' // Accéder aux membres des guildes
        ],
      ),
    );

    if (result != null) {
      // Récupérer les informations utilisateur
      final userResponse = await http.get(
        Uri.parse('https://discord.com/api/users/@me'),
        headers: {
          'Authorization': 'Bearer ${result.accessToken}',
        },
      );

      if (userResponse.statusCode == 200) {
        final userInfo = json.decode(userResponse.body);
        String discordId = userInfo['id'];
        String username = userInfo['username'];
        String discriminator = userInfo['discriminator'];
        String avatarUrl =
            'https://cdn.discordapp.com/avatars/$discordId/${userInfo['avatar']}.png';

        // Créer l'instance de l'utilisateur
        final user = User()
          ..discordId = discordId
          ..username = username
          ..discriminator = discriminator
          ..avatarUrl = avatarUrl;

        // Initialiser la base de données et sauvegarder l'utilisateur
        final db = Database();
        await db.init();
        final isar = db.isar;
        final userCollection = isar.users;

        await isar.writeTxn(() async {
          await userCollection.put(user);
        });

        print('User info saved: $username#$discriminator');
      } else {
        print('Failed to fetch user info: ${userResponse.statusCode}');
      }

      // Récupérer les guildes de l'utilisateur
      final guildsResponse = await http.get(
        Uri.parse('https://discord.com/api/users/@me/guilds'),
        headers: {
          'Authorization': 'Bearer ${result.accessToken}',
        },
      );

      if (guildsResponse.statusCode == 200) {
        final guildsInfo = json.decode(guildsResponse.body);

        final db = Database();
        await db.init(); // Initialise la base de données
        final isar = db.isar;
        final guildCollection = isar.guilds;

        // Sauvegarder les guildes dans la base de données
        await isar.writeTxn(() async {
          for (var guildData in guildsInfo) {
            final guild = Guild()
              ..guildId = guildData['id']
              ..name = guildData['name']
              ..iconUrl =
                  'https://cdn.discordapp.com/icons/${guildData['id']}/${guildData['icon']}.png';

            await guildCollection.put(guild);
          }
        });

        print('Guilds info saved');
        Get.off(() => HomePage());
      } else {
        print('Failed to fetch guilds: ${guildsResponse.statusCode}');
      }
    }
  } catch (e) {
    print('Error during Discord authentication: $e');
  }
}
