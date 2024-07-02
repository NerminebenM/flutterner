import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Simulate some loading process
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Navigate to next screen after a delay
    if (isLoggedIn) {
      // If the user is logged in, go to the profile screen
      Navigator.of(context).pushReplacementNamed('/profile');
    } else {
      // If the user is not logged in, go to the login screen
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(), // Show progress indicator during waiting
      ),
    );
  }
}
