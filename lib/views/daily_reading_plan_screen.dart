import 'package:flutter/material.dart';

class DailyReadingPlanScreen extends StatelessWidget {
  const DailyReadingPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Plan', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildProgressSummary(context),
              const SizedBox(height: 30),
              _buildDailyReadings(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Your Progress',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn('5', 'Days Streak'),
              _buildStatColumn('12', 'Chapters Read'),
              _buildStatColumn('60', 'Mins Read'),
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: 0.4,
            backgroundColor: Theme.of(context).colorScheme.background,
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          const Text('40% of the plan completed'),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildDailyReadings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Reading',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildReadingItem(context, 'Genesis 1-2', 'The Creation Story', true),
        _buildReadingItem(context, 'John 1', 'The Word Became Flesh', false),
        _buildReadingItem(context, 'Psalms 1', 'The Two Ways', false),
        const SizedBox(height: 80), // Space for floating action button
      ],
    );
  }

  Widget _buildReadingItem(BuildContext context, String title, String subtitle, bool isCompleted) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isCompleted ? Theme.of(context).colorScheme.primary : Colors.grey,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}
