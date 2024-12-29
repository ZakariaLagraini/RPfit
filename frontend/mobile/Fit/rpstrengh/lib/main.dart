import 'package:flutter/material.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/welcome_page.dart';
import 'src/services/secure_storage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<bool> _checkSignInStatus() async {
    final token = await SecureStorage.getToken();
    return token != null;
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
