
import 'package:country_code_picker/country_code_picker.dart';
import 'package:devicevalidator/assets.dart';
import 'package:devicevalidator/color_palette.dart';
import 'package:devicevalidator/pages/validate_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class InputCredPage extends StatefulWidget {
  const InputCredPage({super.key});

  @override
  State<InputCredPage> createState() => _InputCredPageState();
}

class _InputCredPageState extends State<InputCredPage> {

  final _phoneController = TextEditingController();
  var _countryCode = '+62';
  var _withLocation = false;

  get _phone {
    var phone = _phoneController.text;
    if (phone.startsWith('0')) {
      phone = phone.substring(1);
    } else if (phone.startsWith('62')) {
      phone = phone.substring(2);
    } else if (phone.startsWith('+62')) {
      phone = phone.substring(3);
    }
    return _phoneController.text;
  }

  void _onCheck() {
    if (_phoneController.text.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (c) => ValidatePage(phone: _countryCode + _phone, withLocation: _withLocation)),
    );
  }

  void _toggleLocation(bool? on) async {
    if (on ?? false) {
      var status = await Permission.locationWhenInUse.request();
      if (status.isGranted) {
        setState(() {
          _withLocation = true;
        });
      }
    } else {
      setState(() {
        _withLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  Assets.logoFazpass,
                  fit: BoxFit.fitHeight,
                  height: 80,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: ColorPalette.primaryColor),
              ),
              child: Row(
                children: [
                  CountryCodePicker(
                    boxDecoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    flagWidth: 20,
                    initialSelection: _countryCode,
                    showFlag: true,
                    textStyle: const TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.bold),
                    onChanged: (value) => setState(() => _countryCode = value.toString()),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: 'Phone Number',
                      ),
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CheckboxListTile(
              value: _withLocation,
              onChanged: _toggleLocation,
              title: const Text('With Location'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onCheck,
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(ColorPalette.primaryColor),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              child: const Text('Check Device Security Level'),
            ),
          ],
        ),
      ),
    );
  }
}
