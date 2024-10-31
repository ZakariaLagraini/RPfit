import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<bool> _checkSignInStatus() async {
    // Simulate a sign-in check
    await Future.delayed(const Duration(seconds: 2));
    // Return true if signed in, false otherwise
    return false; // Change this based on your sign-in logic
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _checkSignInStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data == true) {
            return const HomeScreen();
          } else {
            return const WelcomePage();
          }
        },
      ),
    );
  }
}
