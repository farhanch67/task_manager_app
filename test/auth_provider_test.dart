import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/auth_provider.dart';

void main() {
  group('Authentication Provider', () {
    late AuthProvider authProvider;

    setUp(() {
      authProvider = AuthProvider();
    });

    test('Login with valid credentials', () async {
      final result = await authProvider.login('username', 'password');
      // expect(result, true);
    });

    test('Login with invalid credentials', () async {
      final result = await authProvider.login('invalid_username', 'invalid_password');
      // expect(result, false);
    });
  });
}
