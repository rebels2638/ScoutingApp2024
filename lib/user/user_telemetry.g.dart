// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_telemetry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPrefModel _$UserPrefModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserPrefModel',
      json,
      ($checkedConvert) {
        final val = UserPrefModel(
          selectedTheme: $checkedConvert(
              'selectedTheme',
              (v) =>
                  $enumDecodeNullable(_$AvaliableThemesEnumMap, v) ??
                  AvaliableThemes.default_dark),
          showConsole:
              $checkedConvert('showConsole', (v) => v as bool? ?? false),
          showGameMap:
              $checkedConvert('showGameMap', (v) => v as bool? ?? true),
          showPastMatchesWhileLockedIn: $checkedConvert(
              'showPastMatchesWhileLockedIn', (v) => v as bool? ?? false),
          showFPSMonitor:
              $checkedConvert('showFPSMonitor', (v) => v as bool? ?? false),
          showExperimental:
              $checkedConvert('showExperimental', (v) => v as bool? ?? false),
        );
        return val;
      },
    );

Map<String, dynamic> _$UserPrefModelToJson(UserPrefModel instance) =>
    <String, dynamic>{
      'selectedTheme': _$AvaliableThemesEnumMap[instance.selectedTheme]!,
      'showConsole': instance.showConsole,
      'showGameMap': instance.showGameMap,
      'showExperimental': instance.showExperimental,
      'showFPSMonitor': instance.showFPSMonitor,
      'showPastMatchesWhileLockedIn': instance.showPastMatchesWhileLockedIn,
    };

const _$AvaliableThemesEnumMap = {
  AvaliableThemes.default_dark: 'default_dark',
  AvaliableThemes.default_light: 'default_light',
  AvaliableThemes.mint: 'mint',
  AvaliableThemes.forest: 'forest',
  AvaliableThemes.matcha: 'matcha',
  AvaliableThemes.peach: 'peach',
  AvaliableThemes.plum: 'plum',
};
