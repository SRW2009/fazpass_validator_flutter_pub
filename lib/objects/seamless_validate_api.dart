
import 'package:devicevalidator/objects/geolocation_api.dart';
import 'package:json_annotation/json_annotation.dart';

import 'device_api.dart';

part 'seamless_validate_api.g.dart';

@JsonSerializable(createToJson: false)
class SeamlessValidateAPI {
  static getFazpassId(json, key) => json['identification']['data'][key];
  @JsonKey(readValue: getFazpassId)
  final String fazpass_id;

  static getScoring(json, key) => json['identification']['data']['confidence']['score'];
  @JsonKey(readValue: getScoring)
  final double scoring;

  static getRiskLevel(json, key) => json['identification']['data']['confidence']['level'];
  @JsonKey(readValue: getRiskLevel)
  final String risk_level;

  static getDeviceId(json, key) => json['device_information']['data'];
  @JsonKey(readValue: getDeviceId)
  final DeviceAPI device_id;

  static getIsLocationAvailable(json, key) => json['gps_information']['data'];
  @_GPSAvailabilityConverter()
  @JsonKey(readValue: getIsLocationAvailable)
  final bool is_location_available;

  static getIsRooted(json, key) => json['root']['data']['result'];
  @JsonKey(readValue: getIsRooted)
  final bool is_rooted;

  static getIsEmulator(json, key) => json['emulator']['data']['result'];
  @JsonKey(readValue: getIsEmulator)
  final bool is_emulator;

  static getIsVpn(json, key) => json['ip_information']['data']['is_vpn'];
  @JsonKey(readValue: getIsVpn)
  final bool is_vpn;

  static getIsCloneApp(json, key) => json['clonning']['data']['result'];
  @JsonKey(readValue: getIsCloneApp)
  final bool is_clone_app;

  static getIsTempering(json, key) => json['tempering']['data']['result'];
  @JsonKey(readValue: getIsTempering)
  final bool is_app_tempering;

  static getIsScreenSharing(json, key) => json['screen_sharing']['data']['result'];
  @JsonKey(readValue: getIsScreenSharing)
  final bool is_screen_sharing;

  static getIsDebug(json, key) => json['debugging']['data']['result'];
  @JsonKey(readValue: getIsDebug)
  final bool is_debug;

  static getIsLocationSpoof(json, key) => json['gps_information']['data']['is_spoofed'];
  @JsonKey(readValue: getIsLocationSpoof)
  final bool is_gps_spoof;

  static _ipReverseGeoReadValue(Map<dynamic,dynamic> json, String key) => json['ip_information']['data']['geolocation'];
  @_ReverseGeoConverter()
  @JsonKey(readValue: _ipReverseGeoReadValue)
  final String ip_reverse_geo;

  static _asnReadValue(Map<dynamic,dynamic> json, String key) => json['ip_information']['data']['asn'];
  @_ASNConverter()
  @JsonKey(readValue: _asnReadValue)
  final String asn;

  bool get isRiskLow => risk_level == 'LOW';

  SeamlessValidateAPI(
      this.fazpass_id,
      this.scoring,
      this.risk_level,
      this.device_id,
      this.is_location_available,
      this.is_rooted,
      this.is_emulator,
      this.is_vpn,
      this.is_clone_app,
      this.is_app_tempering,
      this.is_screen_sharing,
      this.is_debug,
      this.is_gps_spoof,
      this.ip_reverse_geo,
      this.asn);

  factory SeamlessValidateAPI.fromJson(Map<String, dynamic> json) => _$SeamlessValidateAPIFromJson(json['data']);
}

class _GPSAvailabilityConverter implements JsonConverter<bool, Map<String, dynamic>> {
  const _GPSAvailabilityConverter();

  @override
  bool fromJson(Map<String, dynamic> json) {
    final geo = GeolocationAPI.fromJson(json);
    return geo.lat != "0.0" || geo.lng != "0.0";
  }

  @override
  Map<String, dynamic> toJson(bool object) {
    throw UnimplementedError();
  }
}

class _ReverseGeoConverter implements JsonConverter<String, Map<String, dynamic>> {
  const _ReverseGeoConverter();

  @override
  String fromJson(Map<String, dynamic> json) {
    final district = json['district'];
    final city = json['city'];
    final province = json['state_province'];
    final country = json['country'];
    final list = [district, city, province, country];
    list.removeWhere((v) => v == null);
    return list.join(', ');
  }

  @override
  Map<String, dynamic> toJson(String object) {
    throw UnimplementedError();
  }
}

class _ASNConverter implements JsonConverter<String, Map<String, dynamic>> {
  const _ASNConverter();

  @override
  String fromJson(Map<String, dynamic> json) {
    return '${json['number']} - ${json['name']}';
  }

  @override
  Map<String, dynamic> toJson(String object) {
    throw UnimplementedError();
  }
}