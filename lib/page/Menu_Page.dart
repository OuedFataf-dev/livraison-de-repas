import 'package:flutter/material.dart';
import 'Detaille_Page.dart';
import '../models/Foot.dart'; // Importez le modèle de données Meals

class MenuPage extends StatelessWidget {
  final List<Meals> foot; // Accepter une liste de Meals

  const MenuPage({
    super.key,
    required this.foot,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(      scrollDirection: Axis.horizontal, // Défilement horizontal
      child: Row(
        children: List.generate(
          foot.length, // Parcourir chaque élément de la liste foot
          (index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetaillePage(
                      mealsId: foot[index].id,
                      quantity: 1, // Utiliser foot[index].id
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  Column(
                    children: [
                      // Afficher l'image du plat
                      Container(
                        margin: const EdgeInsets.all(3),
                        width: 160, // Largeur de chaque image
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            foot[index]
                                .imageUrl, // Charger l'image depuis l'API
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Nom du plat
                      Text(
                        foot[index].name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "Poppins",
                          fontSize: 15,
                        ),
                      ),
                      // Prix du plat

                      Row(
                        children: [
                          Text(
                            '${foot[index].price} \$', // Format correct pour le prix
                            style: const TextStyle(
                              color: Colors.grey,
                              fontFamily: "Poppins",
                              fontSize: 13,
                            ),
                          ),
                          Icon(Icons.star, color: Colors.yellow, size: 30),
                          Icon(Icons.star, color: Colors.yellow, size: 30),
                        ],
                      ),
                      Text(
                        '${foot[index].minute} mn', // Use widget.foot.minute
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Bouton pour ajouter aux favoris
                  Positioned(
                    right: 2,
                    child: IconButton(
                      onPressed: () {
                        // Fonctionnalité pour ajouter aux favoris
                      },
                      icon: const Icon(Icons.favorite),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}





