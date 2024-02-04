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
        );
        return val;
      },
    );

Map<String, dynamic> _$UserPrefModelToJson(UserPrefModel instance) =>
    <String, dynamic>{
      'selectedTheme': _$AvaliableThemesEnumMap[instance.selectedTheme]!,
      'showConsole': instance.showConsole,
      'showGameMap': instance.showGameMap,
    };

const _$AvaliableThemesEnumMap = {
  AvaliableThemes.default_dark: 'default_dark',
  AvaliableThemes.default_light: 'default_light',
  AvaliableThemes.mint: 'mint',
  AvaliableThemes.forest: 'forest',
  AvaliableThemes.peach: 'peach',
  AvaliableThemes.plum: 'plum',
};
