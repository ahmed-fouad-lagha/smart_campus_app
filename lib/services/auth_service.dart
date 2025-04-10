import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'storage_service.dart';

class AuthService {
  final StorageService storageService;

  AuthService({required this.storageService});

  // Login method
  Future<bool> login(String email, String password) async {
    // In a real app, this would make an API call to authenticate
    // For demo purposes, we'll simulate a network delay and check against stored credentials
    await Future.delayed(const Duration(seconds: 1));

    // Hash the password for comparison
    final hashedPassword = _hashPassword(password);

    // Check if the user exists and credentials match
    final storedEmail = storageService.getUserEmail();
    final storedPassword = storageService.getUserPassword();

    if (storedEmail == email && storedPassword == hashedPassword) {
      // Set logged in state
      await storageService.setLoggedIn(true);
      return true;
    }

    // For demo purposes, also allow a test account
    if (email == 'test@example.com' && password == 'password123') {
      // Save user info
      await storageService.setUserEmail(email);
      await storageService.setUserName('Test User');
      await storageService.setUserPassword(_hashPassword(password));
      await storageService.setLoggedIn(true);
      return true;
    }

    return false;
  }

  // Register method
  Future<bool> register(String name, String email, String password) async {
    // In a real app, this would make an API call to register the user
    // For demo purposes, we'll simulate a network delay and store locally
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Check if email is already registered
      final storedEmail = storageService.getUserEmail();
      if (storedEmail == email) {
        return false; // Email already exists
      }

      // Hash the password before storing
      final hashedPassword = _hashPassword(password);

      // Store user information
      await storageService.setUserName(name);
      await storageService.setUserEmail(email);
      await storageService.setUserPassword(hashedPassword);

      // Note: We don't set logged in here, user should log in after registration
      return true;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    await storageService.setLoggedIn(false);
  }

  // Helper method to hash passwords
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Generate a random token (for password reset, etc.)
  String _generateToken() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }
}
