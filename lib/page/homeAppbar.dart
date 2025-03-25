import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Authentification/profile.dart';
import 'screen_pagesmenu.dart';

class Homeappbar extends StatefulWidget {
  const Homeappbar({super.key});

  @override
  State<Homeappbar> createState() => _HomeappbarState();
}

class _HomeappbarState extends State<Homeappbar> {
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Material(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScreenPagesmenu()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.menu, size: 30),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text("Que voulez-vous manger aujourd'hui ?"),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              if (userId != null) {
                print("Profil utilisateur cliqué - ID: $userId");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfile(userId: userId!),
                  ),
                );
              } else {
                print("Aucun utilisateur connecté !");
              }
            },
            child: const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/user.png'),
            ),
          ),
        ],
      ),
    );
  }
}
