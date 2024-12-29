import 'package:flutter/material.dart';
import 'package:rpstrengh/src/screens/goal_confirmation_screen.dart';
import 'package:rpstrengh/src/services/client_service.dart';
import 'package:rpstrengh/src/models/user_registration_data.dart';
import 'package:rpstrengh/src/services/secure_storage.dart';
import 'package:rpstrengh/src/models/client.dart';

class DietGoalScreen extends StatefulWidget {
  const DietGoalScreen({super.key});

  @override
  State<DietGoalScreen> createState() => _DietGoalScreenState();
}

class _DietGoalScreenState extends State<DietGoalScreen> {
  String? selectedGoal;
  bool _isLoading = false;

  void _debugPrintRegistrationData() {
    print('Debug Registration Data:');
    print('Email: ${UserRegistrationData.email}');
    print('Password: ${UserRegistrationData.password}');
    print('Age: ${UserRegistrationData.age}');
    print('Height: ${UserRegistrationData.height}');
    print('Weight: ${UserRegistrationData.weight}');
    print('Selected Goal: $selectedGoal');
    print('Calculated Weight Goal: ${_calculateWeightGoal()}');
  }

  bool _validateRegistrationData() {
    return UserRegistrationData.email != null &&
        UserRegistrationData.password != null &&
        UserRegistrationData.age != null &&
        UserRegistrationData.height != null &&
        UserRegistrationData.weight != null &&
        selectedGoal != null;
  }

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
                    ? () async {
                        _debugPrintRegistrationData();

                        if (!_validateRegistrationData()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please complete all required information'),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          String serverGoal =
                              _convertGoalToServerEnum(selectedGoal!);
                          UserRegistrationData.dietGoal = serverGoal;

                          final client = Client(
                            id: 0,
                            email: UserRegistrationData.email!,
                            password: UserRegistrationData.password!,
                            goal: serverGoal,
                            age: UserRegistrationData.age!.toDouble(),
                            height: UserRegistrationData.height!,
                            weight: UserRegistrationData.weight!,
                          );

                          final ClientService clientService = ClientService();
                          await clientService.register(client);

                          final token = await clientService.login(
                              UserRegistrationData.email!,
                              UserRegistrationData.password!);

                          await SecureStorage.storeToken(token);

                          final calculatedWeightGoal = _calculateWeightGoal() ??
                              UserRegistrationData.weight!;
                          final selectedGoalType = selectedGoal!;

                          UserRegistrationData.clear();

                          if (!mounted) return;

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GoalConfirmationScreen(
                                goalType: selectedGoalType,
                                weightGoal: calculatedWeightGoal,
                              ),
                            ),
                            (route) => false,
                          );
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Registration failed: ${e.toString()}')),
                          );
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedGoal != null ? Colors.red : Colors.red[100],
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
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

  double? _calculateWeightGoal() {
    if (selectedGoal == null || UserRegistrationData.weight == null) {
      return null;
    }

    switch (selectedGoal) {
      case 'HIGHEST SUCCESS':
        return UserRegistrationData.weight! - 4.5; // Lose 4.5kg in 8 weeks
      case 'SLOW AND STEADY':
        return UserRegistrationData.weight! - 5.5; // Lose 5.5kg in 12 weeks
      case 'CUSTOM GOALS':
        return UserRegistrationData.weight; // No change for custom goals
      default:
        return null;
    }
  }

  String _convertGoalToServerEnum(String uiGoal) {
    switch (uiGoal) {
      case 'HIGHEST SUCCESS':
      case 'SLOW AND STEADY':
        return 'WEIGHT_LOSS';
      case 'CUSTOM GOALS':
        return 'MAINTAIN';
      default:
        return 'MAINTAIN';
    }
  }
}
