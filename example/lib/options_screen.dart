import 'dart:io' show Platform;

import 'package:common_module_flutter_example/di/di.dart';
import 'package:common_module_flutter_example/model/language.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';

import 'data/remote/client_builder.dart';
import 'mixin/osam_version_checker.dart';

enum PopupMode { INFO, LAZY, FORCE }

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> with OsamVersionChecker {
  late bool _showRatingPopup;
  late bool _showVersionControlPopup;
  late AppLanguage _currentLanguage;
  late AppLanguage _selectedLanguage;
  late TextEditingController _appVersionNameController;
  late TextEditingController _appVersionCodeController;
  late PopupMode _selectedMode;
  late String _endPoint;
  late String _path;

  @override
  void initState() {
    super.initState();
    _showRatingPopup = DI.settings.getShowRatingPopup();
    _showVersionControlPopup = DI.settings.getShowVersionControlPopup();
    _currentLanguage = DI.settings.getLanguage();
    _selectedLanguage = _currentLanguage;
    _appVersionNameController =
        TextEditingController(text: DI.settings.getAppVersionName());
    _appVersionCodeController =
        TextEditingController(text: DI.settings.getAppVersionCode());
    _endPoint = 'https://dev-osam-modul-comu.dtibcn.cat/';
    _path = '/api/version';

    // Initialize selected mode from settings
    final savedMode = DI.settings.getPopupMode();
    _selectedMode = PopupMode.values.firstWhere(
      (e) => e.toString().split('.').last == savedMode,
      orElse: () => PopupMode.INFO,
    );
  }

  @override
  void dispose() {
    _appVersionNameController.dispose();
    _appVersionCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Options Screen'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Language',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  RadioGroup<AppLanguage>.builder(
                    direction: Axis.horizontal,
                    horizontalAlignment: MainAxisAlignment.center,
                    groupValue: _selectedLanguage,
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value!;
                      });
                    },
                    items: const [
                      AppLanguage.CA,
                      AppLanguage.ES,
                      AppLanguage.EN,
                    ],
                    itemBuilder: (item) =>
                        RadioButtonBuilder(item.toLanguageCode()),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    child: Text("Save language".toUpperCase()),
                    onPressed: () async {
                      await DI.settings.setLanguage(_selectedLanguage);
                      setState(() {
                        _currentLanguage = _selectedLanguage;
                        DI.osamRepository.changeLanguageEvent();
                      });
                      _showToast(context, 'Language saved!');
                    },
                  )
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rating and control version Pop-ups',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Mode Option',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  RadioGroup<PopupMode>.builder(
                    direction: Axis.horizontal,
                    horizontalAlignment: MainAxisAlignment.center,
                    groupValue: _selectedMode,
                    onChanged: (value) {
                      setState(() {
                        _selectedMode = value!;
                      });
                    },
                    items: const [
                      PopupMode.INFO,
                      PopupMode.LAZY,
                      PopupMode.FORCE,
                    ],
                    itemBuilder: (item) =>
                        RadioButtonBuilder(item.toString().split('.').last),
                  ),
                  const SizedBox(height: 8.0),
                  CheckboxListTile(
                    title: const Text('Show Rating Pop-up'),
                    value: _showRatingPopup,
                    onChanged: (bool? value) {
                      if (value != null) {
                        setState(() {
                          _showRatingPopup = value;
                        });
                      }
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Show Version Control Pop-up'),
                    value: _showVersionControlPopup,
                    onChanged: (bool? value) {
                      if (value != null) {
                        setState(() {
                          _showVersionControlPopup = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    child: Text("Apply Changes".toUpperCase()),
                    onPressed: () async {
                      await DI.settings.setShowRatingPopup(_showRatingPopup);
                      await DI.settings
                          .setShowVersionControlPopup(_showVersionControlPopup);
                      await DI.settings.setPopupMode(
                          _selectedMode.toString().split('.').last);

                      await performPutRequest(
                        _endPoint,
                        _path,
                        createBodyForPutRequest(),
                      );
                      _showToast(context, 'Changes applied!');
                    },
                  ),
                ],
              ),
            ),
          ),
          // COMMENTED UNTIL THE FUTURE COMMON MODULE PASSES THE VERSIONS
          // AS A PARAMETER, SO THIS SECTION WILL WORK AND BE USEFUL

          /*Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'App Version',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _appVersionNameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter App Version Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _appVersionCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Enter App Version Code',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    child: Text("Save Versions".toUpperCase()),
                    onPressed: () async {
                      await DI.settings
                          .setAppVersionName(_appVersionNameController.text);
                      await DI.settings
                          .setAppVersionCode(_appVersionCodeController.text);
                      _showToast(context, 'App version name and code saved!');
                      DI.osamRepository.subscribeToCustomTopic();
                    },
                  ),
                ],
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  void _showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(content: Text(text)));
  }

  String getPlatform() {
    if (Platform.isAndroid) {
      return 'ANDROID';
    } else if (Platform.isIOS) {
      return 'IOS';
    }
    return 'UNKNOWN';
  }

  Map<String, dynamic> createBodyForPutRequest() {
    var appId = 204;
    if (getPlatform() == 'IOS') {
      appId = 203;
    }
    return {
      "id": 171,
      "appId": appId,
      "packageName": "cat.bcn.commonmodule.flutter.example",
      "versionCode": _appVersionCodeController.text,
      "versionName": _appVersionNameController.text,
      "startDate": 1763424000,
      "endDate": 1782514800,
      "comparisonMode": _selectedMode.toString().split('.').last,
      "affects_previous_versions": false,
      "title": {
        "es": "Nueva versión",
        "en": "New version",
        "ca": "Nova versió"
      },
      "message": {
        "es": "Hay una nueva versión disponible",
        "en": "There is a new version available",
        "ca": "Hi ha una nova versió disponible"
      },
      "ok": {"es": "Ok", "en": "Ok", "ca": "Ok"},
      "cancel": {"es": "Cancelar", "en": "Cancel", "ca": "Cancel·lar"},
      "url": "https://www.google.com",
    };
  }
}
