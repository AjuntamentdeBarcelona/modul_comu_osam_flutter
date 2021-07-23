import 'package:common_module_flutter/internal/device/DevicePlatform.dart';
import 'package:common_module_flutter/internal/interfaces.dart';
import 'package:common_module_flutter/internal/remote/Remote.dart';
import 'package:common_module_flutter/internal/remote/dto/Version.dart';
import 'package:package_info/package_info.dart';

class VersionControlRepositoryImpl extends VersionControlRepository {
  final Remote _remote;
  final DevicePlatform _devicePlatform;

  VersionControlRepositoryImpl(
    this._remote,
    this._devicePlatform,
  );

  @override
  Future<Version> getVersionControl() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int version = int.parse(packageInfo.buildNumber);
    return _remote.versionControl(
        packageInfo.packageName, _devicePlatform.getPlatformName(), version);
  }
}
