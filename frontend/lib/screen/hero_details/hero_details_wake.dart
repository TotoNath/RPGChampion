import 'package:flutter/material.dart';

import '../../service/hero_service.dart';

class WakeUpPage extends StatefulWidget {
  final String userId;
  final String guildId;

  const WakeUpPage({super.key, required this.userId, required this.guildId});

  @override
  _WakeUpPageState createState() => _WakeUpPageState();
}

class _WakeUpPageState extends State<WakeUpPage> {
  String wakeResult = "";

  Future<void> wake() async {
    final response = await wakeUpHero(widget.userId, widget.guildId);
    setState(() {
      wakeResult = response.body;
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
                onPressed: wake,
                child: const Text("Rentrer"),
              ),
              Text(
                wakeResult,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),],)


      ),
    );
  }
}
