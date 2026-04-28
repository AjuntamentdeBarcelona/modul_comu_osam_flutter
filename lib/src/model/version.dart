import 'package:osam_common_module_flutter/src/model/language.dart';

class Version {
  final LocalizedText title;
  final LocalizedText message;
  final LocalizedText ok;
  final LocalizedText cancel;
  final CheckBoxDontShowAgain checkBoxDontShowAgain;

  Version({
    required this.title,
    required this.message,
    required this.ok,
    required this.cancel,
    required this.checkBoxDontShowAgain,
  });
}

class LocalizedText {
  final String ca;
  final String es;
  final String en;

  LocalizedText({
    required this.ca,
    required this.es,
    required this.en,
  });

  String localize(Language language) {
    switch (language) {
      case Language.CA:
        return ca;
      case Language.ES:
        return es;
      case Language.EN:
        return en;
      default:
        return ca;
    }
  }
}

class CheckBoxDontShowAgain {
  final bool isCheckBoxVisible;
  final LocalizedText text;

  CheckBoxDontShowAgain({
    required this.isCheckBoxVisible,
    required this.text,
  });
}
