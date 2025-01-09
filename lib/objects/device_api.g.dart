// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceAPI _$DeviceAPIFromJson(Map<String, dynamic> json) => DeviceAPI(
      json['id'] as String,
      json['os_version'] as String,
      json['name'] as String,
      json['series'] as String,
      json['cpu'] as String,
    );

Map<String, dynamic> _$DeviceAPIToJson(DeviceAPI instance) => <String, dynamic>{
      'id': instance.id,
      'os_version': instance.os,
      'name': instance.brand,
      'series': instance.type,
      'cpu': instance.cpu,
    };
