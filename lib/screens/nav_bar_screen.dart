import 'package:cafeshop/screens/favorite_screen.dart';
import 'package:cafeshop/screens/order_list_screen.dart';
import 'package:cafeshop/widgets/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:cafeshop/screens/home_screen.dart';
import 'package:cafeshop/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:cafeshop/provider/users_provider.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Get the user from providera
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.users.isNotEmpty
        ? userProvider.users.first
        : null;

    // Screens for each tab
    final List<Widget> _screens = [
      const HomeScreen(),
      user != null
          ? FavoritesScreen(user: user)
          : const Center(child: Text('Please log in to see favorites')),
      const OrdersScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
