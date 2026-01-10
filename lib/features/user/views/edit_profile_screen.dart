import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../viewmodels/profile_viewmodel.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;
  late String _userName;
  late String _bio;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name ?? '';
    _email = widget.user.email ?? '';
    _userName = widget.user.userName ?? (widget.user.name ?? "");
    _bio = widget.user.bio ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildAvatar(context),
                const SizedBox(height: 32),

                _buildTextField(
                  context,
                  label: 'Full Name',
                  initialValue: _name,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a name' : null,
                  onSaved: (value) => _name = value!,
                ),

                const SizedBox(height: 16),
                _buildTextField(
                  context,
                  label: 'Username',
                  initialValue: _userName,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a valid username' : null,
                  onSaved: (value) => _userName = value!,
                ),

                const SizedBox(height: 16),

                _buildTextField(context, label: 'Email', initialValue: _email),

                const SizedBox(height: 16),
                _buildTextField(
                  context,
                  label: 'Bio',
                  maxLines: 4,
                  // initialValue:
                  //     'Sharing light, one verse at a time. Follow for daily inspiration and stories of faith, hope, and love.',
                  initialValue: _bio,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a valid bio' : null,
                  onSaved: (value) => _bio = value!,
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final updatedUser = UserModel(
                        userName: _userName,
                        bio: _bio,
                        name: _name,
                        email: _email,
                        // fcmToken and platform are not edited here, so we keep the old values
                        fcmToken: widget.user.fcmToken,
                        platform: widget.user.platform,
                      );
                      profileViewModel
                          .updateUserProfile(widget.user.id!, updatedUser)
                          .then((_) {
                            Navigator.pop(context);
                          });
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
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
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?q=80&w=2080&auto=format&fit=crop',
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).primaryColor,
              child: IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                  size: 20,
                ),
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

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    String? initialValue,
    int maxLines = 1,
    Function(String?)? onSaved,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      initialValue: initialValue,
      validator: validator,
      maxLines: maxLines,
      onSaved: onSaved,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(12),
        // ),
      ),
    );
  }
}
