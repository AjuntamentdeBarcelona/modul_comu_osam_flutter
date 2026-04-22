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
    // The actual background locking is handled by the native iOS/Android code.
    // We show a transparent dialog with a ModalBarrier here just to keep Flutter's navigator state in sync
    // and provide an extra layer of touch protection.
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      barrierLabel: "Native VC Barrier",
      useRootNavigator: true,
      pageBuilder: (context, animation, secondaryAnimation) => BlockSemantics(
        child: PopScope(
          canPop: false,
          child: Stack(
            children: [
              Positioned.fill(
                child: ModalBarrier(
                  color: Colors.transparent,
                  dismissible: false,
                ),
              ),
            ],
          ),
        ),
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
    // The actual background locking is handled by the native iOS/Android code.
    // We show a transparent dialog with a ModalBarrier here just to keep Flutter's navigator state in sync
    // and provide an extra layer of touch protection.
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      barrierLabel: "Native Rating Barrier",
      useRootNavigator: true,
      pageBuilder: (context, animation, secondaryAnimation) => BlockSemantics(
        child: PopScope(
          canPop: false,
          child: Stack(
            children: [
              Positioned.fill(
                child: ModalBarrier(
                  color: Colors.transparent,
                  dismissible: false,
                ),
              ),
            ],
          ),
        ),
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
