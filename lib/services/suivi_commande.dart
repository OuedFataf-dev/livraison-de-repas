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
  String? status; // Statut initial null
  String? estimateDeliveryTime; // Temps de livraison initial null
  bool isLoading = true; // Indicateur de chargement

  @override
  void initState() {
    super.initState();
    _getOrderStatus(); // Récupérer le statut de la commande au démarrage
  }

  Future<void> _getOrderStatus() async {
    try {
      var orderData = await fetchOrderStatus(widget.detailId);
      setState(() {
        status = orderData['status'];
        estimateDeliveryTime = orderData['estimate_delivery_time'];
        isLoading = false;

        if (status == 'livraison terminée') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SuiviLivraisonScreen(),
            ),
          );
        }
      });
    } catch (e) {
      print('Erreur lors de la récupération du statut: $e');
      print('Réponse complète: ${e.toString()}');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch order status from the backend API
  Future<Map<String, dynamic>> fetchOrderStatus(String orderId) async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.12.60:5000/commande/order-status/$orderId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Erreur lors de la récupération du statut de la commande');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi de la commande',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 25)),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Affichage du chargement
          : Column(
              children: [
                Text(
                  'Statut de votre commande : ${status ?? "Inconnu"}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Temps estimé de livraison : ${estimateDeliveryTime ?? "Non disponible"}',
                  style: const TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 200.0,
                  child: Stepper(
                    currentStep: _getStepIndex(status ?? ""),
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

  List<Step> _buildSteps() {
    return const [
      Step(
        title: Text('Commande reçue'),
        content:
            Text('Votre commande a été reçue et est en attente de traitement.'),
        isActive: true,
      ),
      Step(
        title: Text('En cours'),
        content: Text('Votre commande est en cours de préparation.'),
        isActive: true,
      ),
      Step(
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
        title: const Text('Suivi de Livraison',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 25)),
      ),
      body: Center(
        child: const Text('Votre livraison est en route !',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 25)),
      ),
    );
  }
}
