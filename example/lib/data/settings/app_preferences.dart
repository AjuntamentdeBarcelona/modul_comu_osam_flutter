import 'dart:async';

import 'package:common_module_flutter_example/data/interfaces.dart';
import 'package:common_module_flutter_example/model/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences extends Settings {
  static const String _language = "_LANGUAGE";
  static const String _needToShowRatingPopup = "_NEED_TO_SHOW_RATING_POPUP";
  static const String _hasNeedToShowRatingPopup =
      "_HAS_NEED_TO_SHOW_RATING_POPUP";
  static const String _needToShowVersionControlPopup =
      "_NEED_TO_SHOW_VERSION_CONTROL_POPUP";
  static const String _hasNeedToShowVersionControlPopup =
      "_HAS_NEED_TO_SHOW_VERSION_CONTROL_POPUP";
  static const String _appVersionName = "_APP_VERSION_NAME";
  static const String _appVersionCode = "_APP_VERSION_CODE";
  static const String _subscribedTopics = "_SUBSCRIBED_TOPICS";
  static const String _popupMode = "_POPUP_MODE";

  final SharedPreferences _prefs;
  final StreamController<List<String>> _topicsController =
      StreamController.broadcast();

  AppPreferences(this._prefs);

  @override
  bool hasLanguage() {
    return _prefs.containsKey(_language);
  }

  @override
  AppLanguage getLanguage() {
    return AppLanguageExtensions.fromLanguageCode(
        _prefs.getString(_language) ?? AppLanguage.CA.toLanguageCode());
  }

  @override
  Future<void> setLanguage(AppLanguage language) async {
    await _prefs.setString(_language, language.toLanguageCode());
  }

  @override
  bool getShowRatingPopup() {
    return _prefs.getBool(_needToShowRatingPopup) ?? false;
  }

  @override
  bool getShowVersionControlPopup() {
    return _prefs.getBool(_needToShowVersionControlPopup) ?? false;
  }

  @override
  Future<void> setShowRatingPopup(bool needTo) async {
    await _prefs.setBool(_needToShowRatingPopup, needTo);
  }

  @override
  Future<void> setShowVersionControlPopup(bool needTo) async {
    await _prefs.setBool(_needToShowVersionControlPopup, needTo);
  }

  @override
  bool hasShowRatingPopup() {
    return _prefs.getBool(_hasNeedToShowRatingPopup) ?? false;
  }

  @override
  bool hasShowVersionControlPopup() {
    return _prefs.getBool(_hasNeedToShowVersionControlPopup) ?? false;
  }

  @override
  String getAppVersionName() {
    return _prefs.getString(_appVersionName) ?? "";
  }

  @override
  Future<void> setAppVersionName(String appVersionName) async {
    await _prefs.setString(_appVersionName, appVersionName);
  }

  @override
  String getAppVersionCode() {
    return _prefs.getString(_appVersionCode) ?? "";
  }

  @override
  Future<void> setAppVersionCode(String appVersionCode) async {
    await _prefs.setString(_appVersionCode, appVersionCode);
  }

  @override
  List<String> getSubscribedTopics() {
    return _prefs.getStringList(_subscribedTopics) ?? [];
  }

  @override
  Future<void> addSubscribedTopic(String topic) async {
    final topics = getSubscribedTopics();
    if (!topics.contains(topic)) {
      topics.add(topic);
      await _prefs.setStringList(_subscribedTopics, topics);
      _topicsController.add(topics);
    }
  }

  @override
  Future<void> removeSubscribedTopic(String topic) async {
    final topics = getSubscribedTopics();
    if (topics.contains(topic)) {
      topics.remove(topic);
      await _prefs.setStringList(_subscribedTopics, topics);
      _topicsController.add(topics);
    }
  }

  @override
  String getPopupMode() {
    return _prefs.getString(_popupMode) ?? "INFO";
  }

  @override
  Future<void> setPopupMode(String mode) async {
    await _prefs.setString(_popupMode, mode);
  }

  @override
  Stream<List<String>> getSubscribedTopicsStream() {
    return _topicsController.stream;
  }
}
