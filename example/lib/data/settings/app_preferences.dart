import 'package:common_module_flutter_example/data/interfaces.dart';
import 'package:common_module_flutter_example/model/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences extends Settings {
  static const String _LANGUAGE = "_LANGUAGE";

  final SharedPreferences _prefs;

  AppPreferences(this._prefs);

  @override
  bool hasLanguage() {
    return _prefs.containsKey(_LANGUAGE);
  }

  @override
  AppLanguage getLanguage() {
    return AppLanguageExtensions.fromLanguageCode(
        _prefs.getString(_LANGUAGE) ?? AppLanguage.CA.toLanguageCode());
  }

  @override
  Future<void> setLanguage(AppLanguage language) async {
    await _prefs.setString(_LANGUAGE, language.toLanguageCode());
  }
}
