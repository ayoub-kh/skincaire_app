// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:skincaire_app/screens/splash_screen/splash_screen.dart';
import 'package:skincaire_app/screens/splash_screen/start_screen.dart';
import 'package:skincaire_app/screens/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkinacAIre App',
      theme: ThemeData(
  
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
