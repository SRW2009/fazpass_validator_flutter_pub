
import 'package:devicevalidator/native_modules/fazpass/fazpass.dart';
import 'package:devicevalidator/native_modules/fazpass/fazpass_settings.dart';
import 'package:devicevalidator/native_modules/fazpass/sensitive_data.dart';

class FazpassService {

  const FazpassService();

  final _fazpass = Fazpass.instance;

  Future<String> generateMeta() {
    _fazpass.getAppSignatures().then((val) => print('APPSGN: ${val.join(', ')}'));
    return _fazpass.generateMeta(accountIndex: 0);
  }

  Future toggleLocation(bool on) async {
    final builder = FazpassSettingsBuilder();
    if (on) {
      builder.enableSelectedSensitiveData([SensitiveData.location]);
    } else {
      builder.disableSelectedSensitiveData([SensitiveData.location]);
    }
    await _fazpass.setSettings(0, builder.build());
  }
}