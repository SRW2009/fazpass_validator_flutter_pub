// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seamless_validate_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeamlessValidateAPI _$SeamlessValidateAPIFromJson(Map<String, dynamic> json) =>
    SeamlessValidateAPI(
      SeamlessValidateAPI.getFazpassId(json, 'fazpass_id') as String,
      (SeamlessValidateAPI.getScoring(json, 'scoring') as num).toDouble(),
      SeamlessValidateAPI.getRiskLevel(json, 'risk_level') as String,
      DeviceAPI.fromJson(SeamlessValidateAPI.getDeviceId(json, 'device_id')
          as Map<String, dynamic>),
      const _GPSAvailabilityConverter().fromJson(
          SeamlessValidateAPI.getIsLocationAvailable(
              json, 'is_location_available') as Map<String, dynamic>),
      SeamlessValidateAPI.getIsRooted(json, 'is_rooted') as bool,
      SeamlessValidateAPI.getIsEmulator(json, 'is_emulator') as bool,
      SeamlessValidateAPI.getIsVpn(json, 'is_vpn') as bool,
      SeamlessValidateAPI.getIsCloneApp(json, 'is_clone_app') as bool,
      SeamlessValidateAPI.getIsTempering(json, 'is_app_tempering') as bool,
      SeamlessValidateAPI.getIsScreenSharing(json, 'is_screen_sharing') as bool,
      SeamlessValidateAPI.getIsDebug(json, 'is_debug') as bool,
      SeamlessValidateAPI.getIsLocationSpoof(json, 'is_gps_spoof') as bool,
      const _ReverseGeoConverter().fromJson(
          SeamlessValidateAPI._ipReverseGeoReadValue(json, 'ip_reverse_geo')
              as Map<String, dynamic>),
      const _ASNConverter().fromJson(
          SeamlessValidateAPI._asnReadValue(json, 'asn')
              as Map<String, dynamic>),
    );
