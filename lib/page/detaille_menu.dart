import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Menu.dart';
import 'Detaille_Page.dart';
import '../Authentification/profile _cusinier.dart';
import '../Authentification/profile.dart';
import '../page/detaille_menu.dart';

class MenuDetailPage extends StatefulWidget {
  final String menuId; // ID du menu à récupérer

  const MenuDetailPage({Key? key, required this.menuId}) : super(key: key);

  @override
  _MenuDetailPageState createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  late Future<MenuDetail> menuDetail;

  // Fonction pour récupérer les détails du menu à partir de l'API
  Future<MenuDetail> fetchMenuDetail() async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.12.60:5000/detaille/${widget.menuId}'),
    );

    if (response.statusCode == 200) {
      return MenuDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur lors du chargement des détails du menu');
    }
  }

  @override
  void initState() {
    super.initState();
    menuDetail = fetchMenuDetail(); // Charger les données du menu au démarrage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Menu',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 25)),
      ),
      body: FutureBuilder<MenuDetail>(
        future: menuDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Aucun menu trouvé'));
          }

          final menuDetail = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Affichage de l'image du menu à partir de l'URL
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.network(menuDetail.imageUrl),
                  ),
                  const SizedBox(height: 16),

                  // Nom et prix
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        menuDetail.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${menuDetail.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Description
                  Text(
                    menuDetail.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Disponibilité
                  Row(
                    children: [
                      const Text(
                        'Disponibilité: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        menuDetail.availability ? 'Disponible' : 'Indisponible',
                        style: TextStyle(
                          color: menuDetail.availability
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Ingrédients
                  const Text(
                    'Ingrédients:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: menuDetail.ingredients.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(menuDetail.ingredients[index]),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Note (étoiles)
                  Row(
                    children: [
                      const Text(
                        'avis : ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < menuDetail.rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${menuDetail.rating}/5'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Chef ID (optionnel)
                  Text(
                    'Préparé par le chef ID: ${menuDetail.chefId}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
