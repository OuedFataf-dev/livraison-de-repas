import 'package:flutter/material.dart';
import '../Authentification/profile.dart';
import 'screen_pagesmenu.dart';

class Homeappbar extends StatefulWidget {
  const Homeappbar({super.key});

  @override
  State<Homeappbar> createState() => _HomeappbarState();
}

class _HomeappbarState extends State<Homeappbar> {
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
                    MaterialPageRoute(
                        builder: (context) => const ScreenPagesmenu()));
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.menu,
                  size: 30,
                  weight: 10,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text("Que-voulez-vous manger aujoudhui"),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UserProfile()));
            },
            child: const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/user.png')),
          ),
        ],
      ),
    );
  }
}
