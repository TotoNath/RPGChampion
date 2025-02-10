/// ## HeroModel
///
/// Représente un héro constitué d'un nom , hp , strenght ...
///
/// ### Auteur : Nguiquerro
class HeroModel {
  final String name;
  final int hp;
  final int strength;
  final int ability;
  final int level;
  final int experience;
  final String Avatar;
  final String gender;

  HeroModel({
    required this.name,
    required this.hp,
    required this.strength,
    required this.ability,
    required this.level,
    required this.experience,
    required this.Avatar,
    required this.gender,
  });

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    return HeroModel(
      name: json['name'],
      hp: json['hp'],
      strength: json['strength'],
      ability: json['agility'],
      level: json['level'],
      experience: json['experience'],
      Avatar: json['avatar']?? '',
      gender: json['gender'],
    );
  }
}
