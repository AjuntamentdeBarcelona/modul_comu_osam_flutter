import 'package:osam_common_module_flutter/osam_common_module_flutter.dart';
import 'package:common_module_flutter_example/mixin/osam_version_checker.dart';
import 'package:common_module_flutter_example/model/language.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';

import 'di/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DI.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Common Module Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Common Module Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with OsamVersionChecker {
  late AppLanguage _currentLanguage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!DI.settings.hasLanguage()) {
        await DI.settings.setLanguage(AppLanguage.CA);
        _currentLanguage = DI.settings.getLanguage();
      } else {
        _currentLanguage = DI.settings.getLanguage();
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Language"),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: RadioGroup<AppLanguage>.builder(
                          groupValue: _currentLanguage,
                          onChanged: (value) async {
                            await DI.settings.setLanguage(value!);
                            _currentLanguage = DI.settings.getLanguage();
                            setState(() {});
                          },
                          items: const [
                            AppLanguage.CA,
                            AppLanguage.ES,
                            AppLanguage.EN
                          ],
                          itemBuilder: (item) => RadioButtonBuilder(
                            item.toLanguageCode(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    child: Text("Version control".toUpperCase()),
                    onPressed: () => _onVersionControl(),
                  ),
                  ElevatedButton(
                    child: Text("Rating".toUpperCase()),
                    onPressed: () => _onRating(),
                  ),
                  ElevatedButton(
                    child: Text("Device Information".toUpperCase()),
                    onPressed: () => _onDeviceInformation(context),
                  ),
                  ElevatedButton(
                    child: Text("App Information".toUpperCase()),
                    onPressed: () => _onAppInformation(context),
                  ),
                ],
              ),
            ),
    );
  }

  void _onVersionControl() async {
    final result = await DI.osamRepository.checkForUpdates();

    if (context.mounted) {
      switch (result) {
        case VersionControlResponse.ACCEPTED:
          _showToast(context, VersionControlResponse.ACCEPTED.name);
          break;
        case VersionControlResponse.DISMISSED:
          _showToast(context, VersionControlResponse.DISMISSED.name);
          break;
        case VersionControlResponse.CANCELLED:
          _showToast(context, VersionControlResponse.CANCELLED.name);
          break;
        case VersionControlResponse.ERROR:
          _showToast(context, VersionControlResponse.ERROR.name);
          break;
      }
    }
  }

  void _onRating() async {
    final result = await DI.osamRepository.checkRating();

    if (context.mounted) {
      switch (result) {
        case RatingControlResponse.ACCEPTED:
          _showToast(context, RatingControlResponse.ACCEPTED.name);
          break;
        case RatingControlResponse.DISMISSED:
          _showToast(context, RatingControlResponse.DISMISSED.name);
          break;
        case RatingControlResponse.ERROR:
          _showToast(context, RatingControlResponse.ERROR.name);
          break;
      }
    }
  }

  void _onDeviceInformation(BuildContext context) async {
    final result = await DI.osamRepository.deviceInformation();
    if (context.mounted) {
      _showToast(context, result.platformName);
      _showToast(context, result.platformVersion);
      _showToast(context, result.platformModel);
    }
  }

  void _onAppInformation(BuildContext context) async {
    final result = await DI.osamRepository.appInformation();
    if (context.mounted) {
      _showToast(context, result.appName);
      _showToast(context, result.appVersionName);
      _showToast(context, result.appVersionCode);
    }
  }

  void _showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(content: Text(text)));
  }
}
