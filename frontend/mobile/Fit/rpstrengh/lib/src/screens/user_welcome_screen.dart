import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rpstrengh/src/screens/user_details_screen.dart';
import 'package:rpstrengh/src/models/user_registration_data.dart';

class UserWelcomeScreen extends StatefulWidget {
  const UserWelcomeScreen({super.key});

  @override
  State<UserWelcomeScreen> createState() => _UserWelcomeScreenState();
}

class _UserWelcomeScreenState extends State<UserWelcomeScreen> {
  bool _isDisclaimerAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Log out',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'assets/images/rp_logo.svg',
              height: 40,
            ),
            const SizedBox(height: 20),
            const Text(
              'Hi! Welcome.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'You are logged in with\n${UserRegistrationData.email ?? ""}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'On the next few screens, we\'ll ask you about yourself, your dieting goals, and your schedule so that we can design a diet you can succeed with!',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Row(
              children: [
                const Text('Accept medical disclaimer'),
                const Spacer(),
                Switch(
                  value: _isDisclaimerAccepted,
                  onChanged: (value) {
                    setState(() {
                      _isDisclaimerAccepted = value;
                    });
                  },
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View medical disclaimer',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isDisclaimerAccepted
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserDetailsScreen(),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 244, 67, 54),
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'Get started',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
