import 'package:cafeshop/model/coffee_model.dart';
import 'package:flutter/material.dart';

class CoffeeProvider with ChangeNotifier {
  List<Coffee> _coffees = [
    Coffee(
      id: 'c1',
      name: 'Espresso',
      description:
          "Espresso is a highly concentrated coffee beverage with a luxurious golden crema on top. It's crafted by forcing hot water (about 90°C/195°F) through finely-ground coffee beans at high pressure (9 bars). This extraction process creates a rich, syrupy texture and intensifies the coffee's natural oils and flavors. The signature crema - that velvety, caramel-colored foam - forms from emulsified oils and contains the coffee's aromatic compounds. A proper shot should have perfect balance between sweetness, acidity, and bitterness, with flavor notes ranging from chocolatey and nutty to fruity and floral depending on the bean origin. Typically served in 1-1.5oz portions, espresso forms the base for drinks like cappuccinos and lattes.",
      flavor: 'Bold & Intense',
      price: 3.50,
      size: 'S',
isFavorite : false,
      isIced: false,
      isHot: true,
      rating: 4.7,
      imageUrl: 'assets/images/image.png',
      ingredients: ['Arabica beans', 'Water'],
      calories: 5,
      brewMethod: 'Espresso Machine',
    ),
    Coffee(
      id: 'c2',
      name: 'Iced Caramel Latte',
      description: 'Smooth espresso with milk and caramel over ice',
      flavor: 'Sweet & Creamy',
      price: 5.25,
      size: 'M',
            isFavorite : false,

      isIced: true,
      isHot: false,
      rating: 4.5,
      imageUrl: 'assets/images/coffee2.jpg',
      ingredients: ['Espresso', 'Milk', 'Caramel syrup', 'Ice'],
      calories: 180,
      brewMethod: 'Espresso with Milk',
    ),
    Coffee(
      id: 'c3',
      name: 'Pour Over',
      description: 'Handcrafted single-origin coffee with delicate flavors',
      flavor: 'Fruity & Bright',
      price: 4.75,
      size: 'L',
      isFavorite : false,
      isIced: false,
      isHot: true,
      rating: 4.8,
      imageUrl: 'assets/images/coffee3.jpg',
      ingredients: ['Specialty beans', 'Filtered water'],
      calories: 2,
      brewMethod: 'Pour Over',
    ),
    Coffee(
      id: 'c4',
      name: 'Vanilla Cold Brew',
      description: 'Smooth cold brew infused with vanilla bean',
      flavor: 'Sweet & Mellow',
      price: 5.50,
      size: 'L',
      isFavorite : false,
      isIced: true,
      isHot: false,
      rating: 4.6,
      imageUrl: 'assets/images/coffee4.jpg',
      ingredients: ['Cold brew concentrate', 'Vanilla syrup', 'Milk'],
      calories: 120,
      brewMethod: 'Cold Brew',
    ),
    Coffee(
      id: 'c5',
      name: 'Cappuccino',
      description: 'Espresso with steamed milk and silky foam',
      flavor: 'Rich & Creamy',
      price: 4.25,
      size: 'M',
      isIced: false,
      isFavorite : false,
      isHot: true,
      rating: 4.4,
      imageUrl: 'assets/images/coffee1.jpg',
      ingredients: ['Espresso', 'Steamed milk', 'Foam'],
      calories: 110,
      brewMethod: 'Espresso with Milk',
    ),
  ];

  List<Coffee> get coffees {
    return [..._coffees];
  }

  List<Coffee> get favoriteCoffees {
    return _coffees.where((coffee) => coffee.isFavorite).toList();
  }

  Coffee findById(String id) {
    return _coffees.firstWhere((coffee) => coffee.id == id);
  }

void toggleFavorite(String coffeeId) {
  final index = _coffees.indexWhere((coffee) => coffee.id == coffeeId);
  if (index != -1) {
    _coffees[index] = _coffees[index].copyWith(
      isFavorite: !_coffees[index].isFavorite,
    );
    notifyListeners();
  }
}

  void updateCoffeeSize(String id, String newSize) {
    final index = _coffees.indexWhere((coffee) => coffee.id == id);
    if (index >= 0) {
      _coffees[index] = Coffee(
        id: _coffees[index].id,
        name: _coffees[index].name,
        description: _coffees[index].description,
        flavor: _coffees[index].flavor,
        price: _coffees[index].price,
        size: newSize,
        isIced: _coffees[index].isIced,
        isHot: _coffees[index].isHot,
        rating: _coffees[index].rating,
        isFavorite: _coffees[index].isFavorite,
        imageUrl: _coffees[index].imageUrl,
        ingredients: _coffees[index].ingredients,
        calories: _coffees[index].calories,
        brewMethod: _coffees[index].brewMethod,
      );
      notifyListeners();
    }
  }

  List<Coffee> filterByTemperature(bool isIced) {
    return _coffees.where((coffee) => coffee.isIced == isIced).toList();
  }

  List<Coffee> filterBySize(String size) {
    return _coffees.where((coffee) => coffee.size == size).toList();
  }
}
