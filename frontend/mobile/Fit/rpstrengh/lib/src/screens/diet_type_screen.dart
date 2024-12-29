import 'package:flutter/material.dart';
import 'package:rpstrengh/src/screens/diet_goal_screen.dart';
import 'package:rpstrengh/src/models/user_registration_data.dart';

class DietTypeScreen extends StatefulWidget {
  const DietTypeScreen({super.key});

  @override
  State<DietTypeScreen> createState() => _DietTypeScreenState();
}

class _DietTypeScreenState extends State<DietTypeScreen> {
  String? selectedDietType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.red),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose a diet type',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildDietOption(
              'FAT LOSS',
              'Lose fat while losing weight and preserving muscle.',
            ),
            const SizedBox(height: 10),
            _buildDietOption(
              'MAINTENANCE',
              'Power your workouts and enhance your recovery while staying at your current weight.',
            ),
            const SizedBox(height: 10),
            _buildDietOption(
              'MUSCLE GAIN',
              'Gain muscle while gaining a bit of weight.',
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.info_outline, color: Colors.red),
              label: const Text(
                'Learn more about diet types.',
                style: TextStyle(color: Colors.red),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedDietType != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DietGoalScreen(),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedDietType != null ? Colors.red : Colors.red[100],
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietOption(String title, String description) {
    bool isSelected = selectedDietType == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDietType = title;
          UserRegistrationData.dietType = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.white,
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isSelected)
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
