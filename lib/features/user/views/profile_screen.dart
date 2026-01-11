import 'package:flutter/material.dart';
import 'package:myapp/features/admin/views/admin_screen.dart';
import 'package:myapp/features/library/views/library_screen.dart';
import 'package:myapp/features/plan/views/daily_reading_plan_screen.dart';
import 'package:myapp/features/user/views/edit_profile_screen.dart';
import 'package:myapp/features/user/views/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Not logged in'));
    }

    // Fetch user profile
    final profileViewModel = Provider.of<ProfileViewModel>(
      context,
      listen: false,
    );
    profileViewModel.getUserProfile(user.uid);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => profileViewModel.incrementEsterCount(),
          child: const Text('My Profile'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: [
              _buildProfileHeader(context, viewModel),
              const SizedBox(height: 20),
              _buildProfileOptions(context, viewModel: viewModel),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?q=80&w=2080&auto=format&fit=crop',
            ), // Placeholder
          ),
          const SizedBox(height: 10),
          Text(
            viewModel.user!.name ?? 'No Name',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            "@${viewModel.user?.userName ?? (viewModel.user!.email ?? 'No Email')}",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditProfileScreen(user: viewModel.user!),
                ),
              );
            },
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions(
    BuildContext context, {
    required ProfileViewModel viewModel,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildProfileOption(
            context,
            Icons.calendar_today,
            'My Reading Plan',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DailyReadingPlanScreen(),
                ),
              );
            },
          ),
          _buildProfileOption(context, Icons.bookmark, 'My Library', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LibraryScreen()),
            );
          }),
          if (viewModel.showAdmin)
            _buildProfileOption(context, Icons.bookmark, 'Admin', () {
              Navigator.push(
                context,

                MaterialPageRoute(builder: (context) => const AdminScreen()),
              );
            }),

          _buildProfileOption(context, Icons.share, 'Share Profile', () {}),
        ],
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
