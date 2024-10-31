import 'package:flutter/material.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header Image and Title
            Stack(
              children: [
                // Main Image
                Image.asset(
                  'assets/images/yoga_header.jpg',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Back and Share buttons
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.file_upload_outlined, color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.bookmark_border, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Title and Tags
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Yoga Body Stretching',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildTag('Beginner'),
                          const SizedBox(width: 8),
                          _buildTag('15 minutes'),
                          const SizedBox(width: 8),
                          _buildTag('10 workout'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Workout List Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Workout Activity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See All',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),

            // Workout List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildWorkoutItem('Warrior 1', '30 seconds', 'assets/images/warrior1.jpg'),
                  _buildWorkoutItem('Side Plank', '20 seconds', 'assets/images/side_plank.jpg'),
                  _buildWorkoutItem('One Leg Downward', '20 seconds', 'assets/images/one_leg_down.jpg'),
                  _buildWorkoutItem('Triangle Pose', '40 seconds', 'assets/images/triangle.jpg'),
                  _buildWorkoutItem('Stork Pose', '30 seconds', 'assets/images/stork.jpg'),
                  _buildWorkoutItem('Wheel Pose', '30 seconds', 'assets/images/wheel.jpg'),
                  _buildWorkoutItem('One Leg Stand', '40 seconds', 'assets/images/one_leg_stand.jpg'),
                  _buildWorkoutItem('Half Moon Pose', '30 seconds', 'assets/images/half_moon.jpg'),
                  _buildWorkoutItem('Camel Pose', '30 seconds', 'assets/images/camel.jpg'),
                  _buildWorkoutItem('One Leg Up', '40 seconds', 'assets/images/one_leg_up.jpg'),
                ],
              ),
            ),

            // Start Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'START',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildWorkoutItem(String title, String duration, String imagePath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  duration,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
