import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../page/commandes.dart';

class CommandeSuivi extends StatefulWidget {
  final String detailId;
  const CommandeSuivi({Key? key, required this.detailId}) : super(key: key);

  @override
  _CommandeSuiviState createState() => _CommandeSuiviState();
}

class _CommandeSuiviState extends State<CommandeSuivi> {
  String status = "terminine"; // Statut initial

  @override
  void initState() {
    super.initState();
    _getOrderStatus(); // Récupérer le statut de la commande au démarrage
  }

  Future<void> _getOrderStatus() async {
    try {
      // Fetch status from the backend API
      String fetchedStatus = await fetchOrderStatus(widget.detailId);
      setState(() {
        status = fetchedStatus;

        // Rediriger l'utilisateur vers l'écran de suivi de livraison si le statut est "livraison terminée"
        if (status == 'livraison terminée') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SuiviLivraisonScreen(), // Remplacez par votre écran de suivi de livraison
            ),
          );
        }
      });
    } catch (e) {
      print('Erreur lors de la récupération du statut: $e');
    }
  }

  // Fetch order status from the backend API
  Future<String> fetchOrderStatus(String orderId) async {
    final response = await http.get(
      Uri.parse(
          'http:// 192.168.93.60:5000/order-status/$orderId'), // Assurez-vous que l'URL est correcte
    );

    if (response.statusCode == 200) {
      // Si la requête a réussi, décoder la réponse
      final data = jsonDecode(response.body);
      return data['status'] ?? 'en attente';
    } else {
      throw Exception(
          'Erreur lors de la récupération du statut de la commande');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi de la commande'),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Commandes(
                          detailId: '',
                          commandes: [],
                        )),
              );
            },
            child: Text(
              'payement: ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          Text(
            'Statut de votre commande : $status',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 200.0,
            child: Stepper(
              currentStep: _getStepIndex(status),
              steps: _buildSteps(),
              type: StepperType.vertical,
              controlsBuilder:
                  (BuildContext context, ControlsDetails controls) {
                return Container(); // Pas de boutons supplémentaires
              },
            ),
          ),
          ElevatedButton(
            onPressed: _getOrderStatus,
            child: const Text('Rafraîchir statut'),
          ),
        ],
      ),
    );
  }

  // Convertir le statut en une étape du Stepper
  int _getStepIndex(String status) {
    switch (status) {
      case "en attente":
        return 0;
      case "en cours":
        return 1;
      case "livraison terminée":
        return 2;
      default:
        return 0;
    }
  }

  // Construire les étapes du Stepper
  List<Step> _buildSteps() {
    return [
      const Step(
        title: Text('Commande reçue'),
        content:
            Text('Votre commande a été reçue et est en attente de traitement.'),
        isActive: true,
      ),
      const Step(
        title: Text('En cours'),
        content: Text('Votre commande est en cours de préparation.'),
        isActive: true,
      ),
      const Step(
        title: Text('Livraison terminée'),
        content: Text('Votre commande a été livrée.'),
        isActive: true,
      ),
    ];
  }
}

// Écran de suivi de livraison
class SuiviLivraisonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi de Livraison'),
      ),
      body: Center(
        child: const Text('Votre livraison est en route !'),
      ),
    );
  }
}
