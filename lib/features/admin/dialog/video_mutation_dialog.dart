import 'package:flutter/material.dart';
import 'package:myapp/features/admin/viewmodels/admin_viewmodel.dart';
import 'package:myapp/features/discover/models/video_model.dart';

void showVideoFormDialog(
  BuildContext context, {
  Video? existingVideo,
  required AdminViewModel viewModel,
}) {
  final isEdit = existingVideo != null;
  final formKey = GlobalKey<FormState>();

  final chapterTitleCtrl = TextEditingController(
    text: existingVideo?.chapterTitle ?? '',
  );
  final chapterCtrl = TextEditingController(text: existingVideo?.chapter ?? '');
  final descCtrl = TextEditingController(
    text: existingVideo?.description ?? '',
  );
  final videoUrlCtrl = TextEditingController(
    text: existingVideo?.videoUrl ?? '',
  );
  final thumbUrlCtrl = TextEditingController(
    text: existingVideo?.thumbnailUrl ?? '',
  );
  final topicCtrl = TextEditingController(text: existingVideo?.topic ?? '');

  showDialog(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      isEdit
                          ? Icons.edit_rounded
                          : Icons.add_circle_outline_rounded,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      isEdit ? 'Edit Video' : 'Add New Video',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Form Fields
                _buildTextField(
                  controller: chapterTitleCtrl,
                  label: 'Chapter Title',
                  icon: Icons.title_rounded,
                  validator: (v) =>
                      v?.trim().isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: chapterCtrl,
                  label: 'Chapter (e.g. Genesis 1)',
                  icon: Icons.book_rounded,
                  validator: (v) =>
                      v?.trim().isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: descCtrl,
                  label: 'Description',
                  icon: Icons.description_rounded,
                  maxLines: 3,
                  validator: (v) =>
                      v?.trim().isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: videoUrlCtrl,
                  label: 'Video URL',
                  icon: Icons.link_rounded,
                  validator: (v) {
                    if (v?.trim().isEmpty ?? true) return 'Required';
                    if (!v!.startsWith('http')) return 'Must be valid URL';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: thumbUrlCtrl,
                  label: 'Thumbnail URL (optional)',
                  icon: Icons.image_rounded,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: topicCtrl,
                  label: 'Topic / Category',
                  icon: Icons.category_rounded,
                  validator: (v) =>
                      v?.trim().isEmpty ?? true ? 'Required' : null,
                ),

                const SizedBox(height: 32),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;

                        final newVideo = Video(
                          id: existingVideo?.id ?? '',
                          chapterTitle: chapterTitleCtrl.text.trim(),
                          chapter: chapterCtrl.text.trim(),
                          description: descCtrl.text.trim(),
                          videoUrl: videoUrlCtrl.text.trim(),
                          thumbnailUrl: thumbUrlCtrl.text.trim(),
                          uploader: existingVideo?.uploader ?? 'Admin',
                          avatarUrl: existingVideo?.avatarUrl ?? '',
                          topic: topicCtrl.text.trim(),
                          likesCount: existingVideo?.likesCount ?? 0,
                          bookmarksCount: existingVideo?.bookmarksCount ?? 0,
                          commentsCount: existingVideo?.commentsCount ?? 0,
                          viewsCount: existingVideo?.viewsCount ?? 0,
                        );

                        if (isEdit) {
                          await viewModel.updateVideo(newVideo);
                        } else {
                          await viewModel.addVideo(newVideo);
                        }

                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isEdit
                                    ? 'Video updated!'
                                    : 'Video added successfully!',
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.save_rounded),
                      label: Text(isEdit ? 'Update' : 'Add Video'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  IconData? icon,
  int maxLines = 1,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey.shade50,
    ),
    validator: validator,
  );
}
