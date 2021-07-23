import 'package:example/data/interfaces.dart';
import 'package:example/model/language.dart';
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
    return LanguageExtensions.fromLanguageCode(_prefs.getString(_LANGUAGE));
  }

  @override
  Future<void> setLanguage(AppLanguage language) async {
    await _prefs.setString(_LANGUAGE, language.toLanguageCode());
  }
}
