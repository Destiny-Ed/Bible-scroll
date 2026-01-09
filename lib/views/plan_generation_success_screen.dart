import 'package:flutter/material.dart';
import 'home_screen.dart';

class PlanGenerationSuccessScreen extends StatelessWidget {
  const PlanGenerationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 4: Success!'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 100),
            const SizedBox(height: 30),
            const Text(
              'Your Plan is Ready!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Based on your selections, we\'ve created a personalized reading plan for you.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildPlanSummary(context),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('Start My Journey', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanSummary(BuildContext context) {
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"Faith & Wisdom Journey"',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Daily Time:', style: TextStyle(fontWeight: FontWeight.w600)),
              Text('15 minutes', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Duration:', style: TextStyle(fontWeight: FontWeight.w600)),
              Text('30 days', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 10),
          Text('Topics:', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 5),
          Text('Parables, Wisdom'),
        ],
      ),
    );
  }
}
