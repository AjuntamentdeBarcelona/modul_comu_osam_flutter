import 'dart:async';

import 'package:common_module_flutter_example/di/di.dart';
import 'package:common_module_flutter_example/model/language.dart';
import 'package:flutter/material.dart';
import 'package:osam_common_module_flutter/osam_common_module_flutter.dart';

import 'mixin/osam_version_checker.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> with OsamVersionChecker {
  DeviceInformation? _deviceInformation;
  AppInformation? _appInformation;
  AppLanguage? _currentLanguage;
  List<String> _subscribedTopics = [];
  bool _isLoading = true;
  StreamSubscription<List<String>>? _topicsSubscription;

  @override
  void initState() {
    super.initState();
    _loadInfo();
    _topicsSubscription =
        DI.settings.getSubscribedTopicsStream().listen((topics) {
      if (mounted) {
        setState(() {
          _subscribedTopics = topics;
        });
      }
    });
  }

  @override
  void dispose() {
    _topicsSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadInfo() async {
    try {
      final deviceInformation = await DI.osamRepository.deviceInformation();
      final appInformation = await DI.osamRepository.appInformation();
      final currentLanguage = DI.settings.getLanguage();
      final subscribedTopics = DI.settings.getSubscribedTopics();

      if (mounted) {
        setState(() {
          _deviceInformation = deviceInformation;
          _appInformation = appInformation;
          _currentLanguage = currentLanguage;
          _subscribedTopics = subscribedTopics;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading info: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Screen'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildInfoSection(
                  title: 'Device Information',
                  info: {
                    'Platform': _deviceInformation?.platformName,
                    'Version': _deviceInformation?.platformVersion,
                    'Model': _deviceInformation?.platformModel,
                  },
                ),
                _buildInfoSection(
                  title: 'App Information',
                  info: {
                    'App Name': _appInformation?.appName,
                    'Version Name': DI.settings.getAppVersionName(),
                    'Version Code': _appInformation?.appVersionCode,
                  },
                ),
                _buildInfoSection(
                  title: 'Language',
                  info: {
                    'Current Language': _currentLanguage?.toLanguageCode(),
                  },
                ),
                _buildInfoSection(
                  title: 'Subscribed Topics',
                  info: {
                    'Topics': _subscribedTopics.isEmpty
                        ? 'None'
                        : _subscribedTopics.join(', '),
                  },
                )
              ],
            ),
    );
  }

  Widget _buildInfoSection(
      {required String title, required Map<String, String?> info}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            ...info.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key),
                    Expanded(
                      child: Text(
                        entry.value ?? 'N/A',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
