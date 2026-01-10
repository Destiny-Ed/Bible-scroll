import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  await authViewModel.signInWithGoogle();
                } catch (e) {
                  // Handle error
                }
              },
              child: const Text('Sign in with Google'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await authViewModel.signInWithApple();
                } catch (e) {
                  // Handle error
                }
              },
              child: const Text('Sign in with Apple'),
            ),
          ],
        ),
      ),
    );
  }
}
