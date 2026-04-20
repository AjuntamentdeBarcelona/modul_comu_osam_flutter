import 'package:flutter/material.dart';
import 'package:osam_common_module_flutter/osam_common_module_flutter.dart';

/// A wrapper for showing different types of alerts
class AlertWrapper {
  final BuildContext context;

  AlertWrapper(this.context);

  /// Shows a forced version control dialog (no close, no negative, no checkbox)
  Future<VersionControlResult?> showVersionControlForce({
    required Version version,
    required Language language,
    bool isDarkMode = false,
    bool applyComModStyles = false,
  }) {
    return UIHelper.showVersionDialog(
      context: context,
      version: version,
      language: language,
      showNegative: false,
      showClose: false,
      showCheckBox: false,
      isDarkMode: isDarkMode,
      applyComModStyles: applyComModStyles,
    );
  }

  /// Shows a lazy version control dialog (with close, negative, and checkbox)
  Future<VersionControlResult?> showVersionControlLazy({
    required Version version,
    required Language language,
    bool isDarkMode = false,
    bool applyComModStyles = false,
  }) {
    return UIHelper.showVersionDialog(
      context: context,
      version: version,
      language: language,
      isDarkMode: isDarkMode,
      applyComModStyles: applyComModStyles,
    );
  }

  /// Shows an info version control dialog (with close, but no negative)
  Future<VersionControlResult?> showVersionControlInfo({
    required Version version,
    required Language language,
    bool isDarkMode = false,
    bool applyComModStyles = false,
  }) {
    return UIHelper.showVersionDialog(
      context: context,
      version: version,
      language: language,
      showNegative: false,
      isDarkMode: isDarkMode,
      applyComModStyles: applyComModStyles,
    );
  }

  /// Triggers the native version control popup flow
  Future<VersionControlResponse> showVersionControlNative({
    required OSAM osam,
    required Language language,
    bool isDarkMode = false,
    bool applyComModStyles = false,
  }) async {
    // Show a transparent barrier to prevent background interaction
    // while the native version control popup is being requested/shown.
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (context) => const PopScope(
        canPop: false,
        child: SizedBox.expand(),
      ),
    );

    try {
      final response = await osam.versionControl(
        language: language,
        isDarkMode: isDarkMode,
        applyComModStyles: applyComModStyles,
      );
      return response;
    } finally {
      // Close the barrier
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  /// Triggers the rating popup flow
  Future<RatingControlResponse> showRating({
    required OSAM osam,
    required Language language,
    bool isDarkMode = false,
  }) async {
    // Show a transparent barrier to prevent background interaction
    // while the native rating popup is being requested/shown.
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (context) => const PopScope(
        canPop: false,
        child: SizedBox.expand(),
      ),
    );

    try {
      final response = await osam.rating(
        language: language,
        isDarkMode: isDarkMode,
      );
      return response;
    } finally {
      // Close the barrier
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
