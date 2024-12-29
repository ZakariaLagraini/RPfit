import 'exercise.dart';

class WorkoutPlan {
  final int id;
  final String name;
  final int durationInWeeks;
  final List<Exercise> exercises;

  WorkoutPlan({
    required this.id,
    required this.name,
    required this.durationInWeeks,
    required this.exercises,
  });

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    var exercisesList = json['exercises'] as List? ?? [];
    return WorkoutPlan(
      id: json['id']?.toInt() ?? 0,
      name: json['name'] ?? '',
      durationInWeeks: json['durationInWeeks']?.toInt() ?? 0,
      exercises: exercisesList.map((e) => Exercise.fromJson(e)).toList(),
    );
  }
}
