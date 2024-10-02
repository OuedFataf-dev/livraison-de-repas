import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'suivi_commande.dart'; // Assurez-vous d'importer votre page de suivi

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  // Méthode principale pour effectuer un paiement
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
      await Stripe.instance.confirmPaymentSheetPayment();
      print("Paiement confirmé.");

      // Créer une commande après le paiement
      String? orderId = await _createOrderOnBackend(
        amount: amount,
        currency: currency,
        context: context,
      );

      if (orderId != null) {
        print("Commande créée avec succès. ID de commande: $orderId");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommandeSuivi(detailId: orderId),
          ),
        );
        return true; // Retourne true si le paiement est réussi
      } else {
        print('Erreur lors de la création de la commande.');
        throw Exception('Erreur lors de la création de la commande.');
      }
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
            merchantDisplayName:
                'fataf ouedraogo', // Remplacez par le nom de votre entreprise
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
      final Dio dio = Dio();
      var response = await dio.post(
        'https://node-js-api-0ytm.onrender.com/payement/create-payment-intent',
        data: {
          'amount': amount, // Montant en cents
          'currency': currency,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      print(
          'Réponse de création de l\'intention de paiement: ${response.data}');
      return response.data['client_secret']; // Renvoie le client secret
    } catch (e) {
      print('Erreur lors de la création du PaymentIntent : $e');
      return null;
    }
  }

  // Crée une commande sur le backend après le paiement
  Future<String?> _createOrderOnBackend({
    required int amount,
    required String currency,
    required BuildContext context, // Passer le contexte ici pour la navigation
  }) async {
    try {
      final Dio dio = Dio();
      var response = await dio.post(
        'https://node-js-api-0ytm.onrender.com/payement/create-order', // Assurez-vous que l'URL est correcte
        data: {
          'amount': amount,
          'currency': currency,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      // Imprimez la réponse pour le débogage
      print('Réponse du serveur création de commande: ${response.data}');

      // Vérifiez si la réponse contient l'ID de la commande
      if (response.data != null && response.data['orderId'] != null) {
        return response.data['orderId'];
      } else {
        print('Erreur: la réponse du serveur ne contient pas d\'order_id');
      }
    } catch (e) {
      print('Erreur lors de la création de la commande : $e');
    }
    return null;
  }
}
