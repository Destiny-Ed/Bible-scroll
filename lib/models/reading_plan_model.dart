
class ReadingPlan {
  final String id;
  final String title;
  final String description;
  final double progress;
  final bool isCompleted;

  ReadingPlan({
    required this.id,
    required this.title,
    required this.description,
    this.progress = 0.0,
    this.isCompleted = false,
  });
}
