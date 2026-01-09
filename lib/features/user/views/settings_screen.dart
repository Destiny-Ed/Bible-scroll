import 'package:flutter/material.dart';
import 'package:myapp/features/common/viewmodels/theme_view_model.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader(context, 'General'),
          _buildSettingsCard([_buildThemeToggle(context, themeProvider)]),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'About'),
          _buildSettingsCard([
            _buildSettingsTile(context, 'Privacy Policy', Icons.lock_outline),
            _buildSettingsTile(
              context,
              'Terms of Service',
              Icons.description_outlined,
            ),
            _buildSettingsTile(
              context,
              'App Version',
              Icons.info_outline,
              trailing: '1.0.0',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Card(child: Column(children: children));
  }

  Widget _buildThemeToggle(BuildContext context, ThemeProvider themeProvider) {
    return ListTile(
      title: const Text('Dark Mode'),
      leading: const Icon(Icons.dark_mode_outlined),
      trailing: Switch(
        value: themeProvider.themeMode == ThemeMode.dark,
        onChanged: (value) {
          themeProvider.toggleTheme();
        },
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    IconData icon, {
    String? trailing,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing != null
          ? Text(trailing, style: Theme.of(context).textTheme.labelSmall)
          : const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: () {
        // Handle navigation or action
      },
    );
  }
}
