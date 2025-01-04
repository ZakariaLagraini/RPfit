import 'package:flutter/material.dart';
import 'package:rpstrengh/src/screens/add_exercise_screen.dart';
import 'package:rpstrengh/src/screens/exercise_detail_screen.dart';
import 'package:rpstrengh/src/services/exercise_service.dart';
import 'package:rpstrengh/src/models/exercise.dart';
import 'package:rpstrengh/src/services/progress_service.dart';
import 'package:rpstrengh/src/models/progress.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>
    with AutomaticKeepAliveClientMixin {
  final ExerciseService _exerciseService = ExerciseService();
  List<Exercise> _exercises = [];
  List<Exercise> _filteredExercises = [];
  bool _isLoading = false;
  bool _hasLoadedData = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoadedData) {
      _loadExercises();
      _hasLoadedData = true;
    }
  }

  Future<void> _loadExercises() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final exercises = await _exerciseService.getAllExercises();
      setState(() {
        _exercises = exercises;
        _filteredExercises = exercises; // Initialize filtered list
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load exercises: ${e.toString()}')),
        );
      }
    }
  }

  void _filterExercises(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredExercises = _exercises; // Reset to all exercises
      });
    } else {
      setState(() {
        _filteredExercises = _exercises
            .where((exercise) =>
                exercise.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search exercises',
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: _filterExercises, // Call filter on text change
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.help_outline),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.star_border),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // All Exercises Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.menu, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'All Exercises',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddExerciseScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      '+Add Custom Exercise',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),

            // Exercise List
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadExercises,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredExercises.isEmpty
                        ? const Center(child: Text('No exercises found'))
                        : ListView.builder(
                            itemCount: _filteredExercises.length,
                            itemBuilder: (context, index) {
                              final exercise = _filteredExercises[index];
                              return _buildExerciseItem(
                                exercise.name,
                                'Target Muscle',
                                'assets/images/rp_logo.png',
                                4,
                                context,
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseItem(String title, String targetMuscle, String imagePath,
      int difficulty, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Show dialog to input exercise details
        final result = await showDialog<Map<String, dynamic>>(
          context: context,
          builder: (BuildContext context) {
            int sets = 1;
            int reps = 1;
            double weight = 0.0;
            String notes = '';

            return AlertDialog(
              title: Text('Record $title'),
              content: SingleChildScrollView(
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Sets input
                        Row(
                          children: [
                            const Text('Sets: '),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (sets > 1) {
                                  setState(() => sets--);
                                }
                              },
                            ),
                            Text('$sets'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => setState(() => sets++),
                            ),
                          ],
                        ),
                        // Reps input
                        Row(
                          children: [
                            const Text('Reps: '),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (reps > 1) {
                                  setState(() => reps--);
                                }
                              },
                            ),
                            Text('$reps'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => setState(() => reps++),
                            ),
                          ],
                        ),
                        // Weight input
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Weight (kg)',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            weight = double.tryParse(value) ?? 0.0;
                          },
                        ),
                        // Notes input
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Notes (optional)',
                          ),
                          maxLines: 2,
                          onChanged: (value) {
                            notes = value;
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'sets': sets,
                      'reps': reps,
                      'weight': weight,
                      'notes': notes,
                    });
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );

        // If user confirmed, create progress
        if (result != null) {
          try {
            final progressService = ProgressService();
            final exercise = Exercise(
              id: 1, // You need to get the actual exercise ID
              name: title,
              sets: result['sets'],
              reps: result['reps'],
              weight: result['weight'],
              restTime: 60,
            );

            final progress = Progress(
              id: 0, // ID will be assigned by the backend
              exercise: exercise,
              date: DateTime.now(),
              repetitions: int.parse(result['reps'].toString()),
              weight: double.parse(result['weight'].toString()),
              sets: int.parse(result['sets'].toString()),
              notes: result['notes'] ?? '',
              // The client will be set on the backend using the JWT token
            );

            await progressService.createProgress(progress);

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Exercise recorded successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to record exercise: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }

        // Navigate to exercise detail screen
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseDetailScreen(
                title: title,
                imagePath: imagePath,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Row(
          children: [
            // Exercise Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // Exercise Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    targetMuscle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: Icon(
                            Icons.circle,
                            size: 8,
                            color: index < difficulty
                                ? Colors.red
                                : Colors.grey[300],
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
            // Action Buttons
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.lightbulb_outline, color: Colors.red),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.menu, color: Colors.grey[600]),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.star_border, color: Colors.grey[600]),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
