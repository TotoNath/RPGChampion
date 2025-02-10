import 'package:isar/isar.dart';

part 'user_model.g.dart';

/// ## User
///
/// Représente un utilisateur de l'application après l'authentification Discord
///
/// ### Auteur : Nguiquerro
@Collection()
class User {
  Id id = Isar.autoIncrement;

  late String discordId;
  late String username;
  late String discriminator;
  late String avatarUrl;

  final guilds = IsarLinks<Guild>();
}

@Collection()
class Guild {
  Id id = Isar.autoIncrement;

  late String guildId;
  late String name;
  late String iconUrl;
}
