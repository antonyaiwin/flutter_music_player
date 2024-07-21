import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../home_screen/home_screen.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        addPermissionListener(context);
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Permission Required',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'Please grant Music Player media files permission to play music',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                requestPermission(context);
              },
              child: const Center(
                child: Text('Allow Permission'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> requestPermission(BuildContext context) async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;
    if (android.version.sdkInt < 33) {
      var permissionStatus = await Permission.storage.request();

      if (permissionStatus == PermissionStatus.granted) {
        return true;
      } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
        if (context.mounted) {
          showDeniedBottomSheet(context, true);
        }
      } else if (permissionStatus == PermissionStatus.denied) {
        if (context.mounted) {
          showDeniedBottomSheet(context);
        }
      }
    } else {
      var permissionStatus = await Permission.audio.request();

      if (permissionStatus == PermissionStatus.granted) {
        return true;
      } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
        if (context.mounted) {
          showDeniedBottomSheet(context, true);
        }
      } else if (permissionStatus == PermissionStatus.denied) {
        if (context.mounted) {
          showDeniedBottomSheet(context);
        }
      }
    }
    return false;
  }

  void showDeniedBottomSheet(BuildContext context,
      [bool isPermanentlyDenied = false]) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Permission Required!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            const Text(
                'We need Storage permission to access music files in your device. Please grant the permission.'),
            if (isPermanentlyDenied)
              const Text(
                  'You will need to open application settings and grand the permission manually.'),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                if (isPermanentlyDenied) {
                  openAppSettings();
                } else {
                  requestPermission(context);
                }
              },
              child: Center(
                child: Text(
                    isPermanentlyDenied ? 'Open Settings' : 'Allow Permission'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addPermissionListener(BuildContext context) async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;
    if (android.version.sdkInt < 33) {
      Permission.storage.onGrantedCallback(() {
        navigateToHome(context);
      });
    } else {
      Permission.audio.onGrantedCallback(() {
        navigateToHome(context);
      });
    }
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }
}
