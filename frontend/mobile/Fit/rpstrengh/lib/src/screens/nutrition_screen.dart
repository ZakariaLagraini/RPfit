import 'package:flutter/material.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plans'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMealCard(
            'Beef & Pumpkin',
            'Beef stew with a blend of vegetables and ginger garlic',
            '22g',
            '45g',
            '35g',
            'assets/images/beef_pumpkin.png',
          ),
          _buildMealCard(
            'Greens Salad',
            'Fresh mixed greens with vinaigrette dressing',
            '18g',
            '20g',
            '27g',
            'assets/images/greens_salad.png',
          ),
          _buildMealCard(
            'Salmon and Greens',
            'Grilled salmon with fresh vegetables',
            '30g',
            '25g',
            '18g',
            'assets/images/salmon_greens.png',
          ),
          _buildMealCard(
            'Avocado on Toast',
            'Smashed avocado on whole grain toast',
            '15g',
            '24g',
            '22g',
            'assets/images/avocado_toast.png',
          ),
          _buildMealCard(
            'Penne Pesto Pasta',
            'Pasta with homemade pesto sauce',
            '16g',
            '29g',
            '45g',
            'assets/images/penne_pesto.png',
          ),
          _buildMealCard(
            'Pad Thai Noodle',
            'Traditional pad thai with rice noodles',
            '45g',
            '35g',
            '36g',
            'assets/images/pad_thai.png',
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(String title, String description, String protein, 
      String carbs, String fat, String imagePath) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.restaurant, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
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
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildNutritionInfo('Protein', protein),
                      const SizedBox(width: 12),
                      _buildNutritionInfo('Carbs', carbs),
                      const SizedBox(width: 12),
                      _buildNutritionInfo('Fat', fat),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
} 