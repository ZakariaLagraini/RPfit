import 'package:flutter/material.dart';
import 'package:rpstrengh/src/screens/goal_confirmation_screen.dart';

class DietGoalScreen extends StatefulWidget {
  const DietGoalScreen({super.key});

  @override
  State<DietGoalScreen> createState() => _DietGoalScreenState();
}

class _DietGoalScreenState extends State<DietGoalScreen> {
  String? selectedGoal;

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
            const Row(
              children: [
                Text(
                  'Choose a diet goal',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.info_outline, color: Colors.red, size: 28),
              ],
            ),
            const SizedBox(height: 20),
            _buildGoalOption(
              'HIGHEST SUCCESS',
              'LOSE 4.5 KILOGRAMS IN 8 WEEKS',
              'Choose this option to maximize your chances of success based on established diet theory and our own research.',
            ),
            const SizedBox(height: 10),
            _buildGoalOption(
              'SLOW AND STEADY',
              'LOSE 5.5 KILOGRAMS IN 12 WEEKS',
              'Many people can increase their chances of success with a less rapid schedule. If you\'ve struggled with rapid diets in the past, try this option.',
            ),
            const SizedBox(height: 10),
            _buildGoalOption(
              'CUSTOM GOALS',
              '',
              'Choose your own diet duration and rate of fat loss. Shorter and less aggressive diets give you the best chances of success.',
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.info_outline, color: Colors.red),
              label: const Text(
                'Learn more about diet goals and safety.',
                style: TextStyle(color: Colors.red),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedGoal != null 
                    ? () {
                        // Define weight goal based on selection
                        double weightGoal;
                        switch (selectedGoal) {
                          case 'HIGHEST SUCCESS':
                            weightGoal = 4.5;
                            break;
                          case 'SLOW AND STEADY':
                            weightGoal = 5.5;
                            break;
                          case 'CUSTOM GOALS':
                            weightGoal = 4.0; // Default value for custom
                            break;
                          default:
                            weightGoal = 4.0;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GoalConfirmationScreen(
                              goalType: selectedGoal!,
                              weightGoal: weightGoal,
                            ),
                          ),
                        );
                      } 
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedGoal != null ? Colors.red : Colors.red[100],
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

  Widget _buildGoalOption(String title, String subtitle, String description) {
    bool isSelected = selectedGoal == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGoal = title;
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
              ],
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
