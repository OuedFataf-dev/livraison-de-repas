import 'package:cookeazy/page/commandes.dart';
import 'package:flutter/material.dart';
import 'homeAppbar.dart';
import 'SearchBar_page.dart';
import 'Menu_Page.dart';
import 'Menu_principale.dart';
import '../Authentification/profile.dart';
import '../services/connnexion_internet.dart';
import '../models/Foot.dart';
import 'package:http/http.dart' as http;
import ' SingleChildScrollViewpro.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../services/payement.dart'; // Pour le service de paiement
import '../models/commandes.dart';
import '../services/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Meals> allMeals = []; // Liste pour tous les repas
  List<Meals> filteredMeals = []; // list des repas flitree

  void handSearche(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredMeals = allMeals;
      } else {
        filteredMeals = allMeals.where((meal) {
          return meal.name.toLowerCase().contains(query.toLowerCase()) ||
              meal.price.toString().contains(query);
        }).toList(); // Convertit l'itérable en liste
      }
    });
  }

  int currentIndex = 0;
  List<Commande> commandes = [];

  void setcurrentIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      FutureBuilder<List<Meals>>(
        future: fetchFootData(), // Fetch meals data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun repas disponible'));
          } else {
            // Récupérer tous les repas
            List<Meals> allMeals = snapshot.data!;

            // Vérifier si nous avons au moins 1 repas
            if (allMeals.length < 1) {
              return Center(child: Text('Pas assez de repas disponibles.'));
            }

            // Prendre les deux premiers repas
            List<Meals> firstTwoMeals = allMeals.take(2).toList();
            // Prendre le reste des repas
            List<Meals> remainingMeals = allMeals.skip(2).toList();

            // Passer les deux premiers repas à MenuPage
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Homeappbar(),
                  const SizedBox(height: 5),
                  SearchbarPage(onSearch: handSearche),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      width: double.infinity,
                      height: 171,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/poulet.webp'),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Text(
                      'Plats',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SingleChildScroll(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuPrincipale(
                                foot:
                                    remainingMeals, // Passer les repas restants
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Voir tous',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  // Passer les deux premiers repas à MenuPage
                  MenuPage(foot: firstTwoMeals),
                ],
              ),
            );
          }
        },
      ),
      UserProfile(),
      Commandes(
        detailId: '', // Pass the meal ID
        // Calculate and pass total amount
        //commandes: [], //
        commandes: commandes,
      ),
      Center(child: Text("Profile")),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: setcurrentIndex,
        selectedFontSize: 14,
        unselectedFontSize: 20,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.yellow,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            label: 'Accueil',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: ' mes Commandes',
            icon: Icon(Icons.receipt_long),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
