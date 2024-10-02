import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cookeazy/page/Menu_principale.dart';
import 'commandes.dart';
import '../models/Foot.dart';
import '../services/provider.dart';
import 'package:provider/provider.dart';
import '../models/commandes.dart';

class DetaillePage extends StatefulWidget {
  final String mealsId;
  final int quantity; // Changed to camelCase
  const DetaillePage(
      {super.key,
      required this.mealsId,
      required this.quantity}); // Adjust constructor

  @override
  State<DetaillePage> createState() => _DetaillePageState();
}

class _DetaillePageState extends State<DetaillePage> {
  List<MealDetail> mealDetails = [];
  int selectedQuantity = 1; // Ensure this is defined
  bool isLoading = true;
  String apiUrl =
      'https://node-js-api-0ytm.onrender.com/mealsdetail'; // Replace with your actual API URL

  @override
  void initState() {
    super.initState();
    fetchMealDetails();
  }

  Future<void> fetchMealDetails() async {
    try {
      final response = await http
          .get(Uri.parse('$apiUrl/${widget.mealsId}')); // Use widget.mealsId

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          mealDetails = [
            MealDetail.fromJson(data)
          ]; // Assuming you get a single meal detail
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load meal details');
      }
    } catch (error) {
      print('Error fetching meal details: $error');
      setState(() {
        isLoading = false;
      });
    }
  }
  // ... (le reste de votre code)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Ligne de navigation supérieure
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MenuPrincipale(
                                foot: [],
                              )),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(CupertinoIcons.chevron_back, size: 30),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text("Detaille"),
              const SizedBox(height: 10),
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(color: Colors.white),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_active),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20), // Espacement
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: mealDetails.length,
                      itemBuilder: (context, index) {
                        final meal = mealDetails[index]; // Récupérer le repas

                        return Column(
                          children: [
                            // Section d'image avec description
                            SizedBox(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 55),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        meal.imagePath,
                                        fit: BoxFit.cover,
                                        width: 280,
                                        height: 300,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Container(
                                      height: 160,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                meal.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${meal.price}\$',
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 30),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.orange,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                      left:
                                                          Radius.circular(10)),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              selectedQuantity++; // Augmenter la quantité
                                            });
                                          },
                                          icon: const Icon(Icons.add),
                                        ),
                                        IconButton(
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.orange,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                      right:
                                                          Radius.circular(10)),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (selectedQuantity > 1) {
                                                selectedQuantity--; // Diminuer la quantité, minimum 1
                                              }
                                            });
                                          },
                                          icon: const Icon(Icons.remove),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                meal.description,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.yellow, size: 30),
                                  Icon(Icons.star,
                                      color: Colors.yellow, size: 30),
                                  Icon(Icons.star,
                                      color: Colors.yellow, size: 30),
                                  Icon(Icons.star_half,
                                      color: Colors.yellow, size: 30),
                                  Icon(Icons.star_border,
                                      color: Colors.yellow, size: 30),
                                ],
                              ),
                            ),
                            // Bouton "Commander" pour chaque meal
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Créer une nouvelle commande
                                    Commande nouvelleCommande = Commande(
                                      id: meal.id,
                                      name: meal.name,
                                      price: meal.price,
                                      quantity: selectedQuantity,
                                      // totalAmount:
                                      //  meal.price * selectedQuantity,
                                      rating: meal.rating,
                                      userComment:
                                          '', // Ajoutez un champ pour le commentaire si nécessaire
                                    );

                                    // Ajouter la commande au Provider
                                    final commandeProvider =
                                        Provider.of<CommandeProvider>(context,
                                            listen: false);
                                    commandeProvider.addOrder(nouvelleCommande);
                                    //Provider.of<CommandeProvider>(context, listen: false).commanderCommande(nouvelleCommande);

                                    // Naviguer vers la page Commandes
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Commandes(
                                              commandes:
                                                  commandeProvider.orders,
                                              detailId: meal
                                                  .id)), // Remplacez par votre CommandesPage
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                  ),
                                  child: const Text(
                                    "Commander",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
