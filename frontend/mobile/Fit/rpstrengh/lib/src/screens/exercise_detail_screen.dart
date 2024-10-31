import 'package:flutter/material.dart';
import 'package:rpstrengh/src/screens/workout_session_screen.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final String title;
  final String imagePath;

  const ExerciseDetailScreen({
    super.key,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level Indicator
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Level 3',
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (index) => Container(
                          width: 15,
                          height: 4,
                          margin: const EdgeInsets.only(left: 2),
                          color: index < 3 ? Colors.red : Colors.grey[300],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Exercise Image
            Center(
              child: Image.asset(
                imagePath,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),

            // Playback Controls
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.pause_circle_filled, size: 40),
                    onPressed: () {},
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text('1.0x'),
                  ),
                ],
              ),
            ),

            // Start Workout Button
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutSessionScreen(
                      title: title,
                      imagePath: imagePath,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.play_arrow, color: Colors.red),
                    const SizedBox(width: 8),
                    const Text(
                      'Start Workout',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Exercise Note
            _buildSection(
              'Exercise Note',
              'Write your personal notes and tips',
              Icons.edit_note,
            ),

            // Expert Advice
            _buildSection(
              'Expert Advice',
              'Keep your elbows close to your body to maximize triceps engagement and prevent shoulder strain.',
              Icons.lightbulb_outline,
              backgroundColor: const Color(0xFF1A1B1E),
            ),

            // How to do
            _buildSection(
              'How to do',
              '1- Get into a push-up position with your hands close together under your chest, forming a diamond shape with your thumbs and index fingers.\n\n'
              '2- Lower your body down, keeping your back straight and your core engaged.\n\n'
              '3- Push back up to the starting position, focusing on using your triceps.\n\n'
              '4- Repeat for the desired number of repetitions.',
              Icons.format_list_bulleted,
              backgroundColor: const Color(0xFF1A1B1E),
            ),

            // Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Max Reps'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Total Reps'),
                    ),
                  ),
                ],
              ),
            ),

            // Workout History
            _buildSection(
              'Workout History',
              'The exercise is not completed before.',
              Icons.history,
            ),

            // Routines with this exercise
            _buildSection(
              'Routines with this exercise',
              'Thursday, 31 Oct 2024    Upper Body Strength and...',
              Icons.fitness_center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon,
      {Color backgroundColor = Colors.white, Color textColor = Colors.white}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon,
            color: backgroundColor == Colors.white ? Colors.black : Colors.white),
        title: Text(
          title,
          style: TextStyle(
              color: backgroundColor == Colors.white ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          content,
          style: TextStyle(
              color: backgroundColor == Colors.white
                  ? Colors.grey[600]
                  : Colors.grey[400]),
        ),
      ),
    );
  }
} 