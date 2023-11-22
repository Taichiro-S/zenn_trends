import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zenn_trends/constant/firestore_arg.dart';
import 'package:zenn_trends/pages/ranking/model/loaded_topics_state.dart';
import 'package:zenn_trends/pages/ranking/provider/display_settings_provider.dart';
import 'package:zenn_trends/pages/ranking/repository/ranked_topics_repository.dart';

part 'loaded_topics_provider.g.dart';

@riverpod
class LoadedTopics extends _$LoadedTopics {
  @override
  LoadedTopicsState build() {
    return LoadedTopicsState(
      weeklyRankedTopics: const AsyncValue.data([]),
      monthlyRankedTopics: const AsyncValue.data([]),
      weeklySearchedTopics: const AsyncValue.data([]),
      monthlySearchedTopics: const AsyncValue.data([]),
      weeklyRankedLastDoc: null,
      monthlyRankedLastDoc: null,
      weeklySearchedLastDoc: null,
      monthlySearchedLastDoc: null,
      isLoadingMore: false,
      isSearching: false,
      showSearchResult: false,
      lastUpdatedAt: Timestamp(0, 0),
    );
  }

  /*
  topicの取得
  */
  Future<void> getRankedTopics(
      {required Collection timePeriod,
      required RankedTopicsSortOrder sortOrder}) async {
    // 現在の日時と最終更新日時を取得（UTCに変換して日本時間に合わせる）
    final now = DateTime.now().toUtc().add(const Duration(hours: 9));
    final lastUpdate =
        state.lastUpdatedAt.toDate().toUtc().add(const Duration(hours: 9));

    // 最終更新日の翌日の朝6時を計算
    final nextDay6Am =
        DateTime(lastUpdate.year, lastUpdate.month, lastUpdate.day + 1, 6)
            .toUtc()
            .add(const Duration(hours: 9));

    final rankedTopicsrepository = ref.watch(rankedTopicsRepositoryProvider);

    // データ更新のタイミングが朝6時であるため、
    // 現在の時刻が最終更新日の翌日の朝6時を過ぎている場合はデータを取得して更新
    if (now.isAfter(nextDay6Am)) {
      state = timePeriod == Collection.weeklyRanking
          ? state.copyWith(weeklyRankedTopics: const AsyncValue.loading())
          : state.copyWith(monthlyRankedTopics: const AsyncValue.loading());
      try {
        final newTopics = await rankedTopicsrepository.fetchRankedTopics(
            timePeriod: timePeriod, sortOrder: sortOrder);

        if (timePeriod == Collection.weeklyRanking) {
          state = state.copyWith(
            weeklyRankedTopics: AsyncValue.data(newTopics),
            weeklyRankedLastDoc:
                newTopics.isNotEmpty ? newTopics.last.documentSnapshot : null,
            lastUpdatedAt: Timestamp.now(),
          );
        } else {
          state = state.copyWith(
            monthlyRankedTopics: AsyncValue.data(newTopics),
            monthlyRankedLastDoc:
                newTopics.isNotEmpty ? newTopics.last.documentSnapshot : null,
            lastUpdatedAt: Timestamp.now(),
          );
        }
      } catch (e, s) {
        state = timePeriod == Collection.weeklyRanking
            ? state.copyWith(weeklyRankedTopics: AsyncValue.error(e, s))
            : state.copyWith(monthlyRankedTopics: AsyncValue.error(e, s));
      }
      // キャッシュデータがない場合のみデータを取得
    } else if (timePeriod == Collection.weeklyRanking &&
        state.weeklyRankedTopics is AsyncData &&
        (state.weeklyRankedTopics.value != null &&
            state.weeklyRankedTopics.value!.isEmpty)) {
      state = state.copyWith(weeklyRankedTopics: const AsyncValue.loading());
      try {
        final newTopics = await rankedTopicsrepository.fetchRankedTopics(
            timePeriod: timePeriod, sortOrder: sortOrder);
        state = state.copyWith(
          weeklyRankedTopics: AsyncValue.data(newTopics),
          weeklyRankedLastDoc:
              newTopics.isNotEmpty ? newTopics.last.documentSnapshot : null,
          lastUpdatedAt: Timestamp.now(),
        );
      } catch (e, s) {
        state = state.copyWith(weeklyRankedTopics: AsyncValue.error(e, s));
      }
    } else if (timePeriod == Collection.monthlyRanking &&
        state.monthlyRankedTopics is AsyncData &&
        (state.monthlyRankedTopics.value != null &&
            state.monthlyRankedTopics.value!.isEmpty)) {
      state = state.copyWith(monthlyRankedTopics: const AsyncValue.loading());
      try {
        final newTopics = await rankedTopicsrepository.fetchRankedTopics(
            timePeriod: timePeriod, sortOrder: sortOrder);
        state = state.copyWith(
          monthlyRankedTopics: AsyncValue.data(newTopics),
          monthlyRankedLastDoc:
              newTopics.isNotEmpty ? newTopics.last.documentSnapshot : null,
          lastUpdatedAt: Timestamp.now(),
        );
      } catch (e, s) {
        state = state.copyWith(monthlyRankedTopics: AsyncValue.error(e, s));
      }
    }
  }

  Future<void> getMoreRankedTopics(
      {required Collection timePeriod,
      required RankedTopicsSortOrder sortOrder}) async {
    final rankedTopicsrepository = ref.watch(rankedTopicsRepositoryProvider);

    if ((timePeriod == Collection.weeklyRanking &&
            (state.weeklyRankedLastDoc == null ||
                state.weeklyRankedTopics is! AsyncData)) ||
        (timePeriod == Collection.monthlyRanking &&
            (state.monthlyRankedLastDoc == null ||
                state.monthlyRankedTopics is! AsyncData)) ||
        state.isLoadingMore) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);

    try {
      if (timePeriod == Collection.weeklyRanking) {
        final newTopics = await rankedTopicsrepository.fetchRankedTopics(
            timePeriod: timePeriod,
            sortOrder: sortOrder,
            startAfter: state.weeklyRankedLastDoc);
        state = state.copyWith(
          weeklyRankedTopics: AsyncValue.data(
              [...(state.weeklyRankedTopics.value ?? []), ...newTopics]),
          weeklyRankedLastDoc:
              newTopics.isNotEmpty ? newTopics.last.documentSnapshot : null,
          isLoadingMore: false,
        );
      } else if (timePeriod == Collection.monthlyRanking) {
        final newTopics = await rankedTopicsrepository.fetchRankedTopics(
            timePeriod: timePeriod,
            sortOrder: sortOrder,
            startAfter: state.monthlyRankedLastDoc);
        state = state.copyWith(
          monthlyRankedTopics: AsyncValue.data(
              [...(state.monthlyRankedTopics.value ?? []), ...newTopics]),
          monthlyRankedLastDoc:
              newTopics.isNotEmpty ? newTopics.last.documentSnapshot : null,
          isLoadingMore: false,
        );
      }
    } catch (e, s) {
      state = state.copyWith(
        weeklyRankedTopics: timePeriod == Collection.weeklyRanking
            ? AsyncValue.error(e, s)
            : state.weeklyRankedTopics,
        monthlyRankedTopics: timePeriod == Collection.monthlyRanking
            ? AsyncValue.error(e, s)
            : state.monthlyRankedTopics,
      );
    } finally {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  /*
  検索機能
  */

  Future<void> getSearchedTopics(
      {required Collection timePeriod,
      required RankedTopicsSortOrder sortOrder,
      required String searchWord}) async {
    final rankedTopicsrepository = ref.watch(rankedTopicsRepositoryProvider);

    state = timePeriod == Collection.weeklyRanking
        ? state.copyWith(weeklySearchedTopics: const AsyncValue.loading())
        : state.copyWith(monthlySearchedTopics: const AsyncValue.loading());

    try {
      final newTopics = await rankedTopicsrepository.fetchRankedTopics(
          timePeriod: timePeriod, sortOrder: sortOrder, searchWord: searchWord);

      if (timePeriod == Collection.weeklyRanking) {
        state = state.copyWith(
            weeklySearchedTopics: AsyncValue.data(newTopics),
            weeklySearchedLastDoc:
                newTopics.isNotEmpty ? newTopics.last.documentSnapshot : null);
      } else {
        state = state.copyWith(
            monthlySearchedTopics: AsyncValue.data(newTopics),
            monthlySearchedLastDoc:
                newTopics.isNotEmpty ? newTopics.last.documentSnapshot : null);
      }
    } catch (e, s) {
      state = timePeriod == Collection.weeklyRanking
          ? state.copyWith(weeklySearchedTopics: AsyncValue.error(e, s))
          : state.copyWith(monthlySearchedTopics: AsyncValue.error(e, s));
    }
  }

  Future<void> getMoreSearchedTopics(
      {required Collection timePeriod,
      required RankedTopicsSortOrder sortOrder,
      required String searchWord}) async {
    final rankedTopicsrepository = ref.watch(rankedTopicsRepositoryProvider);

    if ((timePeriod == Collection.weeklyRanking &&
            (state.weeklySearchedLastDoc == null ||
                state.weeklySearchedTopics is! AsyncData)) ||
        (timePeriod == Collection.monthlyRanking &&
            (state.monthlySearchedLastDoc == null ||
                state.monthlySearchedTopics is! AsyncData)) ||
        state.isLoadingMore) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);

    try {
      if (timePeriod == Collection.weeklyRanking) {
        final newTopics = await rankedTopicsrepository.fetchRankedTopics(
          timePeriod: timePeriod,
          sortOrder: sortOrder,
          startAfter: state.weeklySearchedLastDoc,
          searchWord: searchWord,
        );
        state = state.copyWith(
          weeklySearchedTopics: AsyncValue.data(
              [...(state.weeklySearchedTopics.value ?? []), ...newTopics]),
          weeklySearchedLastDoc:
              newTopics.isNotEmpty ? newTopics.last.documentSnapshot : null,
          isLoadingMore: false,
        );
      } else if (timePeriod == Collection.monthlyRanking) {
        final newTopics = await rankedTopicsrepository.fetchRankedTopics(
          timePeriod: timePeriod,
          sortOrder: sortOrder,
          startAfter: state.monthlySearchedLastDoc,
          searchWord: searchWord,
        );
        state = state.copyWith(
          monthlySearchedTopics: AsyncValue.data(
              [...(state.monthlySearchedTopics.value ?? []), ...newTopics]),
          monthlySearchedLastDoc:
              newTopics.isNotEmpty ? newTopics.last.documentSnapshot : null,
          isLoadingMore: false,
        );
      }
    } catch (e, s) {
      state = state.copyWith(
        weeklySearchedTopics: timePeriod == Collection.weeklyRanking
            ? AsyncValue.error(e, s)
            : state.weeklySearchedTopics,
        monthlySearchedTopics: timePeriod == Collection.monthlyRanking
            ? AsyncValue.error(e, s)
            : state.monthlySearchedTopics,
      );
    } finally {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  void setSearchWord(String searchWord) {
    state = state.copyWith(isSearching: true);
    state = state.copyWith(searchWord: searchWord);
    state = state.copyWith(showSearchResult: false);
  }

  void clearSearchWord() {
    state = state.copyWith(isSearching: true);
    state = state.copyWith(searchWord: '');
    state = state.copyWith(showSearchResult: false);
  }

  void startSearching() {
    state = state.copyWith(isSearching: true);
    state = state.copyWith(showSearchResult: false);
  }

  void search({required String searchWord}) {
    final displaySettings = ref.watch(displaySettingsProvider);
    state = state.copyWith(isSearching: false);
    state = state.copyWith(searchWord: searchWord);
    state = state.copyWith(showSearchResult: true);

    getSearchedTopics(
        timePeriod: displaySettings.timePeriod,
        sortOrder: displaySettings.sortOrder,
        searchWord: searchWord);
  }

  void stopSearching() {
    state = state.copyWith(searchWord: '');
    state = state.copyWith(isSearching: false);
    state = state.copyWith(showSearchResult: false);
  }

  /*
  お気に入り機能
  */
}
