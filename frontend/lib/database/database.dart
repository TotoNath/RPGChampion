import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'model/user_model.dart';

/// ## Database
///
/// Acces a la base de données Isar
///
/// ### Auteur : Nguiquerro
class Database {
  late final Isar _isar;

  Isar get isar => _isar;

  Future<void> init() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [UserSchema, GuildSchema],
        directory: dir.path,
      );
    } else {
      _isar = Isar.getInstance()!;
    }
  }
}