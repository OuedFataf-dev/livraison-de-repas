import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Menu.dart';
import 'Detaille_Page.dart';
import '../Authentification/profile _cusinier.dart';
import '../Authentification/profile.dart';
import '../page/detaille_menu.dart';

class ScreenPagesmenu extends StatefulWidget {
  const ScreenPagesmenu({super.key});

  @override
  State<ScreenPagesmenu> createState() => _ScreenPagesmenuState();
}

class _ScreenPagesmenuState extends State<ScreenPagesmenu> {
  late Future<List<Menu>> futureMenuData;
  List<Menu> menuList = []; // Liste des menus

  @override
  void initState() {
    super.initState();
    futureMenuData = fetchMenuData();
  }

  Future<List<Menu>> fetchMenuData() async {
    final response = await http.get(
        Uri.parse('https://node-js-api-0ytm.onrender.com/menu/recuperer-menu'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['menu'] != null && jsonResponse['menu'] is List) {
        menuList = (jsonResponse['menu'] as List)
            .map((menuJson) => Menu.fromJson(menuJson))
            .toList();
        return menuList;
      } else {
        throw Exception('Aucun menu trouvé');
      }
    } else {
      throw Exception('Erreur lors de la récupération des menus');
    }
  }

  // Variables de filtrage
  String selectedCuisine = 'All';
  double selectedMaxPrice = 20.0;
  bool showPopularOnly = false;

  // Liste des types de cuisine pour le filtre
  final List<String> cuisineTypes = ['All', 'Italian', 'Japanese', 'Mexican'];

  // Filtrer la liste des menus en fonction des critères sélectionnés
  List<Menu> get filteredMenuList {
    return menuList.where((menu) {
      // Filtre par type de cuisine
      if (selectedCuisine != 'All' && menu.cuisineType != selectedCuisine) {
        return false;
      }
      // Filtre par prix
      if (menu.price > selectedMaxPrice) {
        return false;
      }
      // Filtre par popularité
      if (showPopularOnly && !menu.popular) {
        return false;
      }
      return true;
    }).toList();
  }
  // Variables de filtrage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            // Section de filtrage
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dropdown pour le type de cuisine
                  DropdownButton<String>(
                    value: selectedCuisine,
                    items: cuisineTypes.map((String cuisine) {
                      return DropdownMenuItem<String>(
                        value: cuisine,
                        child: Text(cuisine),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCuisine = value!;
                      });
                    },
                  ),
                  // Slider pour le prix maximum
                  Column(
                    children: [
                      Text(
                          'Max Price: \$${selectedMaxPrice.toStringAsFixed(2)}'),
                      Slider(
                        value: selectedMaxPrice,
                        min: 0,
                        max: 45,
                        divisions: 45,
                        label: '\$${selectedMaxPrice.toStringAsFixed(2)}',
                        onChanged: (value) {
                          setState(() {
                            selectedMaxPrice = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Popular Only'),
                        Checkbox(
                          value: showPopularOnly,
                          onChanged: (value) {
                            setState(() {
                              showPopularOnly = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  )
                  // Checkbox pour afficher uniquement les populaires
                ],
              ),
            ),
            // Liste des menus filtrés
            Expanded(
              child: FutureBuilder<List<Menu>>(
                future: futureMenuData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final filteredMenus = filteredMenuList;
                    return ListView.builder(
                      itemCount: filteredMenus.length,
                      itemBuilder: (context, index) {
                        final menu = filteredMenus[index];
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const UserProfile(),
                                      ),
                                    );
                                  },
                                  child: const CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                      'https://plus.unsplash.com/premium_photo-1675252369719-dd52bc69c3df?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        menu.name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MenuDetailPage(
                                                        menuId: menu.id)),
                                          );
                                        },
                                        child: Text(
                                          'Cuisine: ${menu.cuisineType}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Chef ID: ${menu.chefId}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '\$${menu.price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.star,
                                                  color: Colors.amber,
                                                  size: 20),
                                              Text(
                                                '${menu.rating}/5',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      if (menu.popular)
                                        Chip(
                                          label: const Text('Popular'),
                                          backgroundColor: Colors.green[100],
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    // If there's no data, show an empty state
                    return const Center(child: Text('Aucun menu disponible'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}