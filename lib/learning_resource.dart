// lib/features/learning/domain/models/learning_resource.dart
class LearningResource {
  final String id;
  final String title;
  final String description;
  final String category;
  final String type; // 'article', 'video'
  final String url;
  final String duration; // e.g., "5 min read" or "10:00"

  const LearningResource({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.type,
    required this.url,
    required this.duration,
  });
}