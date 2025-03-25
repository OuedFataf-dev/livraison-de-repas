import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Nécessaire pour jsonDecode et jsonEncode

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();
  Future<bool> makePayment({
    required int amount,
    required String currency,
    required BuildContext context,
  }) async {
    try {
      // Initialisation de la feuille de paiement
      print(
          "Initialisation de la feuille de paiement avec montant: $amount $currency");
      await initializePaymentSheet(amount: amount, currency: currency);

      // Présentation de la feuille de paiement
      print("Présentation de la feuille de paiement.");
      await Stripe.instance.presentPaymentSheet();
      print("Feuille de paiement présentée avec succès.");

      // Confirmation du paiement
      try {
        print("Présentation de la feuille de paiement.");
        await Stripe.instance.presentPaymentSheet();
        print("Feuille de paiement présentée avec succès.");

        // Confirmation du paiement
        try {
          print("Confirmation du paiement.");
          await Stripe.instance.confirmPaymentSheetPayment();
          print("Paiement confirmé.");
        } catch (e, stacktrace) {
          print("Erreur lors de la confirmation du paiement: $e");
          print("Trace de la pile: $stacktrace");
        }
      } catch (e) {
        print("Erreur lors de la présentation de la feuille de paiement: $e");
      }

      // Retourner true si le paiement est réussi
      return true;
    } catch (e) {
      // Amélioration de l'affichage des erreurs
      print("Erreur lors du paiement : ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du paiement : ${e.toString()}')),
      );
      return false; // Retourne false en cas d'échec
    }
  }

  // Méthode pour initialiser la feuille de paiement
  Future<void> initializePaymentSheet({
    required int amount,
    required String currency,
  }) async {
    try {
      print("Création de l'intention de paiement...");
      final paymentIntentClientSecret =
          await _createPaymentIntent(amount, currency);
      if (paymentIntentClientSecret != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentClientSecret,
            merchantDisplayName: 'fataf ouedraogo', // Nom de l'entreprise
          ),
        );
        print('Feuille de paiement initialisée avec succès.');
      } else {
        print('Erreur lors de la création de l\'intention de paiement.');
      }
    } catch (e) {
      print("Erreur lors de l'initialisation de la feuille de paiement : $e");
    }
  }

  // Crée une intention de paiement sur le backend
  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      // Prépare l'URL de la requête
      final Uri url = Uri.parse(
          'http://192.168.12.60:5000/payement/create-payment-intent');

      // Crée le corps de la requête avec les données nécessaires
      final Map<String, dynamic> requestBody = {
        'amount': amount, // Montant en cents
        'currency': currency,
      };

      // Envoie la requête POST au backend
      final http.Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody), // Conversion du corps en JSON
      );

      // Affiche la réponse complète du serveur
      print(
          'Réponse de création de l\'intention de paiement: ${response.body}');

      // Vérifie si la réponse contient le `client_secret`
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData['client_secret']; // Renvoie le client secret
      } else {
        print('Erreur: statut de la réponse ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la création du PaymentIntent : $e');
    }
    return null;
  }
}
