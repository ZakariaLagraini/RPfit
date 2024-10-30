import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header with profile
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Hi, Zakaria',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Let\'s check your activity',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFFFFB5B5).withOpacity(0.1),
                  child: const CircleAvatar(
                    radius: 23,
                    backgroundImage: AssetImage('assets/images/body.jpg'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Stats cards
            Row(
              children: [
                _buildStatCard(
                  '12',
                  'Completed\nWorkouts',
                  '💪',
                  Color.fromRGBO(255, 0, 0, 1).withOpacity(0.1),
                ),
                const SizedBox(width: 15),
                _buildStatCard(
                  '2',
                  'Workouts',
                  '🏃‍♀️',
                  Color.fromARGB(255, 202, 2, 2).withOpacity(0.1),
                  subtitle: 'In progress',
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildStatCard(
              '62',
              'Minutes',
              '⏱️',
              Color.fromARGB(255, 255, 0, 0).withOpacity(0.1),
              subtitle: 'Time spent',
              isWide: true,
            ),

            const SizedBox(height: 30),
            
            // Discover section
            const Text(
              'Discover new workouts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            
            // Workout cards
            Row(
              children: [
                Expanded(
                  child: _buildWorkoutCard(
                    'Cardio',
                    '10 Exercises',
                    '50 Minutes',
                    Colors.orange,
                    'assets/images/chest.jpg',
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildWorkoutCard(
                    'Arms',
                    '6 Exercises',
                    '35 Minutes',
                    Colors.teal,
                    'assets/images/challenge_fullbody.jpg',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildWorkoutCard(
              'Stretching',
              '8 Exercises',
              '35 Minutes',
              Color(0xFFFF4436),
              'assets/images/abs.jpg',
              showProgress: true,
              progress: 0,
            ),

            // Progress message
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFFFF4436).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: const [
                  Text(
                    '🎉',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Keep the progress!\nYou are more successful than 88% users.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFFFF4436),
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, String emoji, Color color,
      {String? subtitle, bool isWide = false}) {
    return Container(
      width: isWide ? double.infinity : null,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(emoji, style: const TextStyle(fontSize: 24)),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(String title, String exercises, String duration,
      Color color, String image,
      {bool showProgress = false, double progress = 0}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            color.withOpacity(0.6),
            BlendMode.multiply,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            exercises,
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            duration,
            style: const TextStyle(color: Colors.white70),
          ),
          if (showProgress) ...[
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white30,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 5),
            Text(
              '${(progress * 100).toInt()}/8',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
} 

