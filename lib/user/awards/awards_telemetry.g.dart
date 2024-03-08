// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'awards_telemetry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AwardsModel _$AwardsModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'AwardsModel',
      json,
      ($checkedConvert) {
        final val = AwardsModel(
          unlockedAwards: $checkedConvert(
              'unlockedAwards',
              (v) =>
                  (v as List<dynamic>?)?.map((e) => e as String).toList() ??
                  []),
          lockedAwards: $checkedConvert(
              'lockedAwards',
              (v) =>
                  (v as List<dynamic>?)?.map((e) => e as String).toList() ??
                  []),
        );
        return val;
      },
    );

Map<String, dynamic> _$AwardsModelToJson(AwardsModel instance) =>
    <String, dynamic>{
      'unlockedAwards': instance.unlockedAwards,
      'lockedAwards': instance.lockedAwards,
    };
