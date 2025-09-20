// provider/orders_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cafeshop/model/order_model.dart';

class OrdersProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  // // Add sample orders for demonstration
  // void loadSampleOrders() {
  //   _orders = [
  //     Order(
  //       id: 'ORD001',
  //       userId: 'user1',
  //       items: [], // Add sample coffee items
  //       totalAmount: 12.50,
  //       dateTime: DateTime.now().subtract(const Duration(days: 2)),
  //       status: 'Delivered',
  //       paymentMethod: 'Credit Card',
  //       deliveryAddress: '123 Coffee St, City',
  //       isDelivery: true,
  //     ),
  //     Order(
  //       id: 'ORD002',
  //       userId: 'user1',
  //       items: [], // Add sample coffee items
  //       totalAmount: 8.75,
  //       dateTime: DateTime.now().subtract(const Duration(days: 1)),
  //       status: 'Preparing',
  //       paymentMethod: 'Cash',
  //       deliveryAddress: '123 Coffee St, City',
  //       isDelivery: true,
  //     ),
  //     Order(
  //       id: 'ORD003',
  //       userId: 'user1',
  //       items: [], // Add sample coffee items
  //       totalAmount: 15.25,
  //       dateTime: DateTime.now(),
  //       status: 'Pending',
  //       paymentMethod: 'Digital Wallet',
  //       isDelivery: false,
  //     ),
  //   ];
  //   notifyListeners();
  // }

  // Add a new order
  void addOrder(Order order) {
    _orders.insert(0, order); // Add to beginning of list
    notifyListeners();
  }

  // Update order status
  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index] = Order(
        id: _orders[index].id,
        userId: _orders[index].userId,
        items: _orders[index].items,
        totalAmount: _orders[index].totalAmount,
        dateTime: _orders[index].dateTime,
        status: newStatus,
        paymentMethod: _orders[index].paymentMethod,
        deliveryAddress: _orders[index].deliveryAddress,
        isDelivery: _orders[index].isDelivery,
      );
      notifyListeners();
    }
  }

  // Get orders by status
  List<Order> getOrdersByStatus(String status) {
    return _orders.where((order) => order.status == status).toList();
  }

  // Clear all orders
  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }
}
