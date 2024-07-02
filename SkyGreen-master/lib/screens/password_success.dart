import 'package:flutter/material.dart';

class PasswordUpdateSuccessScreen extends StatefulWidget {
  @override
  _PasswordUpdateSuccessScreenState createState() =>
      _PasswordUpdateSuccessScreenState();
}

class _PasswordUpdateSuccessScreenState
    extends State<PasswordUpdateSuccessScreen> {
  @override
  void initState() {
    super.initState();

    // Delay for 5 seconds and then navigate to home screen
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/success.png', height: 100, width: 100),
            SizedBox(height: 16),
            Text(
              'Password Updated',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
