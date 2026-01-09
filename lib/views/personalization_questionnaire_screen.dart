import 'package:flutter/material.dart';
import 'plan_generation_success_screen.dart';

class PersonalizationQuestionnaireScreen extends StatefulWidget {
  const PersonalizationQuestionnaireScreen({super.key});

  @override
  State<PersonalizationQuestionnaireScreen> createState() => _PersonalizationQuestionnaireScreenState();
}

class _PersonalizationQuestionnaireScreenState extends State<PersonalizationQuestionnaireScreen> {
  final List<String> _topics = ['Parables', 'Wisdom', 'Prophecy', 'Miracles', 'History', 'Gospels'];
  final Set<String> _selectedTopics = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 3: Personalize'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'What interests you?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 15,
              runSpacing: 15,
              alignment: WrapAlignment.center,
              children: _topics.map((topic) {
                final isSelected = _selectedTopics.contains(topic);
                return ChoiceChip(
                  label: Text(topic),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTopics.add(topic);
                      } else {
                        _selectedTopics.remove(topic);
                      }
                    });
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  selectedColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlanGenerationSuccessScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('Generate My Plan', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
