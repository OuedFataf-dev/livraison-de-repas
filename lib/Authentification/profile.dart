import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserProfile extends StatefulWidget {
  final String userId;

  const UserProfile({super.key, required this.userId});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late Future<Map<String, dynamic>> _userData;

  @override
  void initState() {
    super.initState();
    _userData = fetchUserData();
  }

Future<Map<String, dynamic>> fetchUserData() async {
  final String apiUrl = "http://192.168.12.60:5000/login/user/${widget.userId}";
  print("URL de l'API : $apiUrl"); // Log pour vérifier l'URL

  try {
    final response = await http.get(Uri.parse(apiUrl));
    print("Réponse du serveur : ${response.statusCode}"); // Log pour vérifier le statut
    print("Corps de la réponse : ${response.body}"); // Log pour vérifier le corps de la réponse

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Erreur serveur: ${response.statusCode}");
    }
  } catch (e) {
    print("Erreur de connexion: $e"); // Log pour capturer les erreurs
    throw Exception("Erreur de connexion: $e");
  }
}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Utilisateur')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Aucune donnée trouvée"));
          }

          final userData = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Photo de profil
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/user.png'),
                ),
                const SizedBox(height: 16),
                // Nom de l'utilisateur
                Text(
                  userData['name'] ?? "Nom inconnu",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                // Email de l'utilisateur
                Text(
                  userData['email'] ?? "Email inconnu",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                // Informations supplémentaires
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.phone, color: Colors.blue),
                        const SizedBox(height: 4),
                        const Text('Téléphone'),
                        Text(userData['phone'] ?? 'Non disponible'),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.location_on, color: Colors.blue),
                        const SizedBox(height: 4),
                        const Text('Localisation'),
                        Text(userData['location'] ?? 'Non spécifié'),
                        const SizedBox(height: 10),
                        const Text('Pays', style: TextStyle(fontSize: 20)),
                        Text(userData['country'] ?? 'Non spécifié', style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
