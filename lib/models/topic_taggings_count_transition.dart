class TopicTaggingsCountTransition {
  final int id;
  bool _hasCompleteData = false;
  bool _isTagged = false;
  final Map<DateTime, int> taggingCountTransition;
  bool get isTagged => _isTagged;
  set isTagged(bool v) {
    _isTagged = v;
  }

  bool get hasCompleteData => _hasCompleteData;
  set hasCompleteData(bool v) {
    _hasCompleteData = v;
  }

  TopicTaggingsCountTransition({
    required this.id,
    required this.taggingCountTransition,
  });

  factory TopicTaggingsCountTransition.fromDocument(
      int id, Map<DateTime, int> taggingCountTransition) {
    return TopicTaggingsCountTransition(
      id: id,
      taggingCountTransition: taggingCountTransition,
    );
  }
}
