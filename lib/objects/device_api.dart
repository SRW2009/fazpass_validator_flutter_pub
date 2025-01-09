
import 'package:json_annotation/json_annotation.dart';

part 'device_api.g.dart';

@JsonSerializable()
class DeviceAPI {
  @JsonKey(name: 'id')
  String id;
  @JsonKey(name: 'os_version')
  final String os;
  @JsonKey(name: 'name')
  final String brand;
  @JsonKey(name: 'series')
  final String type;
  final String cpu;

  DeviceAPI(this.id, this.os, this.brand, this.type, this.cpu);

  factory DeviceAPI.fromJson(Map<String, dynamic> json) => _$DeviceAPIFromJson(json);
}