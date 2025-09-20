import 'package:cafeshop/model/coffee_model.dart';
import 'package:cafeshop/provider/coffee_provider.dart';
import 'package:cafeshop/provider/users_provider.dart';
import 'package:cafeshop/theme/theme.dart';
import 'package:cafeshop/widgets/coffee_cards.dart';
import 'package:cafeshop/widgets/filter_bar.dart';
import 'package:cafeshop/widgets/promo_bannner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFilter = 'All';
  final Map<String, String> _filterOptions = {
    'All': 'All',
    'Arabica beans': 'Arabica',
    'Robusta beans': 'Robusta',
    'Milk': 'Milk',
    'Chocolate': 'Chocolate',
    'Caramel': 'Caramel',
    'Vanilla': 'Vanilla',
    'Water': 'Water',
  };

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context);
    final users = userData.users;
    final coffeeProvider = Provider.of<CoffeeProvider>(context);

    // Get filtered coffees based on selected filter
    List<Coffee> filteredCoffees = _getFilteredCoffees(coffeeProvider.coffees);

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 54, 45, 45),
                          AppColors.dark,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.paddingMedium),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25),
                          Text(
                            'Location',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            users.first.location.address,
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        54,
                                        45,
                                        45,
                                      ), // Same as container color
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      style: TextStyle(
                                        color: AppColors.greyLight,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Search Coffee',
                                        hintStyle: TextStyle(
                                          color: AppColors.greyLight
                                              .withOpacity(0.7),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 20,
                                            ),
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: AppColors.greyLight
                                              .withOpacity(0.7),
                                        ),
                                        filled: true,
                                        fillColor: const Color.fromARGB(
                                          255,
                                          54,
                                          45,
                                          45,
                                        ), // Same as container color
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Card(
                                  color: AppColors.primary,
                                  child: IconButton(
                                    onPressed: () {
                                      _showFilterBottomSheet(context);
                                    },
                                    icon: const Icon(
                                      Icons.format_align_left_rounded,
                                      color: AppColors.background,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.paddingMedium),
                    child: Column(
                      children: [
                        FilterBar(
                          selectedFilter: _selectedFilter,
                          onFilterSelected: _handleFilterSelection,
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SizeTransition(
                                    sizeFactor: animation,
                                    axis: Axis.vertical,
                                    child: child,
                                  ),
                                );
                              },
                          child: filteredCoffees.isEmpty
                              ? _buildEmptyState()
                              : GridView.builder(
                                  key: ValueKey(
                                    _selectedFilter,
                                  ), // Important for animations
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 16,
                                        crossAxisSpacing: 16,
                                        childAspectRatio: 0.65,
                                      ),
                                  itemCount: filteredCoffees.length,
                                  itemBuilder: (context, index) {
                                    final coffee = filteredCoffees[index];
                                    return CoffeeCards(
                                      coffee: coffee,
                                      user: users.first,
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 150,
                left: 0,
                right: 0,
                child: const PromoBanner(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Filter coffees based on selected ingredient
  List<Coffee> _getFilteredCoffees(List<Coffee> allCoffees) {
    if (_selectedFilter == 'All') {
      return allCoffees;
    }

    return allCoffees.where((coffee) {
      return coffee.ingredients.any(
        (ingredient) =>
            ingredient.toLowerCase().contains(_selectedFilter.toLowerCase()),
      );
    }).toList();
  }

  // Handle filter selection with animation
  void _handleFilterSelection(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  // Show filter options in a bottom sheet
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.dark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Filter by Ingredient',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _filterOptions.entries.map((entry) {
                  return FilterChip(
                    label: Text(entry.value),
                    selected: _selectedFilter == entry.key,
                    onSelected: (bool selected) {
                      Navigator.pop(context);
                      _handleFilterSelection(selected ? entry.key : 'All');
                    },
                    selectedColor: AppColors.primary,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: _selectedFilter == entry.key
                          ? Colors.white
                          : Colors.black,
                    ),
                    backgroundColor: Colors.grey[300],
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Build empty state when no coffees match the filter
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.coffee_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No coffees found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different filter',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
