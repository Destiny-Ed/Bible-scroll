import 'package:flutter/material.dart';

class CreateReadingPlanScreen extends StatelessWidget {
  const CreateReadingPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Reading Plan'),
      ),
      body: const Center(
        child: Text('This is where you create a reading plan.'),
      ),
    );
  }
}
