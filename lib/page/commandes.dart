import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/payement.dart'; // Pour le service de paiement
import '../models/commandes.dart'; // Modèle de commande
import '../services/provider.dart';
import 'commanderService.dart';
// Importer votre provider

class Commandes extends StatefulWidget {
  final List<Commande> commandes;
  final String detailId;

  const Commandes({Key? key, required this.detailId, required this.commandes})
      : super(key: key);

  @override
  _CommandesState createState() => _CommandesState();
}

class _CommandesState extends State<Commandes> {
  @override
  Widget build(BuildContext context) {
    final commandeProvider =
        Provider.of<CommandeProvider>(context, listen: false);

    // Utilisez les commandes déjà présentes, pas besoin de fetch si elles sont fournies
    WidgetsBinding.instance.addPostFrameCallback((_) {
      commandeProvider.setCommandes(widget.commandes);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Commandes'),
      ),
      body: widget.commandes.isEmpty
          ? const Center(
              child: Text(
                'Aucune commande disponible.',
                style: TextStyle(fontSize: 20),
              ),
            )
          : Column(
              children: [
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
                    itemCount: widget.commandes.length,
                    itemBuilder: (context, index) {
                      final commande = widget.commandes[index];
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
                                    '${(commande.totalAmount).toStringAsFixed(2)}\$',
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
                                  const SizedBox(height: 10),
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
                        // Commencez le processus de paiement
                        bool paymentSuccessful =
                            await StripeService.instance.makePayment(
                          amount: widget.commandes[0].totalAmount.toInt(),
                          currency: 'usd',
                          context: context,
                        );

                        // Mettez à jour l'interface utilisateur après le paiement
                        if (mounted) {
                          setState(() {
                            if (paymentSuccessful) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Paiement réussi!'),
                                  content: const Text(
                                      'Votre paiement a été traité avec succès.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        // Appeler la fonction de création de commande ici
                                        await CommandeService.instance
                                            .createOrder(
                                          amount: widget
                                              .commandes[0].totalAmount
                                              .toInt(),
                                          currency: 'usd',
                                          context: context,
                                        );
                                      },
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              // Gérez l'échec du paiement
                              print("Échec du paiement.");
                            }
                          });
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
