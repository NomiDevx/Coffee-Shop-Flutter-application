import 'package:cafeshop/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          showSelectedLabels: false, // ✅ hide labels
          showUnselectedLabels: false, // ✅ hide labels
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_rounded),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_rounded),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
