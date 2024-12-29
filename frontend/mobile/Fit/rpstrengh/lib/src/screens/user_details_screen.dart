import 'package:flutter/material.dart';
import 'package:rpstrengh/src/screens/diet_type_screen.dart';
import 'package:rpstrengh/src/models/user_registration_data.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  bool isMetric = false;
  String? selectedSex;
  String? weight;
  String? height;
  String? age;
  String? bodyFat;

  // Add this method to check completion
  bool _isFormComplete() {
    return selectedSex != null &&
        weight != null &&
        height != null &&
        age != null &&
        bodyFat != null;
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
            const Text(
              'Your details',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isMetric = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !isMetric ? Colors.white : Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Text(
                          'lbs / inches',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isMetric = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isMetric ? Colors.white : Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Text(
                          'kg / cm',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildDetailRow('Sex', selectedSex, () => _showSexPicker(context)),
            _buildDetailRow('Weight', weight, () => _showWeightPicker(context)),
            _buildDetailRow('Height', height, () => _showHeightPicker(context)),
            _buildDetailRow('Age', age, () => _showAgePicker(context)),
            _buildDetailRow(
                'Body fat %', bodyFat, () => _showBodyFatPicker(context),
                showInfo: true),
            const Spacer(),
            _buildSecuritySection(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isFormComplete()
                    ? () {
                        // Navigate to next screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const DietTypeScreen(), // Replace with your next screen
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isFormComplete() ? Colors.red : Colors.red[100],
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: _isFormComplete()
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value, VoidCallback onTap,
      {bool showInfo = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18),
          ),
          if (showInfo) const Icon(Icons.help_outline, color: Colors.grey),
          const Spacer(),
          value != null
              ? Text(
                  value,
                  style: const TextStyle(
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                  ),
                )
              : ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'ENTER',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            children: [
              Expanded(
                child: Text(
                  'Your data is secure.\nWe don\'t send or sell your data to 3rd parties.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Icon(Icons.shield_outlined, color: Colors.grey),
            ],
          ),
        ),
        const SizedBox(height: 20),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.info_outline, color: Colors.red),
          label: const Text(
            'Learn how we keep you safe while dieting.',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  // Add the picker methods here
  void _showSexPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Your sex',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildSexOption(
                    'FEMALE',
                    Icons.female,
                    selectedSex == 'FEMALE',
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildSexOption(
                    'MALE',
                    Icons.male,
                    selectedSex == 'MALE',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text(
                  'Set your sex',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSexOption(String sex, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSex = sex;
          UserRegistrationData.sex = sex;
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
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.red,
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              sex,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.red,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWeightPicker(BuildContext context) {
    String tempWeight = '';

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your current weight in ${isMetric ? 'kilograms' : 'pounds'}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => tempWeight = value,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (tempWeight.isNotEmpty) {
                    setState(() {
                      weight = '$tempWeight ${isMetric ? 'KG' : 'LBS'}';
                      UserRegistrationData.weight = double.parse(tempWeight);
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text(
                  'Set your weight',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBodyFatPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Your body fat %',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _buildBodyFatOption('< 15%'),
                _buildBodyFatOption('15-22%'),
                _buildBodyFatOption('22-30%'),
                _buildBodyFatOption('> 30%'),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text(
                  'Set your body fat %',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyFatOption(String percentage) {
    bool isSelected = bodyFat == percentage;
    return GestureDetector(
      onTap: () {
        setState(() => bodyFat = percentage);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.white,
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              percentage,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.red,
                fontSize: 16,
              ),
            ),
            // Add image here
          ],
        ),
      ),
    );
  }

  // Add similar methods for height, age, and body fat pickers

  void _showHeightPicker(BuildContext context) {
    String tempHeight = '';

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Height in ${isMetric ? 'centimeters' : 'inches'}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => tempHeight = value,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (tempHeight.isNotEmpty) {
                    setState(() {
                      height = '$tempHeight ${isMetric ? 'CM' : 'IN'}';
                      UserRegistrationData.height = double.parse(tempHeight);
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text(
                  'Set your height',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAgePicker(BuildContext context) {
    String tempAge = '';

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Your age',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => tempAge = value,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (tempAge.isNotEmpty) {
                    setState(() {
                      age = tempAge;
                      UserRegistrationData.age = int.parse(tempAge);
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text(
                  'Set your age',
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
