import 'package:common_module_flutter/osam.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Common Module Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with OsamVersionChecker {
  late AppLanguage _currentLanguage;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
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
                ],
              ),
            ),
    );
  }

  void _onVersionControl() async {
    final result = await DI.osamRepository.checkForUpdates();

    switch (result) {
      case VersionControlResponse.ACCEPTED:
        break;
      case VersionControlResponse.DISMISSED:
        break;
      case VersionControlResponse.CANCELLED:
        break;
      case VersionControlResponse.ERROR:
        break;
    }
  }

  void _onRating() async {
    final result = await DI.osamRepository.checkRating();

    switch (result) {
      case RatingControlResponse.ACCEPTED:
        break;
      case RatingControlResponse.DISMISSED:
        break;
      case RatingControlResponse.CANCELLED:
        break;
      case RatingControlResponse.LATER:
        break;
      case RatingControlResponse.ERROR:
        break;
    }
  }
}
