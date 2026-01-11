import 'package:flutter/material.dart';
import 'package:myapp/features/admin/viewmodels/admin_viewmodel.dart';
import 'package:provider/provider.dart';

class CommentModerationTab extends StatelessWidget {
  const CommentModerationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.comments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.comment_bank_rounded, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('No comments to moderate yet'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: vm.comments.length,
          itemBuilder: (context, index) {
            final comment = vm.comments[index];
            // final isPending = !comment.approved;
            final isPending = false;

            return Card(
              elevation: 1,
              color: isPending ? Colors.red.shade50 : null,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: comment.avatarUrl.isNotEmpty
                      ? NetworkImage(comment.avatarUrl)
                      : null,
                  child: comment.avatarUrl.isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(
                  comment.comment,
                  style: TextStyle(
                    decoration: isPending ? TextDecoration.lineThrough : null,
                    color: isPending ? Colors.red : null,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'By ${comment.commenterName} • ${comment.timeStamp.toString().substring(0, 16)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    // if (comment.reported)
                    //   Text(
                    //     '⚠️ Reported',
                    //     style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                    //   ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isPending)
                      IconButton(
                        icon: const Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                        ),
                        tooltip: 'Approve',
                        onPressed: () => vm.moderateComment(
                          "comment.videoId",
                          comment.id,
                          true,
                        ),
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      tooltip: 'Delete',
                      onPressed: () {
                        // vm.deleteComment(comment.videoId, comment.id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
