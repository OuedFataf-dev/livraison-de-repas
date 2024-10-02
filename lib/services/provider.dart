import 'package:flutter/foundation.dart';
import '../models/commandes.dart'; // Modèle de commande

class CommandeProvider with ChangeNotifier {
  List<Commande> _orders = [];

  List<Commande> get orders => _orders;

  void addOrder(Commande order) {
    // Vérifier si la commande existe déjà
    final existingOrderIndex = _orders.indexWhere((o) => o.id == order.id);

    if (existingOrderIndex >= 0) {
      // Si le repas existe déjà dans les commandes, on augmente la quantité
      _orders[existingOrderIndex].quantity += order.quantity;
    } else {
      // Si c'est un nouveau repas, on l'ajoute à la liste des commandes
      _orders.add(order);
    }

    notifyListeners(); // Notifier les widgets écoutant cet état
  }
  

  // Nouvelle méthode pour définir les commandes
  void setCommandes(List<Commande> commandes) {
    _orders = commandes; // Met à jour la liste des commandes
    notifyListeners(); // Notifier les widgets écoutant cet état
  }

  // Exemple de méthode pour supprimer une commande (commentée)
  // void removeOrder(String mealId) {
  //   _orders.removeWhere((order) => order.id == mealId);
  //   notifyListeners();  // Notifier les widgets écoutant cet état
  // }
}
