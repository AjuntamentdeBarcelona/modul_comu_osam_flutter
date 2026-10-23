import 'package:flutter/widgets.dart';

import '../di/di.dart';

// A Navigator observer that notifies RouteAwares of changes to state of their Route
final routeObserver = RouteObserver<PageRoute>();

mixin OsamVersionChecker<T extends StatefulWidget> on State<T>
    implements RouteAware {
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onResume: () async {
        print("OsamVersionChecker: Received event: foreground");
        // Only check for updates if the setting is enabled
        if (DI.settings.getShowVersionControlPopup()) {
          print("OsamVersionChecker: Triggering checkForUpdates in foreground");
          await DI.osamRepository.checkForUpdates();
        } else {
          print(
              "OsamVersionChecker: Version control popup is disabled in settings");
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {}

  @override
  void didPopNext() {}

  @override
  void didPush() {}

  @override
  void didPushNext() {}
}
