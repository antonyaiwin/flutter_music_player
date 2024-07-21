import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/core/constants/image_constants.dart';
import 'package:flutter_music_player/view/home_screen/home_screen.dart';
import 'package:flutter_music_player/view/permission_screen/permission_screen.dart';
import 'package:permission_handler/permission_handler.dart';

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
          () async {
            var hasPermission = await isPermissionGranted();
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => hasPermission
                      ? const HomeScreen()
                      : const PermissionScreen(),
                ),
              );
            }
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

  Future<bool> isPermissionGranted() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;
    if (android.version.sdkInt < 33) {
      if (await Permission.storage.isGranted) {
        return true;
        // setState(() {
        //   permissionGranted = true;
        // });
      } /* else if (await Permission.storage.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.audio.request().isDenied) {
        setState(() {
          permissionGranted = false;
        });
      } */
    } else {
      if (await Permission.audio.isGranted) {
        return true;
        // setState(() {
        //   permissionGranted = true;
        // });
      } /*  else if (await Permission.photos.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.photos.request().isDenied) {
        setState(() {
          permissionGranted = false;
        });
      } */
    }
    return false;
  }
}
