import 'package:osam_common_module_flutter/src/model/version_control_response.dart';

/// Result of the version control dialog
class VersionControlResult {
  /// The user action with the version control popup
  final VersionControlResponse response;

  /// Whether the "Don't show again" checkbox was checked
  final bool isCheckBoxChecked;

  VersionControlResult({
    required this.response,
    required this.isCheckBoxChecked,
  });
}
