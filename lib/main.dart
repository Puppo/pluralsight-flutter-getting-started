import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hello_flutter/screens/bmi_screen.dart';
import 'package:hello_flutter/screens/intro_screen.dart';

Future main(List<String> args) async {
  await dotenv.load(fileName: ".env");
  runApp(const GlobeApp());
}

class GlobeApp extends StatelessWidget {
  const GlobeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      routes: {
        '/': (context) => const IntroScreen(),
        '/bmi': (context) => BmiScreen()
      },
    );
  }
}
