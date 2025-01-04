import 'package:rpstrengh/src/models/exercise.dart';
import 'package:rpstrengh/src/models/client.dart';

class Progress {
  final int id;
  final Client? client;
  final Exercise exercise;
  final DateTime date;
  final int repetitions;
  final double weight;
  final int sets;
  final double duration;
  final String notes;

  Progress({
    required this.id,
    this.client,
    required this.exercise,
    required this.date,
    required this.repetitions,
    required this.weight,
    required this.sets,
    this.duration = 0.0,
    this.notes = '',
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      id: json['id'],
      client: json['client'] != null ? Client.fromJson(json['client']) : null,
      exercise: Exercise.fromJson(json['exercise']),
      date: DateTime.parse(json['date']),
      repetitions: json['repetitions'],
      weight: json['weight'].toDouble(),
      sets: json['sets'],
      duration: json['duration']?.toDouble() ?? 0.0,
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exercise': {
        'id': exercise.id,
      },
      'date': date.toIso8601String(),
      'repetitions': repetitions,
      'weight': weight,
      'sets': sets,
      'duration': duration,
      'notes': notes,
    };
  }
}
