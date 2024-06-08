import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/services/auth_service.dart';

void main() {
  group('Authentication Service', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    test('Login with valid credentials', () async {
      final result = await authService.login('username', 'password');
      expect(result, true);
    });

    test('Login with invalid credentials', () async {
      final result = await authService.login('invalid_username', 'invalid_password');
      expect(result, false);
    });
  });
}
