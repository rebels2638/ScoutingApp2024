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
              'selectedTheme', (v) => v as String? ?? 'default_dark'),
          showConsole:
              $checkedConvert('showConsole', (v) => v as bool? ?? false),
          profileId: $checkedConvert('profileId', (v) => v as String? ?? ''),
          totalScoutedMatches:
              $checkedConvert('totalScoutedMatches', (v) => v as int? ?? 0),
          showGameMap:
              $checkedConvert('showGameMap', (v) => v as bool? ?? true),
          showLegacyItems:
              $checkedConvert('showLegacyItems', (v) => v as bool? ?? false),
          useAltLayout:
              $checkedConvert('useAltLayout', (v) => v as bool? ?? false),
          seenPatchNotes:
              $checkedConvert('seenPatchNotes', (v) => v as bool? ?? false),
          profileArmed:
              $checkedConvert('profileArmed', (v) => v as bool? ?? false),
          profileName: $checkedConvert(
              'profileName', (v) => v as String? ?? 'Unspecified User'),
          usedTimeHours: $checkedConvert(
              'usedTimeHours', (v) => (v as num?)?.toDouble() ?? 0),
          preferCompact:
              $checkedConvert('preferCompact', (v) => v as bool? ?? false),
          showScrollbar:
              $checkedConvert('showScrollbar', (v) => v as bool? ?? false),
          preferTonal:
              $checkedConvert('preferTonal', (v) => v as bool? ?? true),
          showHints: $checkedConvert('showHints', (v) => v as bool? ?? true),
          preferCanonical:
              $checkedConvert('preferCanonical', (v) => v as bool? ?? true),
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
      'selectedTheme': instance.selectedTheme,
      'showConsole': instance.showConsole,
      'showGameMap': instance.showGameMap,
      'showExperimental': instance.showExperimental,
      'showFPSMonitor': instance.showFPSMonitor,
      'preferTonal': instance.preferTonal,
      'preferCanonical': instance.preferCanonical,
      'preferCompact': instance.preferCompact,
      'useAltLayout': instance.useAltLayout,
      'showHints': instance.showHints,
      'usedTimeHours': instance.usedTimeHours,
      'seenPatchNotes': instance.seenPatchNotes,
      'showScrollbar': instance.showScrollbar,
      'profileName': instance.profileName,
      'profileArmed': instance.profileArmed,
      'showLegacyItems': instance.showLegacyItems,
      'profileId': instance.profileId,
      'totalScoutedMatches': instance.totalScoutedMatches,
    };
