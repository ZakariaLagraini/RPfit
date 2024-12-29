import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:rpstrengh/src/screens/home_screen.dart';
import 'package:rpstrengh/src/screens/user_welcome_screen.dart';
import 'package:rpstrengh/src/screens/login_page.dart';
import 'package:rpstrengh/src/services/client_service.dart';
import 'package:rpstrengh/src/models/user_registration_data.dart';
// import 'package:rpstrengh/src/services/secure_storage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ClientService clientService = ClientService();
  final bool _isLogin = false; // Toggle between login and signup view

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Logo
              SvgPicture.asset(
                'assets/images/rp_logo.svg',
                height: 60,
              ),
              const SizedBox(height: 30),

              // Title
              Text(
                _isLogin ? 'Welcome Back' : 'Create your account',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // Social Login Buttons (only show for signup)
              if (!_isLogin) ...[
                OutlinedButton(
                  onPressed: () {
                    // Implement Facebook auth
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/facebook_logo.png',
                          height: 24),
                      const SizedBox(width: 10),
                      const Text('Continue with Facebook'),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                OutlinedButton(
                  onPressed: () {
                    // Implement Google auth
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/google_logo.png', height: 24),
                      const SizedBox(width: 10),
                      const Text('Continue with Google'),
                    ],
                  ),
                ),

                // Divider
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text('OR', style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                ),
              ],

              // Form Fields
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Action Button (modify to only handle signup)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty) {
                      UserRegistrationData.email = _emailController.text;
                      UserRegistrationData.password = _passwordController.text;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserWelcomeScreen(),
                        ),
                      );
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.scale,
                        title: 'Invalid Input',
                        desc: 'Please enter both email and password',
                        btnOkOnPress: () {},
                        btnOkColor: const Color(0xFFFFB5B5),
                      ).show();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB5B5),
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Create account',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              // Toggle Button (modify to navigate to LoginPage)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              // Terms Text (only show for signup)
              if (!_isLogin) ...[
                const Text(
                  'By creating an account you accept our',
                  style: TextStyle(color: Colors.grey),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('Terms of Service'),
                    ),
                    const Text('and', style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Privacy Policy'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
