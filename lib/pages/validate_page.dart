
import 'package:devicevalidator/color_palette.dart';
import 'package:devicevalidator/helpers/text_modifier.dart';
import 'package:devicevalidator/native_modules/fazpass/fazpass_exceptions.dart';
import 'package:devicevalidator/objects/seamless_validate_api.dart';
import 'package:devicevalidator/pages/summary_page.dart';
import 'package:devicevalidator/services/fazpass_service.dart';
import 'package:devicevalidator/services/seamless_service.dart';
import 'package:devicevalidator/widgets/flashing_circle.dart';
import 'package:flutter/material.dart';

class ValidatePage extends StatefulWidget {
  const ValidatePage({super.key, required this.phone, required this.withLocation});

  final String phone;
  final bool withLocation;

  @override
  State<ValidatePage> createState() => _ValidatePageState();
}

class _ValidatePageState extends State<ValidatePage> {

  final _fazpassService = const FazpassService();
  final _seamlessService = const SeamlessService();

  var _progress = 0;
  var _isDone = false;
  SeamlessValidateAPI? _fazpassResult;

  set updateProgress(int value) => setState(() {
    _progress = value;
  });

  void _onSummary() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (c) => SummaryPage(
        fazpassResult: _fazpassResult!
      )),
    );
  }

  @override
  void initState() {
    super.initState();

    _fazpassService.toggleLocation(widget.withLocation);
    _fazpassService.generateMeta()
        .then((meta) async {
          final checkToEnroll = await _seamlessService.check(widget.phone, meta);
          if (checkToEnroll == null) throw Exception();
          updateProgress = 25;
          final enroll = await _seamlessService.enroll(widget.phone, meta, checkToEnroll.challenge);
          if (!enroll) throw Exception();
          updateProgress = 50;
          final checkToValidate = await _seamlessService.check(widget.phone, meta);
          if (checkToValidate == null) throw Exception();
          updateProgress = 75;
          final validate = await _seamlessService.validate(widget.phone, meta, checkToValidate.challenge, checkToValidate.fazpass_id);
          if (validate == null) throw Exception();
          updateProgress = 100;
          setState(() {
            _fazpassResult = validate;
            _isDone = true;
          });
        })
        .onError<FazpassException>((err, trace) {
          print(trace);
          if (mounted) {
            showDialog(
              context: context,
              builder: (c) => AlertDialog(
                title: const Text('Error'),
                content: Text('$err'),
                actions: [
                  TextButton(onPressed: () => Navigator.of(c).pop(), child: const Text('OK')),
                ],
              ),
            );
          }
        })
        .catchError((err) {
          print(err);
          if (mounted) {
            showDialog(
              context: context,
              builder: (c) => AlertDialog(
                title: const Text('Error'),
                content: const Text('There seems to be a problem. Please try again.'),
                actions: [
                  TextButton(onPressed: () => Navigator.of(c).pop(), child: const Text('OK')),
                ],
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Device'),
      ),
      floatingActionButton: (_isDone) ? FloatingActionButton.extended(
        onPressed: _onSummary,
        backgroundColor: ColorPalette.primaryColor,
        foregroundColor: Colors.white,
        label: const Text('See Summary'),
      ) : null,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (_isDone) ? _flashingCircle() : _loadingCircle(),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                (_isDone) ? TextModifier.not(!_fazpassResult!.isRiskLow, (not) => 'Your device is $not secure!') : 'Please wait...',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  
  Widget _loadingCircle() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        const SizedBox.square(
          dimension: 220,
          child: CircularProgressIndicator(strokeWidth: 20),
        ),
        Center(
            child: Text(
              '$_progress%',
              style: const TextStyle(
                fontSize: 30,
              ),
            )
        ),
      ],
    );
  }

  Widget _flashingCircle() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox.square(
          dimension: 220,
          child: FlashingCircle(
            flashColor: (_fazpassResult!.isRiskLow) ? ColorPalette.successColor : ColorPalette.failedColor,
            borderWidth: 24,
          ),
        ),
        Center(
          child: Column(
            children: [
              const Text('Security Risk'),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  (_fazpassResult!.isRiskLow) ? 'LOW' : 'HIGH',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: (_fazpassResult!.isRiskLow) ? ColorPalette.successColor : ColorPalette.failedColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
