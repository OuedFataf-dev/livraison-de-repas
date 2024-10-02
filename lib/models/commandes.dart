import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class Commande {
  final String id;
  final String name;
  final double price;
  int quantity;
  final double rating;
  final String userComment;

  Commande({
    required this.id,
    required this.name,
    required double price,
    required this.quantity,
    required this.rating,
    required this.userComment,
  })  : assert(price >= 0, 'Price must be non-negative'),
        price = price < 0 ? 0 : price; // Assurer un prix non négatif

  // Supprimez la déclaration de `totalAmount` comme champ final
  double get totalAmount =>
      price * quantity; // Utilisez le getter pour calculer le montant total

  factory Commande.fromJson(Map<String, dynamic> json) {
    return Commande(
      id: json['mealId'] as String? ?? '',
      name: json['name'] as String? ?? 'Inconnu',
      price: _toDouble(json['price']),
      quantity: _toInt(json['quantity']),
      rating: _toDouble(json['rating']),
      userComment: json['userComment'] as String? ?? 'Aucun commentaire',
    );
  }

  static double _toDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else if (value is num) {
      return value.toDouble();
    } else {
      return 0.0;
    }
  }

  static int _toInt(dynamic value) {
    if (value is String) {
      return int.tryParse(value) ?? 0;
    } else if (value is int) {
      return value;
    } else {
      return 0;
    }
  }
}
