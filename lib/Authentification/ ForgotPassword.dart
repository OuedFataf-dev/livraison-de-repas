import 'package:flutter/material.dart';
import '../services/api.dart'; // Assurez-vous que cela pointe bien vers votre fichier de service API
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import nécessaire pour jsonEncode

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  String _message = ''; // Pour afficher les messages à l'utilisateur
  final emailController = TextEditingController(); // Contrôleur pour l'email
  final _formKey = GlobalKey<FormState>(); // Clé pour valider le formulaire
  final apiService = ApiService(); // Instanciation de votre service API

  // Fonction pour envoyer le lien de réinitialisation de mot de passe
  void _sendResetLink() async {
    if (_formKey.currentState!.validate()) {
      // Valider les champs du formulaire
      final email = emailController.text; // Récupérer l'email saisi

      print('Email saisi: $email'); // Vérifier l'email dans la console

      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veuillez saisir une adresse e-mail valide.')),
        );
        return;
      }

      try {
        // Appel du service API pour envoyer le lien de réinitialisation
        await apiService.sendResetLink(email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Un lien de réinitialisation a été envoyé à votre email.'),
          ),
        );
        emailController.clear(); // Effacer le champ après envoi
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réinitialiser le mot de passe'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Form(
            key: _formKey, // Lien entre le formulaire et la validation
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Champ pour entrer l'adresse email
                Container(
                  width: 300,
                  child: TextFormField(
                    controller: emailController, // Liaison du contrôleur
                    decoration: InputDecoration(
                      fillColor: Colors.red[50], // Fond coloré
                      filled: true,
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'Votre email', // Placeholder
                      labelText: 'Email', // Label du champ
                      prefixIcon: Icon(Icons.email), // Icône d'email
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez remplir le champ";
                      } else if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                          .hasMatch(value)) {
                        return 'Veuillez entrer un email valide';
                      }
                      return null; // Le champ est valide
                    },
                  ),
                ),
                SizedBox(height: 20), // Espace entre les champs
                ElevatedButton(
                  onPressed:
                      _sendResetLink, // Appeler la fonction pour envoyer le lien
                  child: Text('Envoyer le lien de réinitialisation'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
