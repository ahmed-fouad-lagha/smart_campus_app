import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyFirstLaunch = 'first_launch';
  static const String _keyLoggedIn = 'logged_in';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPassword = 'user_password';
  static const String _keyUserToken = 'user_token';
  static const String _keyThemeMode = 'theme_mode';

  late SharedPreferences _prefs;
  bool _initialized = false;

  // Initialize the service
  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;

      // Set default values for first launch
      if (!_prefs.containsKey(_keyFirstLaunch)) {
        await setFirstLaunch(true);
      }
    }
  }

  // First launch methods
  bool isFirstLaunch() {
    return _prefs.getBool(_keyFirstLaunch) ?? true;
  }

  Future<void> setFirstLaunch(bool value) async {
    await _prefs.setBool(_keyFirstLaunch, value);
  }

  // Authentication methods
  bool isLoggedIn() {
    return _prefs.getBool(_keyLoggedIn) ?? false;
  }

  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(_keyLoggedIn, value);
  }

  // User data methods
  String? getUserName() {
    return _prefs.getString(_keyUserName);
  }

  Future<void> setUserName(String value) async {
    await _prefs.setString(_keyUserName, value);
  }

  String? getUserEmail() {
    return _prefs.getString(_keyUserEmail);
  }

  Future<void> setUserEmail(String value) async {
    await _prefs.setString(_keyUserEmail, value);
  }

  String? getUserPassword() {
    return _prefs.getString(_keyUserPassword);
  }

  Future<void> setUserPassword(String value) async {
    await _prefs.setString(_keyUserPassword, value);
  }

  String? getUserToken() {
    return _prefs.getString(_keyUserToken);
  }

  Future<void> setUserToken(String value) async {
    await _prefs.setString(_keyUserToken, value);
  }

  // Theme methods
  String getThemeMode() {
    return _prefs.getString(_keyThemeMode) ?? 'system';
  }

  Future<void> setThemeMode(String value) async {
    await _prefs.setString(_keyThemeMode, value);
  }

  // Clear all data (for logout or account deletion)
  Future<void> clearAll() async {
    // Preserve first launch status
    final wasFirstLaunch = isFirstLaunch();
    final themeMode = getThemeMode();

    await _prefs.clear();

    // Restore preserved settings
    await setFirstLaunch(wasFirstLaunch);
    await setThemeMode(themeMode);
  }

  // Clear only authentication data (for logout)
  Future<void> clearAuthData() async {
    await _prefs.remove(_keyLoggedIn);
    await _prefs.remove(_keyUserToken);
  }
}
