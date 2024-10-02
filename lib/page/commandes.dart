import 'package:cookeazy/services/suivi_commande.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/payement.dart'; // Pour le service de paiement
import '../models/commandes.dart'; // Modèle de commande
import '../services/provider.dart'; // Importer votre provider
//import '../screens/delivery_tracking_screen.dart'; // Import your delivery tracking screen

class Commandes extends StatelessWidget {
  final List<Commande> commandes; // Recevez les commandes passées
  final String detailId; // Add detailId

  const Commandes({Key? key, required this.detailId, required this.commandes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commandeProvider =
        Provider.of<CommandeProvider>(context, listen: false);

    // Utilisez les commandes déjà présentes, pas besoin de fetch si elles sont fournies
    WidgetsBinding.instance.addPostFrameCallback((_) {
      commandeProvider.setCommandes(commandes);
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Mes Commandes'),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommandeSuivi(
                            detailId: '',
                          )),
                );
              },
              child: const Text(
                'livraison',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: commandes.isEmpty
          ? const Center(
              child: Text(
                'Aucune commande disponible.',
                style: TextStyle(fontSize: 20),
              ),
            )
          : Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommandeSuivi(
                                detailId: '',
                              )),
                    );
                  },
                  child: const Text(
                    'livraison',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Récapitulatif de la commande',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: commandes.length,
                    itemBuilder: (context, index) {
                      final commande = commandes[index];
                      return Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.shopping_cart,
                                size: 100,
                                color: Colors.orange,
                              ),
                              title: Text(commande.name),
                              subtitle: Text('Quantité: ${commande.quantity}'),
                              trailing: Text(
                                '${(commande.totalAmount / 100).toStringAsFixed(2)}\$',
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${(commande.totalAmount / 100).toStringAsFixed(2)}\$',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Évaluation: ${commande.rating.toStringAsFixed(1)} ⭐',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Commentaire: ${commande.userComment}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Start the payment process
                        bool paymentSuccessful =
                            await StripeService.instance.makePayment(
                          amount: commandes[0].totalAmount.toInt(),
                          currency: 'usd',
                          context: context,
                        );

                        if (paymentSuccessful) {
                          // Show success dialog if payment is successful
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Paiement réussi!'),
                              content: const Text(
                                  'Souhaitez-vous voir les détails de livraison?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: const Text('Non'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CommandeSuivi(detailId: detailId),
                                      ),
                                    );
                                  },
                                  child: const Text('Oui'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          // Handle payment failure if needed
                          print("Échec du paiement.");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text(
                        "Procéder au paiement",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
