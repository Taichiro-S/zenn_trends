// ignore_for_file: constant_identifier_names
import 'package:zenn_trends/constant/firestore.dart';

const DEFAULT_LOAD_TOPICS = 20;
const DEFAULT_LOAD_ARTICLES = 20;
const QIITA_SCOPE = 'read_qiita write_qiita';
const DEFAULT_TIME_PERIOD = Collection.weeklyRanking;
const DEFAULT_SORT_ORDER = RankedTopicsSortOrder.taggingsCountChange;
const DEFAULT_WEEKLY_TAGGINGS_COUNT_CHANGE_CUTOFF = 7;
const DEFAULT_MONTHLY_TAGGINGS_COUNT_CHANGE_CUTOFF = 30;
const DEFAULT_TAGGINGS_COUNT_CUTOFF = 1000;
