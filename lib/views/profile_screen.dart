import 'package:flutter/material.dart';
import 'package:myapp/views/daily_reading_plan_screen.dart';
import 'package:myapp/views/edit_profile_screen.dart';
import 'package:myapp/views/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 32),
            _buildProfileOption(context, Icons.edit, 'Edit Profile', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
            }),
            _buildProfileOption(context, Icons.book, 'My Reading Plan', () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const DailyReadingPlanScreen()));
            }),
            _buildProfileOption(context, Icons.bookmark, 'My Library', () {
              // TODO: Navigate to library screen
            }),
            _buildProfileOption(context, Icons.share, 'Share Profile', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage('https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?q=80&w=2080&auto=format&fit=crop'),
        ),
        const SizedBox(height: 16),
        Text(
          'John Doe',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          '@john.doe',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  Widget _buildProfileOption(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}
