// lib/features/learning/presentation/learning_hub_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../domain/models/learning_resource.dart';

class LearningHubScreen extends StatelessWidget {
  const LearningHubScreen({super.key});

  final List<LearningResource> _resources = const [
    LearningResource(
      id: '1',
      title: 'Forex Trading for Beginners',
      description: 'A comprehensive guide to understanding the forex market.',
      category: 'Basics',
      type: 'article',
      url: 'https://www.investopedia.com/articles/forex/11/why-trade-forex.asp',
      duration: '10 min read',
    ),
    LearningResource(
      id: '2',
      title: 'Understanding Pips and Lots',
      description: 'Learn how to calculate pips and position sizes.',
      category: 'Basics',
      type: 'article',
      url: 'https://www.babypips.com/learn/forex/pips-and-pipettes',
      duration: '5 min read',
    ),
    LearningResource(
      id: '3',
      title: 'Introduction to Technical Analysis',
      description: 'Basics of reading charts and identifying trends.',
      category: 'Technical Analysis',
      type: 'video',
      url: 'https://www.youtube.com/watch?v=EyT3F8q8YqM', // Example URL
      duration: '15:00',
    ),
    LearningResource(
      id: '4',
      title: 'Risk Management Strategies',
      description: 'How to protect your capital while trading.',
      category: 'Risk Management',
      type: 'article',
      url: 'https://www.dailyfx.com/education/risk-management',
      duration: '8 min read',
    ),
  ];

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch URL')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Group by category
    final Map<String, List<LearningResource>> groupedResources = {};
    for (var resource in _resources) {
      if (!groupedResources.containsKey(resource.category)) {
        groupedResources[resource.category] = [];
      }
      groupedResources[resource.category]!.add(resource);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Hub'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groupedResources.length,
        itemBuilder: (context, index) {
          final category = groupedResources.keys.elementAt(index);
          final resources = groupedResources[category]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  category,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              ...resources.map((resource) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: resource.type == 'video'
                            ? Colors.red.withOpacity(0.1)
                            : Colors.blue.withOpacity(0.1),
                        child: Icon(
                          resource.type == 'video'
                              ? Icons.play_arrow
                              : Icons.article,
                          color: resource.type == 'video'
                              ? Colors.red
                              : Colors.blue,
                        ),
                      ),
                      title: Text(resource.title),
                      subtitle: Text(resource.description),
                      trailing: Text(
                        resource.duration,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () => _launchUrl(context, resource.url),
                    ),
                  )),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}