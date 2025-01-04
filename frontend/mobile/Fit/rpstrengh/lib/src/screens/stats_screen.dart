import 'package:flutter/material.dart';
import 'package:rpstrengh/src/services/progress_service.dart';
import 'package:rpstrengh/src/models/progress.dart';
import 'package:intl/intl.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ProgressService _progressService = ProgressService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress',
            style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'History'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: FutureBuilder<List<Progress>>(
        future: _progressService.getClientProgress(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final progress = snapshot.data!;
          return TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(progress),
              _buildHistoryTab(progress),
              _buildAnalyticsTab(progress),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab(List<Progress> progress) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(progress),
          const SizedBox(height: 24),
          _buildRecentActivities(progress),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(List<Progress> progress) {
    final totalWorkouts = progress.length;
    final totalWeight = progress.fold<double>(
        0, (sum, item) => sum + (item.weight * item.repetitions * item.sets));
    final avgReps =
        progress.fold<int>(0, (sum, item) => sum + item.repetitions) ~/
            totalWorkouts;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
            'Total Workouts', totalWorkouts.toString(), Icons.fitness_center),
        _buildStatCard('Total Weight', '${totalWeight.toStringAsFixed(1)} kg',
            Icons.monitor_weight),
        _buildStatCard('Avg. Reps', avgReps.toString(), Icons.repeat),
        _buildStatCard(
            'Active Days', '${progress.length} days', Icons.calendar_today),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities(List<Progress> progress) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Activities',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => _tabController.animateTo(1),
                  child: const Text('See All'),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: progress.take(5).length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = progress[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Icon(Icons.fitness_center,
                      color: Theme.of(context).primaryColor),
                ),
                title: Text(item.exercise.name),
                subtitle: Text(
                  '${item.sets} sets × ${item.repetitions} reps @ ${item.weight}kg',
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('MMM d').format(item.date),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      DateFormat('HH:mm').format(item.date),
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(List<Progress> progress) {
    // Implement history tab with filterable list view
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: progress.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final item = progress[index];
        return _buildHistoryItem(item);
      },
    );
  }

  Widget _buildHistoryItem(Progress progress) {
    return Card(
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child:
              Icon(Icons.fitness_center, color: Theme.of(context).primaryColor),
        ),
        title: Text(progress.exercise.name),
        subtitle: Text(DateFormat('MMM d, yyyy').format(progress.date)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Sets', progress.sets.toString()),
                _buildDetailRow('Reps', progress.repetitions.toString()),
                _buildDetailRow('Weight', '${progress.weight} kg'),
                if (progress.duration > 0)
                  _buildDetailRow('Duration', '${progress.duration} min'),
                if (progress.notes.isNotEmpty)
                  _buildDetailRow('Notes', progress.notes),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab(List<Progress> progress) {
    // Implement analytics tab with more detailed charts
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Analytics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text('Analytics coming soon'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
