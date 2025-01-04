import 'package:flutter/material.dart';
import '../models/nutrition.dart';
import '../models/client.dart';
import '../services/nutrition_service.dart';
import '../services/client_service.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final _nutritionService = NutritionService();
  final _clientService = ClientService();
  List<Nutrition>? nutritions;
  bool isLoading = true;
  int? clientId;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      // First get the client profile to get the ID
      final Client profile = await _clientService.getProfile();
      setState(() {
        clientId = profile.id;
      });
      // Then fetch nutrition data
      await fetchNutrition();
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to load profile data'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    }
  }

  Future<void> fetchNutrition() async {
    if (clientId == null) return;

    try {
      setState(() => isLoading = true);
      final nutritionData = await _nutritionService.getNutrition(clientId!);
      setState(() {
        nutritions = nutritionData;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching nutrition: $e');
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to load nutrition data'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final nutrition = nutritions?.isNotEmpty == true ? nutritions!.first : null;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Nutrition Plan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchNutrition,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchNutrition,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (nutrition != null) ...[
                      const Text(
                        'Daily Nutrition Goals',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildNutritionGrid(),
                      const SizedBox(height: 24),
                      _buildMacroBreakdown(),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildNutritionGrid() {
    final nutrition = nutritions?.isNotEmpty == true ? nutritions!.first : null;
    if (nutrition == null) return const SizedBox.shrink();

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildNutritionCard(
          'Calories',
          '${nutrition.calories.toStringAsFixed(0)}',
          'kcal',
          Colors.orange,
          Icons.local_fire_department,
        ),
        _buildNutritionCard(
          'Protein',
          '${nutrition.proteins.toStringAsFixed(0)}',
          'g',
          Colors.red,
          Icons.fitness_center,
        ),
        _buildNutritionCard(
          'Carbs',
          '${nutrition.carbs.toStringAsFixed(0)}',
          'g',
          Colors.green,
          Icons.grain,
        ),
        _buildNutritionCard(
          'Fat',
          '${nutrition.fats.toStringAsFixed(0)}',
          'g',
          Colors.blue,
          Icons.water_drop,
        ),
      ],
    );
  }

  Widget _buildNutritionCard(
    String title,
    String value,
    String unit,
    Color color,
    IconData icon,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(icon, color: color),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 14,
                    color: color.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroBreakdown() {
    final nutrition = nutritions?.isNotEmpty == true ? nutritions!.first : null;
    if (nutrition == null) return const SizedBox.shrink();

    final total = nutrition.proteins + nutrition.carbs + nutrition.fats;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Macro Breakdown',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildMacroProgressBar(
                  'Protein',
                  nutrition.proteins,
                  total,
                  Colors.red,
                ),
                const SizedBox(height: 12),
                _buildMacroProgressBar(
                  'Carbs',
                  nutrition.carbs,
                  total,
                  Colors.green,
                ),
                const SizedBox(height: 12),
                _buildMacroProgressBar(
                  'Fat',
                  nutrition.fats,
                  total,
                  Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMacroProgressBar(
    String label,
    double value,
    double total,
    Color color,
  ) {
    final percentage = (value / total * 100).roundToDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${value.toStringAsFixed(0)}g (${percentage.toStringAsFixed(0)}%)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / total,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
