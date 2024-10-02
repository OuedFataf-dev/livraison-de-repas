import 'package:flutter/material.dart';
import '../models/Foot.dart';
import ' Footcart.dart';

class Mealspages extends StatefulWidget {
  final List<Meals> meals; // Liste des repas à afficher

  const Mealspages({super.key, required this.meals});

  @override
  _MealspagesState createState() => _MealspagesState();
}

class _MealspagesState extends State<Mealspages> {
  @override
  Widget build(BuildContext context) {
    // Utilise directement la liste `widget.meals` passée via le constructeur
    if (widget.meals.isEmpty) {
      return Center(child: Text('Aucun repas disponible'));
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.meals.length,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 22,
        crossAxisSpacing: 22,
        mainAxisExtent: 210,
      ),
      itemBuilder: (context, index) => Footcart(
        foot: widget.meals[index],
      ),
    );
  }
}
