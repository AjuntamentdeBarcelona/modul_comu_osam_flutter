import 'dart:async';

import 'package:common_module_flutter_example/di/di.dart';
import 'package:common_module_flutter_example/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start a timer for 1.5 seconds
    Timer(const Duration(milliseconds: 1500), () {
      // After the timer, handle the navigation
      _handleNavigation();
    });
  }

  Future<void> _handleNavigation() async {
    final String appVersionName = DI.settings.getAppVersionName();
    final String appVersionCode = DI.settings.getAppVersionCode();
    // Directly get the settings
    final bool needToShowRatingPopUp = DI.settings.getShowRatingPopup();
    final bool needToShowControlVersionPopUp =
        DI.settings.getShowVersionControlPopup();

    if (appVersionName.isEmpty) {
      DI.settings.setAppVersionName("2.3.0");
    }
    if (appVersionCode.isEmpty) {
      DI.settings.setAppVersionCode("20251029");
    }
    if (needToShowControlVersionPopUp) {
      await DI.osamRepository.checkForUpdates();
    }
    if (needToShowRatingPopUp) {
      await DI.osamRepository.checkRating();
    }

    // After handling pop-ups, navigate to the home screen.
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF2C3E50),
      body: Center(
        child: Text(
          'COMMON MODULE DEMO APP',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
