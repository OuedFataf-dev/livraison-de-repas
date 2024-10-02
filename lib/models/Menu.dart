import 'dart:convert';
import 'package:http/http.dart' as http;

class Menu {
  final String id;
  final String name;
  final int price; // Corresponds to the API response
  final String minute;
  final String cuisineType;
  final int rating; // Corresponds to the API response
  final String chefId;
  final bool popular;

  Menu({
    required this.id,
    required this.name,
    required this.price,
    required this.minute,
    required this.cuisineType,
    required this.rating,
    required this.chefId,
    required this.popular,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['_id'] ?? '', // Handle case where _id might be null
      name: json['name'] ?? 'Unknown',
      price: json['price'] ?? 0, // Default value if price is null
      minute: json['minute'] ?? 'N/A',
      cuisineType: json['cuisineType'] ?? 'Unknown',
      rating: json['rating'] ?? 0, // Default value if rating is null
      chefId: json['chefId'] ?? 'Unknown',
      popular: json['popular'] ?? false, // Default value if popular is null
    );
  }
}

class MenuDetail {
  final String id;
  final String name;
  final double price;
  final String description;
  final bool availability;
  final List<String> ingredients;
  final double rating;
  final String chefId;
  final String imageUrl;

  // Base URL to prefix the image URL from the API
  static const String baseUrl = 'https://node-js-api-0ytm.onrender.com/';

  MenuDetail({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.availability,
    required this.ingredients,
    required this.rating,
    required this.chefId,
    required this.imageUrl,
  });

  factory MenuDetail.fromJson(Map<String, dynamic> json) {
    // Build the full image URL
    String fullImageUrl = baseUrl + (json['imageUrl'] ?? 'default_image.jpg');

    return MenuDetail(
      id: json['_id'] ?? '', // Default empty if null
      name: json['name'] ?? 'Nom indisponible', // Default if null
      price: (json['price'] ?? 0.0).toDouble(), // Default value 0.0 if null
      description: json['description'] ??
          'Aucune description disponible', // Default if null
      availability: json['availability'] ?? false, // Default if null
      ingredients:
          List<String>.from(json['ingredients'] ?? []), // Empty list if null
      rating: (json['rating'] ?? 0.0).toDouble(), // Default value 0.0 if null
      chefId: json['chefId'] ?? 'Chef inconnu', // Default if null
      imageUrl: fullImageUrl, // Full URL for the image
    );
  }
}
