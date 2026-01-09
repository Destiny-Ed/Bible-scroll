import 'package:flutter/material.dart';
import 'plan_commitment_screen.dart';

class GoalSelectionScreen extends StatelessWidget {
  const GoalSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 1: Choose Your Goal'),
        automaticallyImplyLeading: false, // No back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'What is your primary spiritual goal?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Select an area you would like to focus on to help us personalize your daily reading goal',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _buildGoalCard(context, 'Deepen My Faith', 'Strengthen your spiritual foundation and connection.', Icons.lightbulb_outline),
            const SizedBox(height: 20),
            _buildGoalCard(context, 'Find Peace & Comfort', 'Focus on verses that offer hope and tranquility.', Icons.self_improvement),
            const SizedBox(height: 20),
            _buildGoalCard(context, 'Understand the Bible Better', 'Ideal for those starting their journey with the word.', Icons.menu_book),
            const SizedBox(height: 20),
            _buildGoalCard(context, 'Wisdom, Guidance & Protection', 'Seek knowledge and divine protection in your daily life.', Icons.shield_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, String title, String subtitle, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          // Navigate to the next step
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PlanCommitmentScreen()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
