import 'package:flutter/material.dart';
import 'package:frontend/constant/color.dart';
import 'package:frontend/constant/values.dart';
import 'package:frontend/database/model/hero_model.dart';

class HeroCard extends StatelessWidget {
  final HeroModel hero;
  final Function onDelete;
  final Function onRename;
  final bool isSelected;

  const HeroCard({
    Key? key,
    required this.hero,
    required this.onDelete,
    required this.isSelected,
    required this.onRename,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 290,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade800, Colors.grey.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: hero.Avatar.isNotEmpty
                ? Image.network(hero.Avatar, width: 110, height: 110, fit: BoxFit.cover)
                : Container(
              width: 110,
              height: 110,
              color: Colors.grey.shade400,
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            hero.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatText("${hero.hp}", Icons.favorite, Colors.red),
              _buildStatText("${hero.experience}", Icons.star, Colors.yellow),
              _buildStatText("${hero.level}", Icons.emoji_people_sharp, Colors.yellow),
            ],
          ),
          const SizedBox(height: 8),
          if (isSelected)
            const Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                "Ce héros est sélectionné",
                style: TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          const Spacer(),
          Container(
            height: 1,
            color: Colors.black,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onRename(hero),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(hero),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildStatText(String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}
