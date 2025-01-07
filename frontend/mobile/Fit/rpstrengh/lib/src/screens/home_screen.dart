import 'package:flutter/material.dart';
import 'workout_screen.dart';
import 'nutrition_screen.dart';
import 'stats_screen.dart';
import 'profile_screen.dart';
import 'package:rpstrengh/src/services/secure_storage.dart';
import 'package:rpstrengh/src/screens/welcome_page.dart';
import 'package:rpstrengh/src/services/workout_plan_service.dart';
import 'package:rpstrengh/src/models/workout_plan.dart';
import 'package:rpstrengh/src/services/client_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const WorkoutScreen(),
    const StatsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color.fromARGB(255, 243, 33, 44),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final WorkoutPlanService _workoutPlanService = WorkoutPlanService();
  final ClientService _clientService = ClientService();
  List<WorkoutPlan> _workoutPlans = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadWorkoutPlans();
  }

  Future<void> _loadWorkoutPlans() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get the client profile first
      final client = await _clientService.getProfile();

      // Use the client's ID to fetch workout plans
      final workoutPlans =
          await _workoutPlanService.getWorkoutPlansByClientId(client.id);

      setState(() {
        _workoutPlans = workoutPlans;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load workout plans: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 243, 33, 44), // Hamburger menu color
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 243, 33, 44),
              ),
              accountName: Text(
                'Workout Plans',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                'Your personalized training programs',
                style: TextStyle(fontSize: 14),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.fitness_center,
                  color: Color.fromARGB(255, 243, 33, 44),
                  size: 30,
                ),
              ),
            ),
            // Workout Plans List in Drawer
            ..._workoutPlans.map((plan) => ListTile(
                  leading: const Icon(Icons.sports_gymnastics),
                  title: Text(plan.name),
                  subtitle: Text('${plan.durationInWeeks} Weeks'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WorkoutScreen(),
                      ),
                    );
                  },
                )),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('Nutrition'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NutritionScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () async {
                try {
                  // Clear the stored token
                  await SecureStorage.deleteToken();

                  // Navigate to welcome page and remove all previous routes
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomePage(),
                      ),
                      (route) => false, // This removes all previous routes
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Logout failed: ${e.toString()}')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced Welcome Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 243, 33, 44),
                      Color.fromARGB(255, 255, 87, 95),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.fitness_center,
                        color: Color.fromARGB(255, 243, 33, 44),
                        size: 30,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Ready to crush your workout today?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              // Quick Actions Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickActionCard(
                          context,
                          icon: Icons.fitness_center,
                          title: 'Start\nWorkout',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WorkoutScreen(),
                              ),
                            );
                          },
                        ),
                        _buildQuickActionCard(
                          context,
                          icon: Icons.restaurant_menu,
                          title: 'View\nNutrition',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NutritionScreen(),
                              ),
                            );
                          },
                        ),
                        _buildQuickActionCard(
                          context,
                          icon: Icons.person,
                          title: 'My\nProfile',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 30,
              color: const Color.fromARGB(255, 243, 33, 44),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
