import 'package:common_module_flutter/internal/interfaces.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RateMePreferencesImpl extends RateMePreferences {
  /// How many times the app was launched in total
  static const String TOTAL_LAUNCH_COUNT = "PREF_TOTAL_LAUNCH_COUNT";

  /// Timestamp of when the app was launched for the first time
  static const String TIME_OF_ABSOLUTE_FIRST_LAUNCH =
      "PREF_TIME_OF_ABSOLUTE_FIRST_LAUNCH";

  /// How many times the app was launched since the last prompt
  static const String LAUNCHES_SINCE_LAST_PROMPT =
      "PREF_LAUNCHES_SINCE_LAST_PROMPT";

  /// Timestamp of the last user prompt
  static const String TIME_OF_LAST_PROMPT = "PREF_TIME_OF_LAST_PROMPT";

  /// The application version when last checked
  static const String VERSION = "VERSION";
  static const String DONT_SHOW_AGAIN = "PREF_DONT_SHOW_AGAIN";

  final SharedPreferences _prefs;

  RateMePreferencesImpl(this._prefs);

  @override
  bool getDontShowAgain() {
    return _prefs.containsKey(DONT_SHOW_AGAIN)
        ? _prefs.getBool(DONT_SHOW_AGAIN) ?? false
        : false;
  }

  @override
  int getLaunchesSinceLastPrompt() {
    return _prefs.containsKey(LAUNCHES_SINCE_LAST_PROMPT)
        ? _prefs.getInt(LAUNCHES_SINCE_LAST_PROMPT) ?? 0
        : 0;
  }

  @override
  int getTimeOfAbsoluteFirstLaunch() {
    return _prefs.containsKey(TIME_OF_ABSOLUTE_FIRST_LAUNCH)
        ? _prefs.getInt(TIME_OF_ABSOLUTE_FIRST_LAUNCH) ?? 0
        : 0;
  }

  @override
  int getTimeOfLastPrompt() {
    return _prefs.containsKey(TIME_OF_LAST_PROMPT)
        ? _prefs.getInt(TIME_OF_LAST_PROMPT) ?? 0
        : 0;
  }

  @override
  int getTotalLaunchCount() {
    return _prefs.containsKey(TOTAL_LAUNCH_COUNT)
        ? _prefs.getInt(TOTAL_LAUNCH_COUNT) ?? 0
        : 0;
  }

  @override
  int getVersionCode() {
    return _prefs.containsKey(VERSION) ? _prefs.getInt(VERSION) ?? 0 : 0;
  }

  @override
  Future<void> setDontShowAgain(bool dontShowAgain) async {
    await _prefs.setBool(DONT_SHOW_AGAIN, dontShowAgain);
  }

  @override
  Future<void> setLaunchesSinceLastPrompt(int launchesSinceLastPrompt) async {
    await _prefs.setInt(LAUNCHES_SINCE_LAST_PROMPT, launchesSinceLastPrompt);
  }

  @override
  Future<void> setTimeOfAbsoluteFirstLaunch(int timeAbsoluteFirstLaunch) async {
    await _prefs.setInt(TIME_OF_ABSOLUTE_FIRST_LAUNCH, timeAbsoluteFirstLaunch);
  }

  @override
  Future<void> setTimeOfLastPrompt(int timeOfLastPrompt) async {
    await _prefs.setInt(TIME_OF_LAST_PROMPT, timeOfLastPrompt);
  }

  @override
  Future<void> setTotalLaunchCount(int totalLaunchCount) async {
    await _prefs.setInt(TOTAL_LAUNCH_COUNT, totalLaunchCount);
  }

  @override
  Future<void> setVersionCode(int versionCode) async {
    await _prefs.setInt(VERSION, versionCode);
  }

  @override
  Future<void> clearAll() async {
    await _prefs.remove(TOTAL_LAUNCH_COUNT);
    await _prefs.remove(TIME_OF_ABSOLUTE_FIRST_LAUNCH);
    await _prefs.remove(LAUNCHES_SINCE_LAST_PROMPT);
    await _prefs.remove(TIME_OF_LAST_PROMPT);
    await _prefs.remove(VERSION);
    await _prefs.remove(DONT_SHOW_AGAIN);
  }
}
