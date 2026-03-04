import 'package:flutter/material.dart';
import 'package:flutter_app_project/screens/main_navigation.dart'; // Make sure this path matches your file!
import 'package:flutter_app_project/utils/theme.dart'; // To access your AppColors

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // 1. Setup the Fade-In Animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Fades in smoothly over 1.5 seconds
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn)
    );

    // Start the animation
    _animationController.forward();

    // 2. Wait 3 seconds, then navigate to the Home Screen
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // We use pushReplacement so the user can't hit the "Back" button to return to the splash screen
        Navigator.pushReplacement(
          context,
          // PageRouteBuilder allows us to create a smooth cross-fade transition to the home screen
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const RealEstateHome(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800), // 0.8 second transition
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background makes the CPL logo pop
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0), // Breathing room on the sides
            child: Image.asset(
              'assets/images/cpl_logo.png', // This matches the path we set up earlier
              fit: BoxFit.contain,
              
              // Fallback just in case the image hasn't loaded properly yet
              errorBuilder: (context, error, stackTrace) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.domain, size: 80, color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text(
                      "CPL REAL ESTATE", 
                      style: TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.w900)
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}