import 'package:cafeshop/model/users_model.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [
    User(
      id: 'u1',
      name: 'Alex Johnson',
      nickname: 'CoffeeExplorer',
      email: 'alex.johnson@example.com',
      phone: '+1 (555) 123-4567',
      avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
      bio: 'Coffee enthusiast and digital nomad. Always looking for the perfect flat white.',
      location: Location(
        address: '123 Downtown St, Apt 4B, Anytown, AT 12345',
        latitude: 34.052235,
        longitude: -118.243683,
      ),
      joinDate: DateTime(2022, 3, 15),
      favoriteCafeIds: ['1', '3', '5'],
      points: 1250,
      dietaryPreferences: ['Vegetarian'],
      membershipLevel: 'Gold',
      orderHistory: [
        OrderHistory(
          orderId: 'o101',
          cafeId: '1',
          orderDate: DateTime(2023, 5, 10, 9, 30),
          totalAmount: 12.75,
          items: [
            OrderItem(itemId: 'i1', name: 'Espresso', quantity: 1, price: 2.99),
            OrderItem(itemId: 'i2', name: 'Croissant', quantity: 2, price: 3.50),
          ],
        ),
      ],
    ),
    User(
      id: 'u2',
      name: 'Sarah Miller',
      nickname: 'MatchaLover',
      email: 'sarah.m@example.com',
      phone: '+1 (555) 234-5678',
      avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
      bio: 'Matcha connoisseur and bookworm. Favorite spot: quiet corners with good lighting.',
      location: Location(
        address: '456 Park Ave, Unit 12, Somewhere, SW 67890',
        latitude: 40.712776,
        longitude: -74.005974,
      ),
      joinDate: DateTime(2021, 11, 22),
      favoriteCafeIds: ['10', '4'],
      points: 870,
      dietaryPreferences: ['Vegan', 'Gluten-Free'],
      membershipLevel: 'Silver',
      orderHistory: [
        OrderHistory(
          orderId: 'o102',
          cafeId: '10',
          orderDate: DateTime(2023, 5, 12, 14, 15),
          totalAmount: 9.00,
          items: [
            OrderItem(itemId: 'i10', name: 'Matcha Latte', quantity: 1, price: 5.25),
            OrderItem(itemId: 'i11', name: 'Mochi', quantity: 1, price: 3.75),
          ],
        ),
      ],
    ),
    User(
      id: 'u3',
      name: 'James Wilson',
      nickname: 'BeanMaster',
      email: 'james.w@example.com',
      phone: '+1 (555) 345-6789',
      avatarUrl: 'https://randomuser.me/api/portraits/men/67.jpg',
      bio: 'Home roaster turned cafe reviewer. Knows his beans better than anyone.',
      location: Location(
        address: '789 Hillside Dr, Nowhere, NW 34567',
        latitude: 41.878114,
        longitude: -87.629798,
      ),
      joinDate: DateTime(2023, 1, 5),
      favoriteCafeIds: ['6', '3'],
      points: 2300,
      dietaryPreferences: [],
      membershipLevel: 'Platinum',
      orderHistory: [
        OrderHistory(
          orderId: 'o103',
          cafeId: '6',
          orderDate: DateTime(2023, 5, 15, 10, 0),
          totalAmount: 11.25,
          items: [
            OrderItem(itemId: 'i12', name: 'Coffee Flight', quantity: 1, price: 8.00),
            OrderItem(itemId: 'i13', name: 'Scone', quantity: 1, price: 3.25),
          ],
        ),
      ],
    ),
   

  ];

  List<User> get users {
    return [..._users];
  }

  User findById(String id) {
    return _users.firstWhere((user) => user.id == id);
  }

  void addFavoriteCafe(String userId, String cafeId) {
    final userIndex = _users.indexWhere((user) => user.id == userId);
    if (userIndex >= 0 && !_users[userIndex].favoriteCafeIds.contains(cafeId)) {
      _users[userIndex].favoriteCafeIds.add(cafeId);
      notifyListeners();
    }
  }

  void removeFavoriteCafe(String userId, String cafeId) {
    final userIndex = _users.indexWhere((user) => user.id == userId);
    if (userIndex >= 0) {
      _users[userIndex].favoriteCafeIds.remove(cafeId);
      notifyListeners();
    }
  }

  void addOrderToHistory(String userId, OrderHistory newOrder) {
    final userIndex = _users.indexWhere((user) => user.id == userId);
    if (userIndex >= 0) {
      _users[userIndex].orderHistory.add(newOrder);
      // Add points based on order amount (1 point per dollar spent)
      _users[userIndex].points += newOrder.totalAmount.floor();
      // Update membership level based on points
      _updateMembershipLevel(userIndex);
      notifyListeners();
    }
  }
  void updateUserAddress(String userId, String newAddress) {
    final userIndex = _users.indexWhere((user) => user.id == userId);
    if (userIndex >= 0) {
      // _users[userIndex].location. = newAddress;
      notifyListeners();
    }
  }

  void _updateMembershipLevel(int userIndex) {
    final points = _users[userIndex].points;
    if (points >= 2000) {
      _users[userIndex].membershipLevel = 'Platinum';
    } else if (points >= 1000) {
      _users[userIndex].membershipLevel = 'Gold';
    } else if (points >= 500) {
      _users[userIndex].membershipLevel = 'Silver';
    } else {
      _users[userIndex].membershipLevel = 'Regular';
    }
  }
}