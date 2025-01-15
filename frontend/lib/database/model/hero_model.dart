class HeroModel {
  final String name;
  final int hp;
  final int strength;
  final int ability; // Correspond à agility
  final int level;
  final int experience;
  final String gender;

  HeroModel({
    required this.name,
    required this.hp,
    required this.strength,
    required this.ability,
    required this.level,
    required this.experience,
    required this.gender,
  });

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    return HeroModel(
      name: json['name'],
      hp: json['hp'],
      strength: json['strength'],
      ability: json['agility'], // Notez que backend appelle ça "agility"
      level: json['level'],
      experience: json['experience'],
      gender: json['gender'],
    );
  }
}
