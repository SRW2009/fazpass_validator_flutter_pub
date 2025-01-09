import 'package:devicevalidator/pages/input_cred_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Validator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          primary: const Color(0xFF5fc2c8)
        ),
        useMaterial3: true,
      ),
      home: const InputCredPage(),
    );
  }
}
