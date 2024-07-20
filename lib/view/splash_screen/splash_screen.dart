import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_music_player/core/constants/image_constants.dart';
import 'package:flutter_music_player/view/home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0.0;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        setState(() {
          opacity = 1.0;
        });
        Timer(
          const Duration(seconds: 3),
          () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
        );
      },
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ...List.generate(
                6,
                (index) => Colors.purple[(index + 3) * 100]!,
              ),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            tileMode: TileMode.repeated,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: opacity,
            duration: const Duration(milliseconds: 1500),
            child: Image.asset(
              ImageConstants.appIconForeground,
              height: 250,
              width: 250,
            ),
          ),
        ),
      ),
    );
  }
}
