import 'package:flutter/material.dart';
import '../models/Foot.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Meals> allMeals; // Liste des repas à filtrer

  CustomSearchDelegate(this.allMeals);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = ''; // Efface la recherche
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null); // Ferme la recherche
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Meals> matchQuery = [];
    for (var meal in allMeals) {
      if (meal.name.toLowerCase().contains(query.toLowerCase()) ||
          meal.price.toString().contains(query)) {
        matchQuery.add(meal);
      }
    }

    if (matchQuery.isEmpty) {
      return const Center(
        child: Text('Aucun résultat ne correspond à votre recherche.'),
      );
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.name),
          subtitle: Text('${result.price} €'),
          onTap: () {
            close(context, result);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Meals> matchQuery = [];
    for (var meal in allMeals) {
      if (meal.name.toLowerCase().contains(query.toLowerCase()) ||
          meal.price.toString().contains(query)) {
        matchQuery.add(meal);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.name),
          subtitle: Text('${result.price} €'),
          onTap: () {
            query = result.name;
            showResults(context); // Affiche les résultats
          },
        );
      },
    );
  }
}
