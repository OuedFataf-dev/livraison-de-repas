import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Nécessaire pour jsonDecode et jsonEncode
//import 'suivi_commande.dart';
import '../services/suivi_commande.dart';
// // Assurez-vous d'importer votre page de suivi

class CommandeService {
  CommandeService._();

  static final CommandeService instance = CommandeService._();

  Future<void> createOrder({
    required int amount,
    required String currency,
    required BuildContext context,
  }) async {
    try {
      // Créer une commande après validation
      String? orderId = await _createOrderOnBackend(
        amount: amount,
        currency: currency,
        context: context,
      );

      if (orderId != null) {
        print("Commande créée avec succès. ID de commande: $orderId");
        // Affichage de l'alerte pour confirmer la création de la commande
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Commande réussie!'),
              content:
                  const Text('Souhaitez-vous voir les détails de livraison?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Ferme la boîte de dialogue
                  },
                  child: const Text('Non'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommandeSuivi(detailId: orderId),
                      ),
                    );
                  },
                  child: const Text('Oui'),
                ),
              ],
            ),
          );
        }
      } else {
        print('Erreur lors de la création de la commande.');
        throw Exception('Erreur lors de la création de la commande.');
      }
    } catch (e) {
      // Affiche un message d'erreur en cas d'échec
      print("Erreur lors de la création de la commande : ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Erreur lors de la création de la commande : ${e.toString()}')),
      );
    }
  }

  // Crée une commande sur le backend
  Future<String?> _createOrderOnBackend({
    required int amount,
    required String currency,
    required BuildContext context,
  }) async {
    try {
      // Prépare l'URL de la requête
      final Uri url = Uri.parse(
          'http://192.168.12.60:5000/payement/create-order');

      // Crée le corps de la requête avec les données nécessaires
      final Map<String, dynamic> requestBody = {
        'amount': amount,
        'currency': currency,
      };

      // Envoie la requête POST au backend
      final http.Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody), // Conversion du corps en JSON
      );

      // Affiche la réponse complète du serveur
      print('Réponse du serveur création de commande: ${response.body}');

      // Vérifie si la réponse contient l'ID de la commande
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['order_id'] != null) {
          String orderId = responseData['order_id'];
          print("ID de commande : $orderId");
          return orderId;
        } else {
          print('Erreur: la réponse du serveur ne contient pas de order_id');
        }
      } else {
        print('Erreur: statut de la réponse ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la création de la commande : $e');
    }
    return null;
  }
}
