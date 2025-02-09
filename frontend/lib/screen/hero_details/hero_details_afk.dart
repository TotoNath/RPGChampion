import 'package:flutter/material.dart';

import '../../service/hero_service.dart';

class AfkPage extends StatefulWidget {
  final String userId;
  final String guildId;

  const AfkPage({super.key, required this.userId, required this.guildId});

  @override
  _AfkPageState createState() => _AfkPageState();
}

class _AfkPageState extends State<AfkPage> {
  String afkResult = "";

  Future<void> afk() async {
    final response = await afkHero(widget.userId, widget.guildId);
    setState(() {
      afkResult = response.body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: afk,
              child: const Text("Vadrouiller"),
            ),
            const SizedBox(height: 20),
            Text(
              afkResult,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
