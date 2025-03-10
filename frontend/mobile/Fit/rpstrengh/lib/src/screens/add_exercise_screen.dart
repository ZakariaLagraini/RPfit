import 'package:flutter/material.dart';
import 'package:rpstrengh/src/services/exercise_service.dart';
import 'package:rpstrengh/src/models/exercise.dart';

class AddExerciseScreen extends StatefulWidget {
  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final ExerciseService _exerciseService = ExerciseService();
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _sets = 0;
  int _reps = 0;
  double _weight = 0.0;
  int _restTime = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Custom Exercise')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Exercise Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter exercise name';
                  }
                  return null;
                },
                onChanged: (value) {
                  _name = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Sets'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of sets';
                  }
                  return null;
                },
                onChanged: (value) {
                  _sets = int.tryParse(value) ?? 0;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of reps';
                  }
                  return null;
                },
                onChanged: (value) {
                  _reps = int.tryParse(value) ?? 0;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter weight';
                  }
                  return null;
                },
                onChanged: (value) {
                  _weight = double.tryParse(value) ?? 0.0;
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Rest Time (seconds)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter rest time';
                  }
                  return null;
                },
                onChanged: (value) {
                  _restTime = int.tryParse(value) ?? 0;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Exercise newExercise = Exercise(
                      id: 0, // ID will be generated by the backend
                      name: _name,
                      sets: _sets,
                      reps: _reps,
                      weight: _weight,
                      restTime: _restTime,
                      workoutPlanId: null, // Optional
                    );
                    try {
                      await _exerciseService.createExercise(newExercise);
                      Navigator.pop(context);
                    } catch (e) {
                      // Handle error (e.g., show a Snackbar)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Failed to add exercise: ${e.toString()}')),
                      );
                    }
                  }
                },
                child: const Text('Add Exercise'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
