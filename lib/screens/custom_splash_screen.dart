import 'package:flutter/material.dart';
import 'dart:async';

class CustomSplashScreen extends StatefulWidget {
  final Duration duration;
  final Widget nextScreen;
  
  const CustomSplashScreen({
    super.key,
    required this.duration,
    required this.nextScreen,
  });

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    // Create fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    
    // Create scale animation
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );
    
    // Start animation
    _controller.forward();
    
    // Navigate to next screen after duration
    Timer(widget.duration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => widget.nextScreen),
      );
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Image.asset(
            'assets/images/coffee_shop_bg.png',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}