import 'package:cafeshop/model/coffee_model.dart';
import 'package:cafeshop/model/users_model.dart';
import 'package:cafeshop/provider/coffee_provider.dart';
import 'package:cafeshop/screens/order_screen.dart';
import 'package:cafeshop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeDetailScreen extends StatefulWidget {
  final Coffee coffee;
  final User user;
  const CoffeeDetailScreen({
    super.key,
    required this.user,
    required this.coffee,
  });

  @override
  State<CoffeeDetailScreen> createState() => _CoffeeDetailScreenState();
}

class _CoffeeDetailScreenState extends State<CoffeeDetailScreen> {
  bool _isExpanded = false;
  String _selectedSize = "M";
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite =
        widget.coffee.isFavorite; // Initialize with coffee's favorite status
  }

  void _navigateToOrderScreen() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => OrderScreen(
          user: widget.user,
          coffee: widget.coffee,
          selectedSize: _selectedSize,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.black,
        ),
        title: Text(
          'Detail',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<CoffeeProvider>(
            builder: (context, coffeeProvider, _) {
              final isFavorite = coffeeProvider
                  .findById(widget.coffee.id)
                  .isFavorite;
              return IconButton(
                onPressed: () {
                  coffeeProvider.toggleFavorite(widget.coffee.id);
                },
                icon: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  size: 30,
                  color: isFavorite ? Colors.red : Colors.black,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/images/coffeedisplay.jpg",
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.coffee.name,
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.coffee.isIced ? 'Iced' : 'Hot',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.greyLight,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.delivery_dining,
                                size: 24,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.free_breakfast_rounded,
                                size: 24,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.local_drink_rounded,
                                size: 24,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rate_rounded,
                          color: Colors.amber,
                          size: 24,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.coffee.rating.toString(),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: Colors.grey, thickness: 1),
                    const SizedBox(height: 8),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        Text(
                          widget.coffee.description,
                          maxLines: _isExpanded ? null : 3,
                          overflow: _isExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                        ),
                        InkWell(
                          onTap: () =>
                              setState(() => _isExpanded = !_isExpanded),
                          child: Text(
                            _isExpanded ? "Read less" : "Read more",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Size',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: ["S", "M", "L"].map((size) {
                        final isSelected = _selectedSize == size;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: OutlinedButton(
                              onPressed: () =>
                                  setState(() => _selectedSize = size),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: isSelected
                                    ? AppColors.primary.withOpacity(0.1)
                                    : Colors.transparent,
                                foregroundColor: isSelected
                                    ? AppColors.primary
                                    : Colors.black,
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: Text(
                                size,
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom purchase section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Price',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                    Text(
                      '\$${(widget.coffee.price).toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _navigateToOrderScreen,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 18,
                        ),
                      ),
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
