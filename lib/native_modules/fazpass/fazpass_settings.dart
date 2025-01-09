
import 'sensitive_data.dart';

class FazpassSettings {
  final List<SensitiveData> _sensitiveData;
  final bool _isBiometricLevelHigh;

  List<SensitiveData> get sensitiveData => _sensitiveData.toList();
  bool get isBiometricLevelHigh => _isBiometricLevelHigh;

  FazpassSettings._(this._sensitiveData, this._isBiometricLevelHigh);

  factory FazpassSettings.fromString(String settingsString) {
    final splitter = settingsString.split(";");
    final sensitiveData = splitter[0].split(",")
        .takeWhile((it) => it != "")
        .map((it) => SensitiveData.values.firstWhere((element) => element.name == it))
        .toList();
    final isBiometricLevelHigh = bool.tryParse(splitter[1]) ?? false;

    return FazpassSettings._(sensitiveData, isBiometricLevelHigh);
  }

  @override
  String toString() => "${_sensitiveData.map((it) => it.name).join(",")};$_isBiometricLevelHigh";
}

class FazpassSettingsBuilder {
  final List<SensitiveData> _sensitiveData;
  bool _isBiometricLevelHigh;

  List<SensitiveData> get sensitiveData => _sensitiveData.toList();
  bool get isBiometricLevelHigh => _isBiometricLevelHigh;

  FazpassSettingsBuilder()
      : _sensitiveData = [],
        _isBiometricLevelHigh = false;

  FazpassSettingsBuilder.fromFazpassSettings(FazpassSettings settings)
      : _sensitiveData = [...settings._sensitiveData],
        _isBiometricLevelHigh = settings._isBiometricLevelHigh;

  FazpassSettingsBuilder enableSelectedSensitiveData(List<SensitiveData> sensitiveData) {
    for (final data in sensitiveData) {
      if (_sensitiveData.contains(data)) {
        continue;
      } else {
        _sensitiveData.add(data);
      }
    }
    return this;
  }

  FazpassSettingsBuilder disableSelectedSensitiveData(List<SensitiveData> sensitiveData) {
    for (final data in sensitiveData) {
      if (_sensitiveData.contains(data)) {
        _sensitiveData.remove(data);
      } else {
        continue;
      }
    }
    return this;
  }

  FazpassSettingsBuilder setBiometricLevelToHigh() {
    _isBiometricLevelHigh = true;
    return this;
  }

  FazpassSettingsBuilder setBiometricLevelToLow() {
    _isBiometricLevelHigh = false;
    return this;
  }

  FazpassSettings build() => FazpassSettings._(
      _sensitiveData,
      _isBiometricLevelHigh);
}