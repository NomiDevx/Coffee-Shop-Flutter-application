import 'package:cafeshop/model/coffee_model.dart';
import 'package:cafeshop/model/users_model.dart';
import 'package:cafeshop/screens/coffee_detail_screen.dart';
import 'package:cafeshop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cafeshop/provider/coffee_provider.dart';

class CoffeeCards extends StatefulWidget {
  final Coffee coffee;
  final User user;
  final bool showFavoriteIcon;

  const CoffeeCards({
    super.key,
    required this.coffee,
    required this.user,
    this.showFavoriteIcon = false,
  });

  @override
  State<CoffeeCards> createState() => _CoffeeCardState();
}

class _CoffeeCardState extends State<CoffeeCards> {
  @override
  Widget build(BuildContext context) {
    final coffeeProvider = Provider.of<CoffeeProvider>(context, listen: false);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CoffeeDetailScreen(coffee: widget.coffee, user: widget.user),
          ),
        );
      },
      child: SizedBox(
        // width: 150,
        // height: 180,
        child: Stack(
          children: [
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        widget.coffee.imageUrl,
                        height: 125,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.coffee.name,
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.coffee.ingredients.first}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${widget.coffee.price}',
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                                fontSize: 18,
                              ),
                        ),
                        Card(
                          color: AppColors.primary,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.add,
                              size: 26,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rate_rounded,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.coffee.rating.toString(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.showFavoriteIcon)
              Positioned(
                top: 12,
                left: 12,
                child: IconButton(
                  icon: Icon(
                    widget.coffee.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.coffee.isFavorite ? Colors.red : Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    coffeeProvider.toggleFavorite(widget.coffee.id);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
