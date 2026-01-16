import 'dart:async';

import 'package:common_module_flutter_example/di/di.dart';
import 'package:common_module_flutter_example/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:osam_common_module_flutter/osam_common_module_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Start a timer for 1.5 seconds
    Timer(const Duration(milliseconds: 1500), () {
      // After the timer, handle the navigation
      _handleNavigation();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _handleNavigation();
    }
  }

  Future<void> _handleNavigation() async {
    if (_isChecking) return;
    _isChecking = true;

    try {
      final String appVersionName = DI.settings.getAppVersionName();
      final String appVersionCode = DI.settings.getAppVersionCode();
      // Directly get the settings
      final bool needToShowRatingPopUp = DI.settings.getShowRatingPopup();
      final bool needToShowControlVersionPopUp =
          DI.settings.getShowVersionControlPopup();
      final String popupMode = DI.settings.getPopupMode();

      if (appVersionName.isEmpty) {
        DI.settings.setAppVersionName("");
      }
      if (appVersionCode.isEmpty) {
        DI.settings.setAppVersionCode("");
      }

      bool shouldNavigate = true;

      if (needToShowControlVersionPopUp) {
        final VersionControlResponse response =
            await DI.osamRepository.checkForUpdates();
        if (popupMode == "FORCE" &&
            (response == VersionControlResponse.ACCEPTED ||
                response == VersionControlResponse.CANCELLED)) {
          shouldNavigate = false;
        }
      }
      if (needToShowRatingPopUp) {
        final RatingControlResponse response =
            await DI.osamRepository.checkRating();
        if (popupMode == "FORCE" &&
            response == RatingControlResponse.ACCEPTED) {
          shouldNavigate = false;
        }
      }

      // After handling pop-ups, navigate to the home screen.
      if (mounted && shouldNavigate) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen(),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error in splash navigation: $e");
      // In case of error, navigate to home to avoid stuck splash
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen(),
          ),
        );
      }
    } finally {
      _isChecking = false;
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
