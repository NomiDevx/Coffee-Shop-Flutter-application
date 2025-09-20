import 'dart:ui';
import 'package:cafeshop/model/coffee_model.dart';
import 'package:flutter/material.dart';

class Order {
  final String id;
  final String userId;
  final List<Coffee> items;
  final double totalAmount;
  final DateTime dateTime;
  final String status;
  final String paymentMethod;
  final String? deliveryAddress;
  final bool isDelivery;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.dateTime,
    required this.status,
    required this.paymentMethod,
    this.deliveryAddress,
    required this.isDelivery,
  });

// Add this copyWith method to your Order class in order_model.dart
Order copyWith({
  String? id,
  String? userId,
  List<Coffee>? items,
  double? totalAmount,
  DateTime? dateTime,
  String? status,
  String? paymentMethod,
  String? deliveryAddress,
  bool? isDelivery,
}) {
  return Order(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    items: items ?? this.items,
    totalAmount: totalAmount ?? this.totalAmount,
    dateTime: dateTime ?? this.dateTime,
    status: status ?? this.status,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    deliveryAddress: deliveryAddress ?? this.deliveryAddress,
    isDelivery: isDelivery ?? this.isDelivery,
  );
}

  // Helper method to get status color
  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'preparing':
        return Colors.blue;
      case 'ready':
        return Colors.green;
      case 'delivered':
        return Colors.purple;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Helper method to get status icon
  IconData getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.access_time;
      case 'preparing':
        return Icons.coffee_maker;
      case 'ready':
        return Icons.check_circle;
      case 'delivered':
        return Icons.delivery_dining;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }
}