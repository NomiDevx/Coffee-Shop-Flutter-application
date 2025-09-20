import 'package:flutter/material.dart';
import 'dart:async';

class AnimatedSplashScreen extends StatefulWidget {
  final Duration duration;
  final Widget nextScreen;
  
  const AnimatedSplashScreen({
    super.key,
    required this.duration,
    required this.nextScreen,
  });

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<Color?> _backgroundAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    // Logo animation - fades in and scales
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );
    
    // Text animation - slides up from bottom
    _textAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
    
    // Optional: Background color animation if you want it to change
    _backgroundAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.white,
    ).animate(_controller);
    
    _controller.forward();
    
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _backgroundAnimation.value,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo
                Opacity(
                  opacity: _logoAnimation.value,
                  child: Transform.scale(
                    scale: _logoAnimation.value,
                    child: Image.asset(
                      'assets/images/coffee_shop_bg.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Animated text (optional)
                Transform.translate(
                  offset: Offset(0, _textAnimation.value),
                  child: const Opacity(
                    opacity: 1.0,
                    child: Text(
                      'Cafe Shop',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}