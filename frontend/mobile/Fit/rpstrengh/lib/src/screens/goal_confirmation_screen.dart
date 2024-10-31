import 'package:flutter/material.dart';
import 'package:rpstrengh/src/screens/home_screen.dart';

class GoalConfirmationScreen extends StatelessWidget {
  final String goalType;
  final double weightGoal;
  
  const GoalConfirmationScreen({
    super.key, 
    required this.goalType,
    required this.weightGoal,
  });

  @override
  Widget build(BuildContext context) {
    // Define color scheme based on goal type
    Color primaryColor;
    switch (goalType) {
      case 'HIGHEST SUCCESS':
        primaryColor = Colors.red;
        break;
      case 'SLOW AND STEADY':
        primaryColor = Colors.red;
        break;
      case 'CUSTOM GOALS':
        primaryColor = Colors.red;
        break;
      default:
        primaryColor = Colors.red;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '02 ABOUT YOUR BODY',
          style: TextStyle(color: primaryColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Spacer(flex: 1),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100],
              ),
              child: Icon(
                Icons.track_changes,
                color: primaryColor,
                size: 40,
              ),
            ),
            const SizedBox(height: 30),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'Losing ${weightGoal.toString()} kg',
                    style: TextStyle(color: primaryColor),
                  ),
                  const TextSpan(
                    text: ' is a reasonable goal. You\'ll get this!',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'We\'re here to make your weight loss journey simple and successful!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const Spacer(flex: 2),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'NEXT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
