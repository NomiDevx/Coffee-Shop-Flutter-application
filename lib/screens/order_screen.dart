import 'package:cafeshop/model/coffee_model.dart';
import 'package:cafeshop/model/order_model.dart';
import 'package:cafeshop/model/users_model.dart';
import 'package:cafeshop/provider/order_provider.dart';
import 'package:cafeshop/provider/users_provider.dart';
import 'package:cafeshop/screens/delivery_traking_screen.dart';
import 'package:cafeshop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  final Coffee coffee;
  final User user;
  final String selectedSize;

  const OrderScreen({
    required this.selectedSize,
    required this.user,
    required this.coffee,
    super.key,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  bool _isDelivery = true;
  int _quantity = 1;
  final TextEditingController _noteController = TextEditingController();
  String _deliveryNote = '';
  bool _discountApplied = false;
  String _paymentMethod = 'Cash/Wallet';
  late AnimationController _animationController;
  late Animation<Offset> _deliveryAnimation;
  late Animation<Offset> _pickupAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _deliveryAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _pickupAnimation =
        Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // Calculate size multiplier based on selected size
  double get _sizeMultiplier {
    switch (widget.selectedSize) {
      case 'S':
        return 1.0; // No increase for small
      case 'M':
        return 1.15; // 15% increase for medium
      case 'L':
        return 1.3; // 30% increase for large
      default:
        return 1.0;
    }
  }

  // Calculate base price with size adjustment
  double get _basePrice {
    return widget.coffee.price * _sizeMultiplier;
  }

  // Generate a unique order ID
  String _generateOrderId() {
    final now = DateTime.now();
    return 'ORD${now.millisecondsSinceEpoch}';
  }

  void _showAddressEditDialog(UserProvider userProvider) {
    final addressController = TextEditingController(
      text: widget.user.location.address,
    );
    final nameController = TextEditingController(text: widget.user.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Address'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              userProvider.updateUserAddress(
                nameController.text,
                addressController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Delivery Note'),
        content: TextField(
          controller: _noteController,
          decoration: const InputDecoration(
            hintText: 'Special instructions for delivery...',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _deliveryNote = _noteController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDiscountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply Discount'),
        content: const Text('Enter discount code:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _discountApplied = true;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Discount applied successfully!')),
              );
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Payment Method'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.wallet),
              title: const Text('Cash/Wallet'),
              onTap: () {
                setState(() {
                  _paymentMethod = 'Cash/Wallet';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Credit Card'),
              onTap: () {
                setState(() {
                  _paymentMethod = 'Credit Card';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Digital Payment'),
              onTap: () {
                setState(() {
                  _paymentMethod = 'Digital Payment';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderSummary() {
    final subtotal = _basePrice * _quantity;
    final discount = _discountApplied ? subtotal * 0.1 : 0;
    final deliveryFee = _isDelivery ? 1 : 0.0;
    final total = subtotal - discount + deliveryFee;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Order Summary',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/image.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.coffee.name),
                  Text(
                    'Size: ${widget.selectedSize}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              subtitle: Text('Quantity: $_quantity'),
              trailing: Text('\$${subtotal.toStringAsFixed(2)}'),
            ),
            if (_discountApplied)
              ListTile(
                leading: const Icon(Icons.discount, color: Colors.green),
                title: const Text('Discount (10%)'),
                trailing: Text('-\$${discount.toStringAsFixed(2)}'),
              ),
            ListTile(
              leading: const Icon(Icons.delivery_dining),
              title: Text(_isDelivery ? 'Delivery Fee' : 'Pickup'),
              trailing: Text(_isDelivery ? '\$$deliveryFee' : 'Free'),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _placeOrder(context, total);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => OrdersScreen()),
                // );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Confirm Order',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _placeOrder(BuildContext context, double total) {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    final subtotal = _basePrice * _quantity;
    final discount = _discountApplied ? subtotal * 0.1 : 0;
    final deliveryFee = _isDelivery ? 1 : 0.0;

    // Create a new order
    final newOrder = Order(
      id: _generateOrderId(),
      userId: widget.user.id,
      items: [widget.coffee], // Add the coffee to items list
      totalAmount: total,
      dateTime: DateTime.now(),
      status: 'Pending', // Initial status
      paymentMethod: _paymentMethod,
      deliveryAddress: _isDelivery ? widget.user.location.address : null,
      isDelivery: _isDelivery,
    );

    // Add the order to the provider
    ordersProvider.addOrder(newOrder);

    // Show success message
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Order placed successfully!')));

    // Navigate to delivery tracking screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeliveryTrackingScreen(
          orderId: newOrder.id,
          deliveryPersonName: 'John Doe',
          estimatedTime: '15-20 min',
        ),
      ),
    );
  }

  void _toggleDeliveryOption(bool isDelivery) {
    if (_isDelivery != isDelivery) {
      setState(() {
        _isDelivery = isDelivery;
      });
      // Reset and restart animation for smooth transition
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    final subtotal = _basePrice * _quantity;
    final discount = _discountApplied ? subtotal * 0.1 : 0;
    final deliveryFee = _isDelivery ? 1.0 : 0;
    final total = subtotal - discount + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.black,
        ),
        title: Center(
          child: Text(
            'Order',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_outline_rounded, size: 30),
            color: Colors.black,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Deliver / Pickup card with animation
              Card(
                color: Colors.white38,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: SlideTransition(
                          position: _deliveryAnimation,
                          child: ElevatedButton(
                            onPressed: () => _toggleDeliveryOption(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isDelivery
                                  ? AppColors.primary
                                  : Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Deliver',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: _isDelivery
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.paddingMedium),
                      Expanded(
                        child: SlideTransition(
                          position: _pickupAnimation,
                          child: ElevatedButton(
                            onPressed: () => _toggleDeliveryOption(false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !_isDelivery
                                  ? AppColors.primary
                                  : Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Pickup',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: !_isDelivery
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.paddingLarge),

              // Address and actions (with animation)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isDelivery
                    ? Container(
                        key: const ValueKey('delivery'),
                        margin: EdgeInsets.only(
                          bottom: AppSpacing.paddingLarge,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.user.name,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                            ),
                            SizedBox(height: AppSpacing.paddingSmall),
                            Text(
                              widget.user.location.address,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.black45,
                                    fontSize: 14,
                                  ),
                            ),
                            SizedBox(height: AppSpacing.paddingSmall),
                            Text(
                              'Delivery Address',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                            ),
                            SizedBox(height: AppSpacing.paddingSmall),
                            if (_deliveryNote.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Note: $_deliveryNote',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Colors.black54,
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                        ),
                                  ),
                                  SizedBox(height: AppSpacing.paddingSmall),
                                ],
                              ),
                            Row(
                              children: [
                                // Edit Address
                                TextButton.icon(
                                  onPressed: () =>
                                      _showAddressEditDialog(userProvider),
                                  icon: const Icon(
                                    Icons.edit_square,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                  label: Text(
                                    'Edit Address',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                  ),
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: AppSpacing.paddingSmall),

                                // Add Note
                                TextButton.icon(
                                  onPressed: _showNoteDialog,
                                  icon: const Icon(
                                    Icons.note_add_outlined,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                  label: Text(
                                    'Add Note',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                  ),
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(
                        key: const ValueKey('pickup'),
                        margin: EdgeInsets.only(
                          bottom: AppSpacing.paddingLarge,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pickup Information',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                            ),
                            SizedBox(height: AppSpacing.paddingSmall),
                            Text(
                              'Store: ${widget.user.location.address}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.black45,
                                    fontSize: 14,
                                  ),
                            ),
                            SizedBox(height: AppSpacing.paddingSmall),
                            Text(
                              'Estimated pickup time: 10-15 minutes',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                  ),
                            ),
                          ],
                        ),
                      ),
              ),

              Divider(color: Colors.black26, thickness: 1),
              SizedBox(height: AppSpacing.paddingLarge),

              // Coffee item with quantity controls and size info
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/image.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: AppSpacing.paddingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.coffee.name,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                        ),
                        SizedBox(height: AppSpacing.paddingSmall),
                        Text(
                          'Size: ${widget.selectedSize} (+${((_sizeMultiplier - 1) * 100).toInt()}%)',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.primary,
                                fontSize: 14,
                              ),
                        ),
                        SizedBox(height: AppSpacing.paddingSmall),
                        Text(
                          widget.coffee.ingredients.first,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.black45, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_quantity > 1) {
                            setState(() {
                              _quantity--;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: _quantity > 1 ? Colors.black : Colors.grey,
                        ),
                      ),
                      SizedBox(width: AppSpacing.paddingSmall),
                      Text(
                        '$_quantity',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: AppSpacing.paddingSmall),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.paddingLarge),
              Divider(
                color: const Color.fromARGB(66, 175, 131, 49),
                thickness: 2,
              ),
              SizedBox(height: AppSpacing.paddingLarge),

              // Discount card
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.paddingLarge),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.discount_rounded,
                        color: AppColors.primary,
                        size: 30,
                      ),
                      Text(
                        _discountApplied
                            ? 'Discount applied'
                            : 'Apply Discount',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        onPressed: _showDiscountDialog,
                        icon: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black54,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.paddingLarge),

              // Payment Summary
              Text(
                'Payment Summary',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: AppSpacing.paddingMedium),

              Container(
                padding: EdgeInsets.all(AppSpacing.paddingMedium),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Base Price',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.black, fontSize: 16),
                        ),
                        const Spacer(),
                        Text(
                          '\$${(widget.coffee.price).toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.paddingSmall),
                    Row(
                      children: [
                        Text(
                          'Size (${widget.selectedSize})',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.black, fontSize: 16),
                        ),
                        const Spacer(),
                        Text(
                          '+${((_sizeMultiplier - 1) * 100).toInt()}%',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.primary,
                                fontSize: 16,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.paddingSmall),
                    Row(
                      children: [
                        Text(
                          'Price',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.black, fontSize: 16),
                        ),
                        const Spacer(),
                        Text(
                          '\$${_basePrice.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.paddingSmall),
                    Row(
                      children: [
                        Text(
                          'Quantity',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.black, fontSize: 16),
                        ),
                        const Spacer(),
                        Text(
                          'x$_quantity',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.paddingSmall),
                    if (_discountApplied)
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Discount',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.green,
                                      fontSize: 16,
                                    ),
                              ),
                              const Spacer(),
                              Text(
                                '-\$${discount.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.green,
                                      fontSize: 16,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.paddingSmall),
                        ],
                      ),
                    Row(
                      children: [
                        Text(
                          'Delivery Fee',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.black, fontSize: 16),
                        ),
                        const Spacer(),
                        Text(
                          _isDelivery ? '\$$deliveryFee' : 'Free',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.paddingMedium),
                    Divider(color: Colors.black26),
                    SizedBox(height: AppSpacing.paddingSmall),
                    Row(
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                        ),
                        const Spacer(),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.paddingLarge),

              // Payment Method
              Container(
                padding: EdgeInsets.all(AppSpacing.paddingMedium),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.wallet, color: AppColors.primary, size: 30),
                        SizedBox(width: AppSpacing.paddingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _paymentMethod,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                              ),
                              SizedBox(height: AppSpacing.paddingSmall),
                              Text(
                                '\$${total.toStringAsFixed(2)} available',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppColors.primary,
                                      fontSize: 14,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _showPaymentMethodDialog,
                          icon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.black54,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.paddingLarge),

              // Place Order Button
              ElevatedButton(
                onPressed: _showOrderSummary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Place Order - \$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
