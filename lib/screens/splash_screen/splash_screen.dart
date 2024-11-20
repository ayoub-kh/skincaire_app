import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
            Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
              return Container(
                decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                  'assets/images/logo.png',
                  ),
                  fit: BoxFit.none,
                ),
                ),
              );
              },
            ),
            ),
        ],
      ),
    );
  }
}
