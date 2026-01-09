import 'package:flutter/material.dart';

class DailyReadingPlanScreen extends StatelessWidget {
  const DailyReadingPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F0),
      appBar: AppBar(
        title: const Text('My Journey', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildPlanOverview(context),
              const SizedBox(height: 30),
              _buildTodaysReading(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanOverview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '30-DAY JOURNEY',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFDB813)),
          ),
          const SizedBox(height: 8),
          const Text(
            '30 Days of Peace: A Visual Journey',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatColumn('5', 'Days Streak'),
              _buildStatColumn('12', 'Chapters Read'),
              _buildStatColumn('40%', 'Completed'),
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: 0.4,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFDB813)),
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTodaysReading(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Reading',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 16),
        _buildReadingItem(context, 'Genesis 1-2', 'The Creation Story', true),
        _buildReadingItem(context, 'John 1', 'The Word Became Flesh', false),
        _buildReadingItem(context, 'Psalms 1', 'The Two Ways', false),
      ],
    );
  }

  Widget _buildReadingItem(BuildContext context, String title, String subtitle, bool isCompleted) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      color: isCompleted ? const Color(0xFFF0F8FF) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        leading: Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isCompleted ? const Color(0xFFFDB813) : Colors.grey.shade400,
          size: 28,
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: () {
          // Navigate to chapter detail
        },
      ),
    );
  }
}
