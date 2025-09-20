import 'package:cafeshop/model/users_model.dart';
import 'package:cafeshop/widgets/coffee_cards.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cafeshop/provider/coffee_provider.dart';

class FavoritesScreen extends StatelessWidget {
  final User user;
  const FavoritesScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final coffeeProvider = Provider.of<CoffeeProvider>(context);
    final favoriteCoffees = coffeeProvider.coffees
        .where((coffee) => coffee.isFavorite)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: favoriteCoffees.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add coffees to your favorites list',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemCount: favoriteCoffees.length,
              itemBuilder: (context, index) {
                return CoffeeCards(
                  coffee: favoriteCoffees[index],
                  user: user,
                  showFavoriteIcon: true,
                );
              },
            ),
    );
  }
}
