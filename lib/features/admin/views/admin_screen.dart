import 'package:flutter/material.dart';
import 'package:myapp/features/admin/views/manage_discover_screen.dart';
import 'package:myapp/features/admin/views/manage_video_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.video_library),
            title: const Text('Manage Videos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManageVideoScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.explore),
            title: const Text('Manage Discover Content'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManageDiscoverScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
