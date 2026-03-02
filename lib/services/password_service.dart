import 'dart:convert';

import 'package:crypto/crypto.dart';

class PasswordService {
  static String hashPassword({
    required String email,
    required String password,
  }) {
    final String normalizedEmail = email.trim().toLowerCase();
    final String normalizedPassword = password.trim();
    final String input = '$normalizedEmail::$normalizedPassword';
    return sha256.convert(utf8.encode(input)).toString();
  }

  static bool verifyPassword({
    required String email,
    required String enteredPassword,
    required String storedHash,
  }) {
    final String computedHash = hashPassword(
      email: email,
      password: enteredPassword,
    );
    return computedHash == storedHash;
  }
}
