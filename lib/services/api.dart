import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Foot.dart';

Future<bool> registerUser(
    String name, String email, String password, String userType) async {
  final response = await http.post(
    Uri.parse('https://node-js-api-0ytm.onrender.com/register/register-users'),
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
      'https://node-js-api-0ytm.onrender.com/login/login-users'); // Remplacez cette URL par celle de votre API

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
    Uri.parse('https://node-js-api-0ytm.onrender.com/meals/recuperer-meals'),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body);

    if (jsonResponse['meals'] != null && jsonResponse['meals'] is List) {
      // Parsing the meals list
      List<Meals> footList = (jsonResponse['meals'] as List).map((repasJson) {
        String imageUrl = repasJson['image'] != null
            ? 'https://node-js-api-0ytm.onrender.com/meals/recuperer-meals/uploads/${repasJson['image']}'
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
