import 'package:flutter/material.dart';
import 'package:myapp/features/onboarding/views/personalization_questionnaire_screen.dart';

class PlanCommitmentScreen extends StatefulWidget {
  const PlanCommitmentScreen({super.key});

  @override
  State<PlanCommitmentScreen> createState() => _PlanCommitmentScreenState();
}

class _PlanCommitmentScreenState extends State<PlanCommitmentScreen> {
  double _dailyTime = 15;
  int _duration = 30;

  String get _commitmentInfo {
    String timeInfo;
    if (_dailyTime <= 15) {
      timeInfo = 'Light reading';
    } else if (_dailyTime <= 30) {
      timeInfo = 'Moderate pace';
    } else {
      timeInfo = 'Deep dive';
    }

    int totalDays = _duration;
    return '$timeInfo. At this pace, you can develop a consistent habit in about $totalDays days.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 2: Commitment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Set Your Commitment',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Customize your spiritual journey to fit your daily schedule and long term goals',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildTimeSlider(),
            const SizedBox(height: 40),
            _buildDurationChips(),
            const SizedBox(height: 20),
            Text(
              _commitmentInfo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PersonalizationQuestionnaireScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('Continue', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlider() {
    return Column(
      children: [
        const Text('How much time per day?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Text('${_dailyTime.round()} minutes', style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary)),
        Slider(
          value: _dailyTime,
          min: 5,
          max: 60,
          divisions: 11,
          label: '${_dailyTime.round()} min',
          onChanged: (value) {
            setState(() {
              _dailyTime = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDurationChips() {
    return Column(
      children: [
        const Text('Plan duration?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 20),
        Wrap(
          spacing: 15,
          runSpacing: 15,
          alignment: WrapAlignment.center,
          children: [7, 30, 90, 180, 365].map((days) {
            return ChoiceChip(
              label: Text(days == 365 ? '1 year' : '$days days'),
              selected: _duration == days,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _duration = days;
                  });
                }
              },
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              labelStyle: TextStyle(
                color: _duration == days ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
              selectedColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            );
          }).toList(),
        ),
      ],
    );
  }
}
