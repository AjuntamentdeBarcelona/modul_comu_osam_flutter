import 'package:common_module_flutter_example/actions_screen.dart';
import 'package:common_module_flutter_example/di/di.dart';
import 'package:common_module_flutter_example/info_screen.dart';
import 'package:common_module_flutter_example/options_screen.dart';
import 'package:flutter/material.dart';

import 'mixin/osam_version_checker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with OsamVersionChecker {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const ActionsScreen(),
    const InfoScreen(),
    const OptionsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVersionControl();
      DI.osamRepository.firstTimeOrUpdateEvent();
    });
  }

  Future<void> _checkVersionControl() async {
    try {
      final bool needToShowControlVersionPopUp =
          DI.settings.getShowVersionControlPopup();
      if (needToShowControlVersionPopUp) {
        await DI.osamRepository.checkForUpdates();
      }
      await DI.osamRepository.changeLanguageEvent();
    } catch (e) {
      debugPrint("Error checking version control: $e");
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Actions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Options',
          ),
        ],
      ),
    );
  }
}
