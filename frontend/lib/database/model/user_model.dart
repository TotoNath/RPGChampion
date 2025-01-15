import 'package:isar/isar.dart';

part 'user_model.g.dart';

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
