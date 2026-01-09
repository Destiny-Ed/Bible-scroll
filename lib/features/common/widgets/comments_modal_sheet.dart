import 'package:flutter/material.dart';

class CommentsModalSheet extends StatelessWidget {
  const CommentsModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Text(
            'Comments',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with actual comments
              itemBuilder: (context, index) {
                return const ListTile(
                  leading: CircleAvatar(
                    // backgroundImage: NetworkImage(comment.user.profileImageUrl),
                  ),
                  title: Text('username'), // Replace with actual username
                  subtitle: Text(
                    'This is a comment',
                  ), // Replace with actual comment
                );
              },
            ),
          ),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Add a comment...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
