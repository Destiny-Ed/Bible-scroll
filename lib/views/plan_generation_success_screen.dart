import 'package:flutter/material.dart';
import 'home_screen.dart';

class PlanGenerationSuccessScreen extends StatelessWidget {
  const PlanGenerationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Success',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildSuccessHeader(context),
              const SizedBox(height: 32),
              Text(
                'Your Custom Plan is Ready!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Based on your spiritual goals and daily habits, we\'ve crafted a journey just for you.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              _buildPlanCard(context),
              const SizedBox(height: 32),

              _buildStartButton(context),
              const SizedBox(height: 16),
              const Text(
                'You can adjust your goals anytime in settings.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessHeader(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 30,
              height: 4,
              decoration: BoxDecoration(
                color: index == 3
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary.withAlpha(26),
          ),
          child: Icon(Icons.campaign, color: Theme.of(context).colorScheme.primary, size: 48),
        ),
      ],
    );
  }

  Widget _buildPlanCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: Image.network(
                  'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?q=80&w=2070&auto=format&fit=crop', // Placeholder image
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withAlpha(230),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'RECOMMENDED',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '30-DAY JOURNEY',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '30 Days of Peace: A Visual Journey',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                _buildBenefitRow(context, Icons.check_circle, '30 Hand-picked verses'),
                const SizedBox(height: 12),
                _buildBenefitRow(
                  context,
                  Icons.check_circle,
                  'Daily meditative visuals',
                ),
                const SizedBox(height: 12),
                _buildBenefitRow(
                  context,
                  Icons.check_circle,
                  'Personal reflection prompts',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
        const SizedBox(width: 12),
        Text(text, style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Start My Journey',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.onPrimary),
        ],
      ),
    );
  }
}
