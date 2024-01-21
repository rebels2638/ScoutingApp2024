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
        $checkKeys(
          json,
          requiredKeys: const ['selectedTheme'],
        );
        final val = UserPrefModel(
          selectedTheme: $checkedConvert(
              'selectedTheme',
              (v) =>
                  $enumDecodeNullable(_$AvaliableThemesEnumMap, v) ??
                  AvaliableThemes.default_dark),
        );
        return val;
      },
    );

Map<String, dynamic> _$UserPrefModelToJson(UserPrefModel instance) =>
    <String, dynamic>{
      'selectedTheme': _$AvaliableThemesEnumMap[instance.selectedTheme]!,
    };

const _$AvaliableThemesEnumMap = {
  AvaliableThemes.default_light: 'default_light',
  AvaliableThemes.default_dark: 'default_dark',
  AvaliableThemes.mint: 'mint',
  AvaliableThemes.forest: 'forest',
  AvaliableThemes.peach: 'peach',
  AvaliableThemes.plum: 'plum',
};
