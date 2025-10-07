import 'package:flutter_test/flutter_test.dart';
import 'package:template_method_pattern/validators/username_validator.dart';

void main() {
  group('UsernameValidator', () {
    late UsernameValidator validator;

    setUp(() {
      validator = UsernameValidator();
    });

    group('Valid usernames', () {
      test('should accept valid username', () {
        final result = validator.validate('john_doe');
        expect(result.isValid, true);
        expect(result.errorMessage, isNull);
      });

      test('should accept username with numbers', () {
        final result = validator.validate('user123');
        expect(result.isValid, true);
      });

      test('should accept username with underscores', () {
        final result = validator.validate('user_name_123');
        expect(result.isValid, true);
      });

      test('should accept username with hyphens', () {
        final result = validator.validate('user-name-123');
        expect(result.isValid, true);
      });

      test('should accept minimum length username', () {
        final result = validator.validate('abc');
        expect(result.isValid, true);
      });

      test('should accept maximum length username', () {
        final result = validator.validate('a' * 20);
        expect(result.isValid, true);
      });

      test('should accept mixed case username', () {
        final result = validator.validate('JohnDoe123');
        expect(result.isValid, true);
      });
    });

    group('Invalid usernames', () {
      test('should reject null username', () {
        final result = validator.validate(null);
        expect(result.isValid, false);
        expect(result.errorMessage, 'Username is required');
      });

      test('should reject empty username', () {
        final result = validator.validate('');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Username is required');
      });

      test('should reject username starting with number', () {
        final result = validator.validate('123user');
        expect(result.isValid, false);
        expect(result.errorMessage, contains('must start with a letter'));
      });

      test('should reject username starting with underscore', () {
        final result = validator.validate('_username');
        expect(result.isValid, false);
        expect(result.errorMessage, contains('must start with a letter'));
      });

      test('should reject username starting with hyphen', () {
        final result = validator.validate('-username');
        expect(result.isValid, false);
        expect(result.errorMessage, contains('must start with a letter'));
      });

      test('should reject username with spaces', () {
        final result = validator.validate('john doe');
        expect(result.isValid, false);
        expect(result.errorMessage, contains('must start with a letter'));
      });

      test('should reject username with special characters', () {
        final result = validator.validate('john@doe');
        expect(result.isValid, false);
        expect(result.errorMessage, contains('letters, numbers, underscores, and hyphens'));
      });

      test('should reject username shorter than minimum', () {
        final result = validator.validate('ab');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Username must be at least 3 characters');
      });

      test('should reject username longer than maximum', () {
        final result = validator.validate('a' * 21);
        expect(result.isValid, false);
        expect(result.errorMessage, 'Username must not exceed 20 characters');
      });
    });

    group('Reserved names', () {
      test('should reject reserved name "admin"', () {
        final result = validator.validate('admin');
        expect(result.isValid, false);
        expect(result.errorMessage, contains('reserved'));
      });

      test('should reject reserved name "root"', () {
        final result = validator.validate('root');
        expect(result.isValid, false);
        expect(result.errorMessage, contains('reserved'));
      });

      test('should reject reserved name "system"', () {
        final result = validator.validate('system');
        expect(result.isValid, false);
        expect(result.errorMessage, contains('reserved'));
      });

      test('should reject reserved name "user"', () {
        final result = validator.validate('user');
        expect(result.isValid, false);
        expect(result.errorMessage, contains('reserved'));
      });

      test('should reject reserved name case-insensitively', () {
        final result = validator.validate('ADMIN');
        expect(result.isValid, false);
        expect(result.errorMessage, contains('reserved'));
      });

      test('should accept custom reserved names', () {
        final customValidator = UsernameValidator(
          reservedNames: ['superuser', 'moderator'],
        );
        final result = customValidator.validate('superuser');
        expect(result.isValid, false);
        expect(result.errorMessage, contains('reserved'));
      });

      test('should accept username similar to reserved but not exact', () {
        final result = validator.validate('administrator');
        expect(result.isValid, true);
      });
    });

    group('Edge cases', () {
      test('should trim whitespace', () {
        final result = validator.validate('  username  ');
        expect(result.isValid, true);
      });

      test('should handle custom field name', () {
        final customValidator = UsernameValidator(fieldName: 'Account Name');
        final result = customValidator.validate('');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Account Name is required');
      });

      test('should accept empty reserved names list', () {
        final customValidator = UsernameValidator(reservedNames: []);
        final result = customValidator.validate('admin');
        expect(result.isValid, true);
      });
    });
  });
}
