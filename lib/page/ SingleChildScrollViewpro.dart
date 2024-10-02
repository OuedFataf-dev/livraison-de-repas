import 'package:flutter/material.dart';

class SingleChildScroll extends StatefulWidget {
  const SingleChildScroll({super.key});

  @override
  State<SingleChildScroll> createState() => _SingleChildScrollState();
}

class _SingleChildScrollState extends State<SingleChildScroll> {
  // Define current category to track the selected category
  String currend = 'Category1'; // Example initialization

  // Example list of categories (replace with your actual list)
  final List<String> categories = ['Commande', 'Menu', 'Cusinier', 'Plat'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Add horizontal scroll
      child: Row(
        children: List.generate(
          categories.length,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                currend = categories[index]; // Update selected category
              });
            },
            child: Container(
              width: 100, // Increase width
              height: 40, // Increase height
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: currend == categories[index] ? Colors.red : Colors.black,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 10,
              ),
              margin: const EdgeInsets.only(right: 10),
              child: Center(
                child: FittedBox(
                  child: Text(
                    categories[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
