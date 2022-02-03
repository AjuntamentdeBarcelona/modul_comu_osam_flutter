import 'dart:async';

import 'package:common_module_flutter_example/di/di.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';

// A Navigator observer that notifies RouteAwares of changes to state of their Route
final routeObserver = RouteObserver<PageRoute>();

mixin OsamVersionChecker<T extends StatefulWidget> on State<T> implements RouteAware {
  late StreamSubscription<FGBGType> subscription;

  @override
  void initState() {
    super.initState();
    subscription = FGBGEvents.stream.listen((event) async {
      if (event.toString() == "FGBGType.foreground") {
        await DI.osamRepository.checkForUpdates();
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
