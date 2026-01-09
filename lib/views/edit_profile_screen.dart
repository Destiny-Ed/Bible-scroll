import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildAvatar(context),
            const SizedBox(height: 32),
            _buildTextField(context, label: 'Full Name', initialValue: 'John Doe'),
            const SizedBox(height: 16),
            _buildTextField(context, label: 'Username', initialValue: 'john.doe'),
            const SizedBox(height: 16),
            _buildTextField(context, label: 'Bio', maxLines: 4, initialValue: 'Sharing light, one verse at a time. Follow for daily inspiration and stories of faith, hope, and love.'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?q=80&w=2080&auto=format&fit=crop'),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).primaryColor,
              child: IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.black, size: 20),
                onPressed: () {
                  // Handle image picking
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, {required String label, String? initialValue, int maxLines = 1}) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
