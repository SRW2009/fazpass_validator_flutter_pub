import 'dart:io';

import 'package:flutter/services.dart';

import 'cross_device_data.dart';
import 'fazpass_exceptions.dart';
import 'fazpass_settings.dart';

class Fazpass {
  static const _CHANNEL = 'com.fazpass.trusted-device';
  static const _CD_CHANNEL = 'com.fazpass.trusted-device-cd';

  static const instance = Fazpass();

  const Fazpass();

  final _methodChannel = const MethodChannel(_CHANNEL);
  final _eventChannel = const EventChannel(_CD_CHANNEL);

  Future<String> generateMeta({int accountIndex=-1}) async {
    String meta = '';
    try {
      meta = await _methodChannel.invokeMethod<String>('generateMeta', accountIndex) ?? '';
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'fazpass-BiometricNoneEnrolledError':
          throw BiometricNoneEnrolledError(e);
        case 'fazpass-BiometricAuthFailedError':
          throw BiometricAuthFailedError(e);
        case 'fazpass-BiometricUnavailableError':
          throw BiometricUnavailableError(e);
        case 'fazpass-BiometricUnsupportedError':
          throw BiometricUnsupportedError(e);
        case 'fazpass-PublicKeyNotExistException':
          throw PublicKeyNotExistException(e);
        case 'fazpass-UninitializedException':
          throw UninitializedException(e);
        case 'fazpass-BiometricSecurityUpdateRequiredError':
          throw BiometricSecurityUpdateRequiredError(e);
        case 'fazpass-EncryptionException':
        default:
          throw EncryptionException(e);
      }
    }
    return meta;
  }

  Future<void> generateNewSecretKey() async {
    return _methodChannel.invokeMethod('generateNewSecretKey');
  }

  Future<FazpassSettings?> getSettings(int accountIndex) async {
    final settingsString = await _methodChannel.invokeMethod('getSettings', accountIndex);
    if (settingsString is String) {
      return FazpassSettings.fromString(settingsString);
    }
    return null;
  }

  Future<void> setSettings(int accountIndex, FazpassSettings? settings) async {
    return await _methodChannel.invokeMethod('setSettings', {"accountIndex": accountIndex, "settings": settings?.toString()});
  }

  Stream<CrossDeviceData> getCrossDeviceDataStreamInstance() {
    return _eventChannel.receiveBroadcastStream().map((event) => CrossDeviceData.fromData(event));
  }

  Future<CrossDeviceData?> getCrossDeviceDataFromNotification() async {
    final data = await _methodChannel.invokeMethod('getCrossDeviceDataFromNotification');
    return data == null ? null : CrossDeviceData.fromData(data);
  }

  Future<List<String>> getAppSignatures() async {
    if (Platform.isAndroid) {
      final signatures = await _methodChannel.invokeListMethod<String>('getAppSignatures');
      return signatures ?? [];
    }

    return [];
  }
}