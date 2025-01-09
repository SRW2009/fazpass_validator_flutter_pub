
import 'package:json_annotation/json_annotation.dart';

part 'seamless_check_api.g.dart';

@JsonSerializable(createToJson: false)
class SeamlessCheckAPI {
  static getFazpassId(json, key) => json['identification']['data'][key];
  @JsonKey(readValue: getFazpassId)
  final String fazpass_id;

  static getChallenge(json, key) => json['identification']['data'][key];
  @JsonKey(readValue: getChallenge)
  final String challenge;

  static getDeviceId(json, key) => json['device_information']['data']['id'];
  @JsonKey(readValue: getDeviceId)
  final String device_id;

  SeamlessCheckAPI(this.fazpass_id, this.challenge, this.device_id);

  factory SeamlessCheckAPI.fromJson(Map<String, dynamic> json) => _$SeamlessCheckAPIFromJson(json['data']);
}