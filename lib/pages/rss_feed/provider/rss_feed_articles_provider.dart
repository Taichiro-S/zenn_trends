import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zenn_trends/pages/rss_feed/model/rss_feed_articles_state.dart';
import 'package:zenn_trends/pages/rss_feed/repository/rss_feed_articles_repository.dart';
import 'package:zenn_trends/pages/rss_feed/service/should_fetch_data.dart';

part 'rss_feed_articles_provider.g.dart';

@riverpod
class RssFeedArticles extends _$RssFeedArticles {
  @override
  RssFeedArticlesState build() {
    return RssFeedArticlesState(
      rssFeedArticles: const AsyncValue.loading(),
      lastUpdatedAt: Timestamp(0, 0),
    );
  }

  /*
  rss feed articlesの取得
  */
  Future<bool> getRssFeedArticles({required String topicName}) async {
    // 現在の日時と最終更新日時を取得
    final now = DateTime.now().toUtc().add(const Duration(hours: 9));
    final lastUpdate =
        state.lastUpdatedAt.toDate().toUtc().add(const Duration(hours: 9));
    if (shouldFetchData(lastUpdate, now)) {
      try {
        state = state.copyWith(rssFeedArticles: const AsyncValue.loading());
        final rssFeedArticlesRepository =
            ref.read(rssFeedArticlesRepositoryProvider);

        final newTopics = await rssFeedArticlesRepository.fetchRssFeedArticles(
            topicName: topicName);

        state = state.copyWith(
          rssFeedArticles: AsyncValue.data(newTopics),
          lastUpdatedAt: Timestamp.now(),
        );
      } catch (e, s) {
        state = state.copyWith(rssFeedArticles: AsyncValue.error(e, s));
      }
      return true;
    } else {
      return false;
    }
  }
}