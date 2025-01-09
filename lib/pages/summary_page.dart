
import 'dart:io';

import 'package:devicevalidator/color_palette.dart';
import 'package:devicevalidator/helpers/text_modifier.dart';
import 'package:devicevalidator/objects/device_api.dart';
import 'package:devicevalidator/objects/seamless_validate_api.dart';
import 'package:flutter/material.dart';
import 'package:devicevalidator/widgets/flashing_circle.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({
    super.key,
    required this.fazpassResult,
  });

  final SeamlessValidateAPI fazpassResult;

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {

  late final items = <String>[
    if (Platform.isAndroid) TextModifier.not(!widget.fazpassResult.is_rooted, (not) => "Device is $not rooted"),
    if (Platform.isIOS) TextModifier.not(!widget.fazpassResult.is_rooted, (not) => "Device is $not jailbroken"),
    TextModifier.not(!widget.fazpassResult.is_emulator, (not) => "Device is $not emulator"),
    TextModifier.not(!widget.fazpassResult.is_vpn, (not) => "Device is $not using vpn"),
    TextModifier.not(!widget.fazpassResult.is_clone_app, (not) => "Application is $not cloned"),
    TextModifier.not(!widget.fazpassResult.is_app_tempering, (not) => "Application has $not been tampered"),
    TextModifier.not(!widget.fazpassResult.is_screen_sharing, (not) => "Application is $not being recorded / screen mirrored"),
    TextModifier.not(!widget.fazpassResult.is_debug, (not) => "Application is $not in debug mode"),
    if (widget.fazpassResult.is_location_available) TextModifier.not(!widget.fazpassResult.is_gps_spoof, (not) => "Device location is $not mocked"),
    if (!widget.fazpassResult.is_location_available) "'Device location is mocked' status is unavailable",
  ];

  DeviceAPI get device => widget.fazpassResult.device_id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _flashingCircle(
                  (widget.fazpassResult.isRiskLow) ? ColorPalette.successColor: ColorPalette.failedColor,
                  Icons.speed,
                  'Score',
                  '${widget.fazpassResult.scoring}',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: _flashingCircle(
                    ColorPalette.primaryColor,
                    Icons.smartphone,
                    'Device',
                    '${device.brand}, ${device.type}\n${device.os}',
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            color: ColorPalette.primaryBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Device ID is ${widget.fazpassResult.device_id.id}'),
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            color: ColorPalette.primaryBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Location from IP Address is ${widget.fazpassResult.ip_reverse_geo}'),
            ),
          ),
          Card(
            color: ColorPalette.primaryBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Internet ASN is ${widget.fazpassResult.asn}'),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(),
          ),
          for (final item in items) Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            color: (item.contains('unavailable'))
                ? ColorPalette.unavailableBackgroundColor
                : (item.contains('not'))
                  ? ColorPalette.successBackgroundColor
                  : ColorPalette.failedBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(item),
            ),
          ),
        ],
      ),
    );
  }

  Widget _flashingCircle(Color flashColor, IconData icon, String title, String value) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox.square(
          dimension: 180,
          child: FlashingCircle(
            flashColor: flashColor,
            borderWidth: 16,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text(title),
            ),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                height: 1.4,
                color: ColorPalette.primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
