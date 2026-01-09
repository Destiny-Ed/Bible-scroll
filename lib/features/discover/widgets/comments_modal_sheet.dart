import 'package:flutter/material.dart';

class CommentsModalSheet extends StatelessWidget {
  const CommentsModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text('Comments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: NetworkImage('https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?q=80&w=2080&auto=format&fit=crop'),
                  ),
                  title: const Text('John Doe'),
                  subtitle: const Text('This is a comment'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
