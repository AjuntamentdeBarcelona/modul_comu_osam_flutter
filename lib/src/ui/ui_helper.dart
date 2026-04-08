import 'package:flutter/material.dart';
import 'package:osam_common_module_flutter/src/model/language.dart';
import 'package:osam_common_module_flutter/src/model/version.dart';
import 'package:osam_common_module_flutter/src/model/version_control_response.dart';

class UIHelper {
  static const Color veryDarkGrey = Color(0xFF1C1C1C);
  static const Color mediumLightGrey = Color(0xFFB0B0B0);

  static Future<VersionControlResponse?> showVersionDialog({
    required BuildContext context,
    required Version version,
    required Language language,
    bool showNegative = true,
    bool showClose = true,
    bool showCheckBox = true,
    bool isDarkMode = false,
    Widget? appIcon,
  }) {
    return showDialog<VersionControlResponse>(
      context: context,
      barrierDismissible: showClose,
      builder: (BuildContext context) {
        return OSAMDialog(
          version: version,
          language: language,
          showNegative: showNegative,
          showClose: showClose,
          showCheckBox: showCheckBox,
          isDarkMode: isDarkMode,
          appIcon: appIcon,
        );
      },
    );
  }
}

class OSAMDialog extends StatefulWidget {
  final Version version;
  final Language language;
  final bool showNegative;
  final bool showClose;
  final bool showCheckBox;
  final bool isDarkMode;
  final Widget? appIcon;

  const OSAMDialog({
    super.key,
    required this.version,
    required this.language,
    required this.showNegative,
    required this.showClose,
    required this.showCheckBox,
    required this.isDarkMode,
    this.appIcon,
  });

  @override
  State<OSAMDialog> createState() => _OSAMDialogState();
}

class _OSAMDialogState extends State<OSAMDialog> {
  bool _dontShowAgain = false;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        widget.isDarkMode ? UIHelper.veryDarkGrey : Colors.white;
    final Color textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final Color primaryButtonColor =
        widget.isDarkMode ? Colors.white : UIHelper.veryDarkGrey;
    final Color primaryButtonTextColor =
        widget.isDarkMode ? UIHelper.veryDarkGrey : Colors.white;

    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showClose)
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.close,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                      size: 24,
                    ),
                    onPressed: () => Navigator.of(context)
                        .pop(VersionControlResponse.CANCELLED),
                  ),
                ),
              if (widget.appIcon != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: widget.appIcon,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.version.title.localize(widget.language),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  widget.version.message.localize(widget.language),
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (widget.showCheckBox &&
                  widget.version.checkBoxDontShowAgain.isCheckBoxVisible)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Theme(
                        data: ThemeData(
                          unselectedWidgetColor: UIHelper.mediumLightGrey,
                        ),
                        child: Checkbox(
                          value: _dontShowAgain,
                          activeColor: widget.isDarkMode
                              ? Colors.white
                              : UIHelper.veryDarkGrey,
                          checkColor: widget.isDarkMode
                              ? UIHelper.veryDarkGrey
                              : Colors.white,
                          onChanged: (value) {
                            setState(() {
                              _dontShowAgain = value ?? false;
                            });
                          },
                        ),
                      ),
                      Flexible(
                        child: Text(
                          widget.version.checkBoxDontShowAgain.text
                              .localize(widget.language),
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context)
                        .pop(VersionControlResponse.ACCEPTED),
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
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              if (widget.showNegative)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context)
                          .pop(VersionControlResponse.CANCELLED),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: widget.isDarkMode
                              ? Colors.white
                              : UIHelper.mediumLightGrey,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        foregroundColor: textColor,
                      ),
                      child: Text(
                        widget.version.cancel.localize(widget.language),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
