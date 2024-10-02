class Chef {
  final String id;
  final String name;
  final List<String> menus;
  final double rating;
  final int totalOrders;

  Chef(
      {required this.id,
      required this.name,
      required this.menus,
      required this.rating,
      required this.totalOrders});
}

class MenuDetail {
  final String id;
  final String name;
  final String description;
  final List<String> ingredients;
  final bool availability;
  final String chefId;
  final double price;
  final double rating;

  MenuDetail(
      {required this.id,
      required this.name,
      required this.description,
      required this.ingredients,
      required this.availability,
      required this.chefId,
      required this.price,
      required this.rating});
}

class Order {
  final String id;
  final String userId;
  final String status; // 'preparing', 'out for delivery', 'delivered'
  final String deliveryLocation;
  final List<String> items;

  Order(
      {required this.id,
      required this.userId,
      required this.status,
      required this.deliveryLocation,
      required this.items});
}
