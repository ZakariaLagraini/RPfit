class Exercise {
  final int id;
  final String name;
  final int sets;
  final int reps;
  final double weight;
  final int restTime;
  final int? workoutPlanId;

  Exercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.restTime,
    this.workoutPlanId,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id']?.toInt() ?? 0,
      name: json['name'] ?? '',
      sets: json['sets']?.toInt() ?? 0,
      reps: json['reps']?.toInt() ?? 0,
      weight: (json['weight'] ?? 0.0).toDouble(),
      restTime: json['restTime']?.toInt() ?? 0,
      workoutPlanId: json['workoutPlan']?['id']?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'restTime': restTime,
      if (workoutPlanId != null) 'workoutPlan': {'id': workoutPlanId},
    };
  }
}
