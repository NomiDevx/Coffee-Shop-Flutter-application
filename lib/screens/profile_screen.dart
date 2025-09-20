import 'package:cafeshop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to login screen after sign out
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _signOut(context);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User profile section
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                        'assets/images/profile_placeholder.png',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.displayName ?? 'User Name',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user?.email ?? 'user@example.com',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Profile options
              _buildProfileOption(
                icon: Icons.person,
                title: 'Edit Profile',
                onTap: () {},
              ),
              _buildProfileOption(
                icon: Icons.location_on,
                title: 'Addresses',
                onTap: () {},
              ),
              _buildProfileOption(
                icon: Icons.payment,
                title: 'Payment Methods',
                onTap: () {},
              ),
              _buildProfileOption(
                icon: Icons.history,
                title: 'Order History',
                onTap: () {
                  Navigator.pushNamed(context, '/orders');
                },
              ),
              _buildProfileOption(
                icon: Icons.settings,
                title: 'Settings',
                onTap: () {},
              ),
              _buildProfileOption(
                icon: Icons.help,
                title: 'Help & Support',
                onTap: () {},
              ),
              // Logout option in the list
              _buildProfileOption(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () => _showLogoutConfirmation(context),
                isLogout: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: isLogout ? null : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
