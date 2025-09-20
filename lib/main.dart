import 'package:cafeshop/auth/login_screen.dart';
import 'package:cafeshop/auth/signup_screen.dart';
import 'package:cafeshop/provider/coffee_provider.dart';
import 'package:cafeshop/provider/delivery_provider.dart';
import 'package:cafeshop/provider/order_provider.dart';
import 'package:cafeshop/provider/users_provider.dart';
import 'package:cafeshop/screens/nav_bar_screen.dart';
import 'package:cafeshop/screens/onborad_screen.dart';
import 'package:cafeshop/screens/order_list_screen.dart';
import 'package:cafeshop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cafeshop/screens/home_screen.dart';
import 'package:cafeshop/screens/custom_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => CoffeeProvider()),
        ChangeNotifierProvider(create: (ctx) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DeliveryProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cafe Shop',
      theme: AppTheme.lightTheme,
      home: FutureBuilder<bool>(
        future: _checkFirstLaunch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // final bool isFirstLaunch = snapshot.data ?? true;

          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, authSnapshot) {
              if (authSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              // if (isFirstLaunch) {
              //   // Show onboarding for first-time users
              //   return const CustomSplashScreen(
              //     duration: Duration(seconds: 2),
              //     nextScreen: OnboardingScreen(),
              //     // nextScreen: NavBarScreen(),
              //   );
              // }

              if (authSnapshot.hasData) {
                // User is logged in
                return const CustomSplashScreen(
                  duration: Duration(seconds: 2),
                  nextScreen: NavBarScreen(),
                );
              }

              // User is not logged in
              return const CustomSplashScreen(
                duration: Duration(seconds: 2),
                nextScreen: LoginScreen(),
                // nextScreen: NavBarScreen(),
              );
            },
          );
        },
      ),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/orders': (context) => const OrdersScreen(),
      },
    );
  }

  Future<bool> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    return !hasSeenOnboarding;
  }
}
