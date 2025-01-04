class Nutrition {
  final int id;
  final double calories;
  final double proteins;
  final double carbs;
  final double fats;
  final int clientId;

  Nutrition({
    required this.id,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
    required this.clientId,
  });

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      id: json['id'] ?? 0,
      calories: json['calories']?.toDouble() ?? 0.0,
      proteins: json['proteins']?.toDouble() ?? 0.0,
      carbs: json['carbs']?.toDouble() ?? 0.0,
      fats: json['fats']?.toDouble() ?? 0.0,
      clientId: json['client']['id'],
    );
  }
}
