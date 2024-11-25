import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Foot.dart';

Future<bool> registerUser(
    String name, String email, String password, String userType) async {
  final response = await http.post(
    Uri.parse('https://node-js-flutter-1.onrender.com/register/register-users'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': name,
      'email': email,
      'password': password,
      'userType': userType,
    }),
  );

  if (response.statusCode == 200) {
    print('User registered successfully');
    return true; // Retourner vrai en cas de succès
  } else {
    print('Failed to register user: ${response.body}');
    return false; // Retourner faux en cas d'échec
  }
}

Future<bool> loginUser(String email, String password) async {
  final url = Uri.parse(
      'https://node-js-flutter-1.onrender.com/login/login-users'); // Remplacez cette URL par celle de votre API

  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    // Si la connexion est réussie
    return true;
  } else {
    // Si la connexion échoue
    print('Failed to login: ${response.body}');
    return false;
  }
}

Future<List<Meals>> fetchFootData() async {
  final response = await http.get(
    Uri.parse('https://node-js-flutter-1.onrender.com/meals/recuperer-meals'),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body);

    if (jsonResponse['meals'] != null && jsonResponse['meals'] is List) {
      // Parsing the meals list
      List<Meals> footList = (jsonResponse['meals'] as List).map((repasJson) {
        String imageUrl = repasJson['image'] != null
            ? 'https://node-js-flutter-1.onrender.com/meals/recuperer-meals/uploads/${repasJson['image']}'
            : ''; // Mettez une URL par défaut ou gérez le cas null

        return Meals.fromJson({
          ...repasJson,
          'image': imageUrl, // Assurez-vous que l'image a le bon format
        });
      }).toList();

      return footList;
    } else {
      throw Exception('Aucun repas trouvé');
    }
  } else {
    throw Exception('Erreur lors de la récupération des repas');
  }
}

class ApiService {
  Future<void> sendResetLink(String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.97.60:5000/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode != 200) {
        throw Exception('Erreur lors de l\'envoi du lien de réinitialisation');
      }
    } catch (e) {
      print('Erreur lors de l\'envoi de la requête : ${e.toString()}');
      rethrow; // Rejeter l'erreur pour qu'elle soit capturée par l'appelant
    }
  }
}

// Crée une intention de paiement sur le backend
Future<String?> _createPaymentIntent(int amount, String currency) async {
  try {
    // Prépare l'URL de la requête
    final Uri url = Uri.parse(
        'https://node-js-flutter-1.onrender.com/payement/create-payment-intent');

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
    print('Réponse de création de l\'intention de paiement: ${response.body}');

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
