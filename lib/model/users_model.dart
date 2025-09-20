class User {
  final String id;
  final String name;
  final String nickname;
  final String email;
  final String phone;
  final String avatarUrl;
  final String bio;
  final Location location;
  final DateTime joinDate;
  final List<String> favoriteCafeIds;
  int points;
  final List<OrderHistory> orderHistory;
  final List<String> dietaryPreferences;
   String membershipLevel;

  User({
    required this.id,
    required this.name,
    required this.nickname,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.bio,
    required this.location,
    required this.joinDate,
    this.favoriteCafeIds = const [],
    this.points = 0,
    this.orderHistory = const [],
    this.dietaryPreferences = const [],
    this.membershipLevel = 'Regular',
  });
}

class Location {
  final String address;
  final double latitude;
  final double longitude;

  Location({
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

class OrderHistory {
  final String orderId;
  final String cafeId;
  final DateTime orderDate;
  final double totalAmount;
  final List<OrderItem> items;
  final String status;

  OrderHistory({
    required this.orderId,
    required this.cafeId,
    required this.orderDate,
    required this.totalAmount,
    required this.items,
    this.status = 'Completed',
  });
}

class OrderItem {
  final String itemId;
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.price,
  });
}