import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'Meals.pages.dart';
import 'Meals.pages.dart';
import ' Footcart.dart';
import 'Home_pages.dart';
import '../models/Foot.dart';
import 'ajouter.dart';

import '../main.dart';

class MenuPrincipale extends StatefulWidget {
  //final List<Meals> foot;
  final List<Meals> foot;
  const MenuPrincipale({super.key, required this.foot});

  @override
  State<MenuPrincipale> createState() => _MenuPrincipaleState();
}

class _MenuPrincipaleState extends State<MenuPrincipale> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              IconButton(
                  style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      fixedSize: const Size(60, 60),
                      backgroundColor: Colors.white),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PickerFileFromFirebase()));
                  },
                  icon: const Icon(CupertinoIcons.chevron_back)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          fixedSize: const Size(60, 60),
                          backgroundColor: Colors.white),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyApp()));
                      },
                      icon: const Icon(CupertinoIcons.add)),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Menus',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 25),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: IconButton(
                      onPressed: () => {},
                      icon: const Icon(Icons.notifications_active),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            //  Mealspages()
            Mealspages(meals: widget.foot),
            ],
          ),
        ),
      )),
    );
  }
}
