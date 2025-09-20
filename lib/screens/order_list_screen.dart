// screens/orders_screen.dart
import 'package:cafeshop/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cafeshop/model/order_model.dart';
import 'package:cafeshop/theme/theme.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _statusTabs = [
    'All',
    'Pending',
    'Preparing',
    'Ready',
    'Delivered',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusTabs.length, vsync: this);

    // Load sample orders when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ordersProvider = Provider.of<OrdersProvider>(
        context,
        listen: false,
      );

      ordersProvider.notifyListeners();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final orders = ordersProvider.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _statusTabs.map((status) => Tab(text: status)).toList(),
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _statusTabs.map((status) {
          List<Order> filteredOrders = status == 'All'
              ? orders
              : orders
                    .where(
                      (order) =>
                          order.status.toLowerCase() == status.toLowerCase(),
                    )
                    .toList();

          return _buildOrdersList(filteredOrders);
        }).toList(),
      ),
    );
  }

  Widget _buildOrdersList(List<Order> orders) {
    if (orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No orders yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Your orders will appear here',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Order order) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(
                    order.status,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: order.getStatusColor(),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Order details
            Row(
              children: [
                Icon(
                  order.getStatusIcon(),
                  color: order.getStatusColor(),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${dateFormat.format(order.dateTime)} • ${timeFormat.format(order.dateTime)}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Delivery/Pickup info
            Row(
              children: [
                Icon(
                  order.isDelivery ? Icons.delivery_dining : Icons.store,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  order.isDelivery ? 'Delivery' : 'Pickup',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(width: 12),
                Icon(Icons.payment, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  order.paymentMethod,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Order items preview
            if (order.items.isNotEmpty) ...[
              Text(
                '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              ...order.items
                  .take(2)
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '• ${item.name}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              if (order.items.length > 2)
                Text(
                  '+ ${order.items.length - 2} more items',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              const SizedBox(height: 12),
            ],

            // Total amount and action button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${order.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _viewOrderDetails(order);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: AppColors.primary),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text('View Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _viewOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => OrderDetailsBottomSheet(order: order),
    );
  }
}

// Order Details Bottom Sheet
class OrderDetailsBottomSheet extends StatelessWidget {
  final Order order;

  const OrderDetailsBottomSheet({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Order header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.id}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Chip(
                label: Text(
                  order.status,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                backgroundColor: order.getStatusColor(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Order date and time
          Text(
            dateFormat.format(order.dateTime),
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Order items
          const Text(
            'Order Items',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...order.items
              .map(
                (item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(item.imageUrl),
                    radius: 20,
                  ),
                  title: Text(item.name),
                  subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                  trailing: Text(
                    'Qty: 1',
                  ), // You might want to add quantity to your coffee model
                ),
              )
              .toList(),

          const Divider(height: 30),

          // Order summary
          const Text(
            'Order Summary',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _buildSummaryRow(
            'Subtotal',
            '\$${order.totalAmount.toStringAsFixed(2)}',
          ),
          _buildSummaryRow(
            'Delivery Fee',
            order.isDelivery ? '\$1.00' : 'Free',
          ),
          _buildSummaryRow(
            'Tax',
            '\$${(order.totalAmount * 0.08).toStringAsFixed(2)}',
          ),

          const Divider(height: 30),

          _buildSummaryRow(
            'Total',
            '\$${(order.totalAmount + (order.isDelivery ? 1.00 : 0) + (order.totalAmount * 0.08)).toStringAsFixed(2)}',
            isBold: true,
          ),

          const SizedBox(height: 30),

          // Action buttons
          if (order.status == 'Pending')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Cancel order logic
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Cancel Order'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
