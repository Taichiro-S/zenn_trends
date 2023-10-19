import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/topics_provider.dart';
import '/view/widget/topic_container_p.dart';
import '/provider/search_provider.dart';

class Ranking extends ConsumerWidget {
  const Ranking({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicAsync = ref.watch(topicsProvider);
    return topicAsync.when(
      error: (e, s) => Text(e.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (topics) {
        return ListView.builder(
          itemCount: topics.length,
          itemBuilder: (context, index) {
            final topic = topics[index];
            return TopicContainer(topic: topic);
          },
        );
      },
    );
  }
}
