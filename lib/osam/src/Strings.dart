import 'package:common_module_flutter/osam/OSAM.dart';

class Strings {
  static String getString(String key, Language language) {
    String value;
    switch (language) {
      case Language.CA:
        value = _CA[key] ?? "";
        break;
      case Language.ES:
        value = _ES[key] ?? "";
        break;
      case Language.EN:
        value = _EN[key] ?? "";
        break;
      default:
        value = _CA[key] ?? "";
        break;
    }
    return value;
  }

  static const Map<String, String> _CA = {
    "rate_me_button_rate_now": "VALORAR ARA",
    "rate_me_button_no": "NO, GRÀCIES",
    "rate_me_button_later": "MÉS TARD",
  };

  static const Map<String, String> _ES = {
    "rate_me_button_rate_now": "VALORAR AHORA",
    "rate_me_button_no": "NO, GRACIAS",
    "rate_me_button_later": "MÁS TARDE",
  };

  static const Map<String, String> _EN = {
    "rate_me_button_rate_now": "RATE NOW",
    "rate_me_button_no": "NO, THANKS",
    "rate_me_button_later": "LATER",
  };
}
