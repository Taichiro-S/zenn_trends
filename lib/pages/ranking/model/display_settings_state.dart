import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenn_trends/constant/firestore.dart';
part 'display_settings_state.freezed.dart';

@freezed
class DisplaySettingsState with _$DisplaySettingsState {
  const factory DisplaySettingsState({
    required Collection timePeriod,
    required RankedTopicsSortOrder sortOrder,
    required bool showChart,
  }) = _DisplaySettingsState;
}
