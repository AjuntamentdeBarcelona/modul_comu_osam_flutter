import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';

import '../di/di.dart';

// A Navigator observer that notifies RouteAwares of changes to state of their Route
final routeObserver = RouteObserver<PageRoute>();

mixin OsamVersionChecker<T extends StatefulWidget> on State<T>
    implements RouteAware {
  late StreamSubscription<FGBGType> subscription;

  @override
  void initState() {
    super.initState();
    subscription = FGBGEvents.instance.stream.listen((event) async {
      if (event == FGBGType.foreground) {
        // Only check for updates if the setting is enabled
        if (DI.settings.getShowVersionControlPopup()) {
          await DI.osamRepository.checkForUpdates();
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    subscription.cancel(); // Cancel subscription to prevent memory leaks
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
