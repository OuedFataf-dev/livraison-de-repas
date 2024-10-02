import 'dart:convert';
import 'package:http/http.dart' as http;

class Meals {
  final String id;
  final String name;
  final String imageUrl;
  final String price;
  final String minute;

  Meals({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.minute,
  });

  // Méthode factory pour créer une instance de Foot à partir du JSON
  factory Meals.fromJson(Map<String, dynamic> json) {
    // On suppose que l'URL de base pour les images est celle de votre serveur
    const String baseUrl =
        'https://node-js-api-0ytm.onrender.com/'; // Changez cela si nécessaire

    // Construire l'URL complète de l'image en ajoutant le chemin relatif à l'URL de base
    String fullImageUrl = baseUrl + json['imageUrl'];

    return Meals(
      id: json['_id'], // On suppose que _id est un identifiant unique
      name: json['name'],
      imageUrl: fullImageUrl, // Utilisez l'URL complète pour l'image
      price: json['price'].toString(),
      minute: json['minute'].toString(),
    );
  }
}

class MealDetail {
  final String id; // ID of the meal
  final String name; // Name of the meal
  final double price; // Price of the meal
  final String description; // Description of the meal
  final bool availability;
  final String imagePath; // Availability of the meal
  final List<String> ingredients; // Ingredients of the meal
  final double rating; // Rating of the meal
  final String chefId; // ID of the chef

  MealDetail({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.availability,
    required this.ingredients,
    required this.rating,
    required this.chefId,
    required this.imagePath,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    // Assuming baseUrl is defined elsewhere
    const String baseUrl =
        'https://node-js-api-0ytm.onrender.com/'; // Changez cela si nécessaire

    String fullImageUrl = baseUrl + (json['imageUrl'] ?? 'default_image.jpg');

    return MealDetail(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Nom indisponible',
      price: json['price'] != null
          ? (json['price'] is String
              ? double.tryParse(json['price']) ??
                  0.0 // Convertir la chaîne en double
              : (json['price'] is num
                  ? (json['price'] as num)
                      .toDouble() // Convertir le nombre en double
                  : 0.0))
          : 0.0,
      description: json['description'] ?? 'Aucune description disponible',
      availability: json['availability'] ?? false,
      ingredients: List<String>.from(json['ingredients'] ?? []),
      rating: json['rating'] != null
          ? (json['rating'] is String
              ? double.tryParse(json['rating']) ??
                  0.0 // Convertir la chaîne en double
              : (json['rating'] is num
                  ? (json['rating'] as num).toDouble()
                  : 0.0))
          : 0.0,
      chefId: json['chefId'] ?? 'Chef inconnu',
      imagePath: fullImageUrl,
    );
  }
}
