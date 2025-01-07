import 'package:flutter/material.dart';
import '../models/client.dart';
import '../services/client_service.dart';

class EditProfileScreen extends StatefulWidget {
  final Client client;

  const EditProfileScreen({super.key, required this.client});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  String _selectedGoal = '';

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.client.email);
    _ageController = TextEditingController(text: widget.client.age.toString());
    _heightController =
        TextEditingController(text: widget.client.height.toString());
    _weightController =
        TextEditingController(text: widget.client.weight.toString());
    _selectedGoal = widget.client.goal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Email is required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGoal,
                decoration: const InputDecoration(
                  labelText: 'Goal',
                  border: OutlineInputBorder(),
                ),
                items: ['WEIGHT_LOSS', 'MUSCLE_GAIN', 'MAINTENANCE']
                    .map((goal) => DropdownMenuItem(
                          value: goal,
                          child: Text(goal.replaceAll('_', ' ').toLowerCase()),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedGoal = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Age is required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      decoration: const InputDecoration(
                        labelText: 'Height (cm)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Height is required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Weight is required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 243, 33, 44),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final updatedClient = Client(
          id: widget.client.id,
          email: _emailController.text,
          goal: _selectedGoal,
          age: double.parse(_ageController.text),
          height: double.parse(_heightController.text),
          weight: double.parse(_weightController.text),
        );

        await ClientService().updateClient(widget.client.id, updatedClient);
        if (mounted) {
          Navigator.pop(context, true); // Return true to indicate success
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating profile: $e')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}
