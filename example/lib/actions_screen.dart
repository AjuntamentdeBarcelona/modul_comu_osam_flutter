import 'package:flutter/material.dart';
import 'package:osam_common_module_flutter/osam_common_module_flutter.dart';

import 'di/di.dart';

class ActionsScreen extends StatefulWidget {
  const ActionsScreen({super.key});

  @override
  ActionsScreenState createState() => ActionsScreenState();
}

class ActionsScreenState extends State<ActionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actions screen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Trigger Actions",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        child: Text("Version control".toUpperCase()),
                        onPressed: () => _onVersionControl(),
                      ),
                      ElevatedButton(
                        child: Text("Rating".toUpperCase()),
                        onPressed: () => _onRating(),
                      ),
                      ElevatedButton(
                        child: Text("Change Language Event".toUpperCase()),
                        onPressed: () => _onChangeLanguageEvent(context),
                      ),
                      ElevatedButton(
                        child: Text("First Time or Update Event".toUpperCase()),
                        onPressed: () => _onFirstTimeOrUpdateEvent(context),
                      ),
                      ElevatedButton(
                        child: Text("Subscribe To Custom Topic".toUpperCase()),
                        onPressed: () => _onSubscribeToCustomTopic(context),
                      ),
                      ElevatedButton(
                        child:
                            Text("Unsubscribe To Custom Topic".toUpperCase()),
                        onPressed: () => _onUnsubscribeToCustomTopic(context),
                      ),
                      ElevatedButton(
                        child: Text("Get FCM Token".toUpperCase()),
                        onPressed: () => _onGetFCMToken(context),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onVersionControl() async {
    final result = await DI.osamRepository.checkForUpdates();

    if (mounted) {
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

    if (mounted) {
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

  void _onChangeLanguageEvent(BuildContext context) async {
    final result = await DI.osamRepository.changeLanguageEvent();
    if (context.mounted) {
      switch (result) {
        case AppLanguageResponse.SUCCESS:
          _showToast(context, AppLanguageResponse.SUCCESS.name);
          break;
        case AppLanguageResponse.UNCHANGED:
          _showToast(context, AppLanguageResponse.UNCHANGED.name);
          break;
        case AppLanguageResponse.ERROR:
          _showToast(context, AppLanguageResponse.ERROR.name);
          break;
      }
    }
  }

  void _onFirstTimeOrUpdateEvent(BuildContext context) async {
    final result = await DI.osamRepository.firstTimeOrUpdateEvent();
    if (context.mounted) {
      switch (result) {
        case AppLanguageResponse.SUCCESS:
          _showToast(context, AppLanguageResponse.SUCCESS.name);
          break;
        case AppLanguageResponse.UNCHANGED:
          _showToast(context, AppLanguageResponse.UNCHANGED.name);
          break;
        case AppLanguageResponse.ERROR:
          _showToast(context, AppLanguageResponse.ERROR.name);
          break;
      }
    }
  }

  void _onSubscribeToCustomTopic(BuildContext context) async {
    final result = await DI.osamRepository.subscribeToCustomTopic();
    if (context.mounted) {
      switch (result) {
        case SubscriptionResponse.accepted:
          _showToast(context, SubscriptionResponse.accepted.name);
          break;
        case SubscriptionResponse.error:
          _showToast(context, SubscriptionResponse.error.name);
          break;
      }
    }
  }

  void _onUnsubscribeToCustomTopic(BuildContext context) async {
    final result = await DI.osamRepository.unsubscribeToCustomTopic();
    if (context.mounted) {
      switch (result) {
        case SubscriptionResponse.accepted:
          _showToast(context, SubscriptionResponse.accepted.name);
          break;
        case SubscriptionResponse.error:
          _showToast(context, SubscriptionResponse.error.name);
          break;
      }
    }
  }

  void _onGetFCMToken(BuildContext context) async {
    final result = await DI.osamRepository.getFCMToken();
    if (context.mounted) {
      switch (result) {
        case Success(token: final token):
          _showToast(context, 'SUCCESS: $token');
        case Error(error: final error):
          _showToast(context, 'ERROR: ${error.toString()}');
      }
    }
  }

  void _showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(content: Text(text)));
  }
}
