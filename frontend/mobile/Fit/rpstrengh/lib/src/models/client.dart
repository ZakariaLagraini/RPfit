class Client {
  final int id;
  final String goal;
  final String email;
  final String? password;
  final double age;
  final double height;
  final double weight;

  Client({
    required this.id,
    required this.goal,
    required this.email,
    this.password,
    required this.age,
    required this.height,
    required this.weight,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      goal: json['goal'],
      email: json['email'],
      age: json['age'].toDouble(),
      height: json['height'].toDouble(),
      weight: json['weight'].toDouble(),
    );
  }
}