import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_booklibrary/src/auth/welcome_screen.dart';
import 'package:flutter_booklibrary/src/services/network_helper.dart';
import 'firebase_options.dart'; // Make sure this is configured if using FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NetworkHelper.initialize(
      baseUrl: 'https://booklibrary-flutterflow-production.up.railway.app');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WelcomeScreen(),
    );
  }
}
