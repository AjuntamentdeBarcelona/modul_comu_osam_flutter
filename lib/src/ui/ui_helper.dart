import 'package:flutter/material.dart';
import 'package:osam_common_module_flutter/src/model/language.dart';
import 'package:osam_common_module_flutter/src/model/version.dart';
import 'package:osam_common_module_flutter/src/model/version_control_response.dart';
import 'package:osam_common_module_flutter/src/model/version_control_result.dart';

class UIHelper {
  static const Color veryDarkGrey = Color(0xFF1C1C1C);
  static const Color mediumLightGrey = Color(0xFFB0B0B0);

  static Future<VersionControlResult?> showVersionDialog({
    required BuildContext context,
    required Version version,
    required Language language,
    bool showNegative = true,
    bool showClose = true,
    bool showCheckBox = true,
    bool isDarkMode = false,
    bool applyComModStyles = false,
    Widget? appIcon,
  }) {
    return showGeneralDialog<VersionControlResult>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      barrierLabel: "OSAM Version Control",
      useRootNavigator: true,
      pageBuilder: (context, animation, secondaryAnimation) {
        return BlockSemantics(
          child: PopScope(
            canPop: showClose,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              if (!showClose) return;
              Navigator.of(context).pop(
                VersionControlResult(
                  response: VersionControlResponse.DISMISSED,
                  isCheckBoxChecked: false,
                ),
              );
            },
            child: Stack(
              children: [
                // ModalBarrier captures and handles touches on the background
                Positioned.fill(
                  child: ModalBarrier(
                    color: Colors.transparent,
                    dismissible: showClose,
                    onDismiss: () => Navigator.of(context).pop(
                      VersionControlResult(
                        response: VersionControlResponse.DISMISSED,
                        isCheckBoxChecked: false,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: OSAMDialog(
                    version: version,
                    language: language,
                    showNegative: showNegative,
                    showClose: showClose,
                    showCheckBox: showCheckBox,
                    isDarkMode: isDarkMode,
                    applyComModStyles: applyComModStyles,
                    appIcon: appIcon,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((result) =>
        result ??
        VersionControlResult(
          response: VersionControlResponse.DISMISSED,
          isCheckBoxChecked: false,
        ));
  }
}

class OSAMDialog extends StatefulWidget {
  final Version version;
  final Language language;
  final bool showNegative;
  final bool showClose;
  final bool showCheckBox;
  final bool isDarkMode;
  final bool applyComModStyles;
  final Widget? appIcon;

  const OSAMDialog({
    super.key,
    required this.version,
    required this.language,
    required this.showNegative,
    required this.showClose,
    required this.showCheckBox,
    required this.isDarkMode,
    this.applyComModStyles = false,
    this.appIcon,
  });

  @override
  State<OSAMDialog> createState() => _OSAMDialogState();
}

class _OSAMDialogState extends State<OSAMDialog> {
  bool _dontShowAgain = false;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor;
    final Color textColor;
    final Color primaryButtonColor;
    final Color primaryButtonTextColor;
    final Color secondaryButtonTextColor;
    final BorderSide? secondaryButtonBorder;
    final Color checkboxActiveColor;
    final Color checkboxCheckColor;
    final Color closeIconColor;

    if (widget.applyComModStyles) {
      backgroundColor =
          widget.isDarkMode ? UIHelper.veryDarkGrey : Colors.white;
      textColor = widget.isDarkMode ? Colors.white : Colors.black;
      primaryButtonColor =
          widget.isDarkMode ? Colors.white : UIHelper.veryDarkGrey;
      primaryButtonTextColor =
          widget.isDarkMode ? UIHelper.veryDarkGrey : Colors.white;
      secondaryButtonTextColor =
          widget.isDarkMode ? Colors.white : UIHelper.veryDarkGrey;
      secondaryButtonBorder = BorderSide(
        color: widget.isDarkMode ? Colors.white : UIHelper.mediumLightGrey,
      );
      checkboxActiveColor =
          widget.isDarkMode ? Colors.white : UIHelper.veryDarkGrey;
      checkboxCheckColor =
          widget.isDarkMode ? UIHelper.veryDarkGrey : Colors.white;
      closeIconColor = widget.isDarkMode ? Colors.white : Colors.black;
    } else {
      backgroundColor = widget.isDarkMode ? Colors.black : Colors.white;
      textColor = widget.isDarkMode ? Colors.white : Colors.black;
      primaryButtonColor = Colors.transparent;
      primaryButtonTextColor = Colors.grey[800]!; // Approx DKGRAY
      secondaryButtonTextColor = Colors.grey[800]!;
      secondaryButtonBorder = null;
      checkboxActiveColor = Theme.of(context).primaryColor;
      checkboxCheckColor = Colors.white;
      closeIconColor = Colors.grey[800]!;
    }

    return Dialog(
      alignment: Alignment.center,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 280,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.showClose)
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.close,
                          color: closeIconColor,
                          size: 24,
                        ),
                        onPressed: () => Navigator.of(context).pop(
                          VersionControlResult(
                            response: VersionControlResponse.DISMISSED,
                            isCheckBoxChecked: _dontShowAgain,
                          ),
                        ),
                      ),
                    ),
                  if (widget.appIcon != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: widget.appIcon,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Semantics(
                      header: true,
                      child: Text(
                        widget.version.title.localize(widget.language),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      widget.version.message.localize(widget.language),
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (widget.showCheckBox &&
                      widget.version.checkBoxDontShowAgain.isCheckBoxVisible)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _dontShowAgain = !_dontShowAgain;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Theme(
                              data: ThemeData(
                                unselectedWidgetColor: UIHelper.mediumLightGrey,
                              ),
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _dontShowAgain,
                                  activeColor: checkboxActiveColor,
                                  checkColor: checkboxCheckColor,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  onChanged: (value) {
                                    setState(() {
                                      _dontShowAgain = value ?? false;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                widget.version.checkBoxDontShowAgain.text
                                    .localize(widget.language),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: widget.applyComModStyles
                          ? ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(
                                VersionControlResult(
                                  response: VersionControlResponse.ACCEPTED,
                                  isCheckBoxChecked: _dontShowAgain,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryButtonColor,
                                foregroundColor: primaryButtonTextColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                widget.version.ok.localize(widget.language),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : TextButton(
                              onPressed: () => Navigator.of(context).pop(
                                VersionControlResult(
                                  response: VersionControlResponse.ACCEPTED,
                                  isCheckBoxChecked: _dontShowAgain,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: primaryButtonTextColor,
                              ),
                              child: Text(
                                widget.version.ok.localize(widget.language),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                    ),
                  ),
                  if (widget.showNegative)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: widget.applyComModStyles
                            ? OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(
                                  VersionControlResult(
                                    response: VersionControlResponse.CANCELLED,
                                    isCheckBoxChecked: _dontShowAgain,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: secondaryButtonBorder,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  foregroundColor: secondaryButtonTextColor,
                                ),
                                child: Text(
                                  widget.version.cancel
                                      .localize(widget.language),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : TextButton(
                                onPressed: () => Navigator.of(context).pop(
                                  VersionControlResult(
                                    response: VersionControlResponse.CANCELLED,
                                    isCheckBoxChecked: _dontShowAgain,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  foregroundColor: secondaryButtonTextColor,
                                ),
                                child: Text(
                                  widget.version.cancel
                                      .localize(widget.language),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
