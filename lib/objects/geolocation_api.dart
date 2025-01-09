
import 'package:json_annotation/json_annotation.dart';

part 'geolocation_api.g.dart';

@JsonSerializable()
class GeolocationAPI {
  final String lat;
  final String lng;

  GeolocationAPI(this.lat, this.lng);

  factory GeolocationAPI.fromJson(Map<String, dynamic> json) => _$GeolocationAPIFromJson(json);
}