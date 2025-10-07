import 'package:flutter_test/flutter_test.dart';
import 'package:template_method_pattern/validators/password_validator.dart';

void main() {
  group('PasswordValidator', () {
    late PasswordValidator validator;

    setUp(() {
      validator = PasswordValidator();
    });

    group('Valid passwords', () {
      test('should accept password with all requirements', () {
        final result = validator.validate('Password123!');
        expect(result.isValid, true);
        expect(result.errorMessage, isNull);
      });

      test('should accept password with multiple special characters', () {
        final result = validator.validate('Pass@word#123');
        expect(result.isValid, true);
      });

      test('should accept minimum length password', () {
        final result = validator.validate('Pass1234!');
        expect(result.isValid, true);
      });
    });

    group('Invalid passwords', () {
      test('should reject null password', () {
        final result = validator.validate(null);
        expect(result.isValid, false);
        expect(result.errorMessage, 'Password is required');
      });

      test('should reject empty password', () {
        final result = validator.validate('');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Password is required');
      });

      test('should reject password without uppercase', () {
        final result = validator.validate('password123!');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Password must contain at least one uppercase letter');
      });

      test('should reject password without lowercase', () {
        final result = validator.validate('PASSWORD123!');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Password must contain at least one lowercase letter');
      });

      test('should reject password without digit', () {
        final result = validator.validate('Password!');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Password must contain at least one digit');
      });

      test('should reject password without special character', () {
        final result = validator.validate('Password123');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Password must contain at least one special character');
      });

      test('should reject password shorter than minimum', () {
        final result = validator.validate('Pass1!');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Password must be at least 8 characters');
      });

      test('should reject password that is only whitespace', () {
        final result = validator.validate('        ');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Password cannot be only whitespace');
      });
    });

    group('Custom requirements', () {
      test('should accept password without uppercase when not required', () {
        final customValidator = PasswordValidator(requireUppercase: false);
        final result = customValidator.validate('password123!');
        expect(result.isValid, true);
      });

      test('should accept password without lowercase when not required', () {
        final customValidator = PasswordValidator(requireLowercase: false);
        final result = customValidator.validate('PASSWORD123!');
        expect(result.isValid, true);
      });

      test('should accept password without digit when not required', () {
        final customValidator = PasswordValidator(requireDigit: false);
        final result = customValidator.validate('Password!');
        expect(result.isValid, true);
      });

      test('should accept password without special char when not required', () {
        final customValidator = PasswordValidator(requireSpecialChar: false);
        final result = customValidator.validate('Password123');
        expect(result.isValid, true);
      });

      test('should accept simple password when all requirements are disabled', () {
        final customValidator = PasswordValidator(
          requireUppercase: false,
          requireLowercase: false,
          requireDigit: false,
          requireSpecialChar: false,
        );
        final result = customValidator.validate('password');
        expect(result.isValid, true);
      });
    });

    group('Edge cases', () {
      test('should preserve leading and trailing spaces in password', () {
        // Password should not be trimmed
        final result = validator.validate(' Password123! ');
        // This should still validate if the password meets requirements
        expect(result.isValid, true);
      });

      test('should reject extremely long password', () {
        final longPassword = 'Password123!' * 20; // Way over 128 chars
        final result = validator.validate(longPassword);
        expect(result.isValid, false);
        expect(result.errorMessage, 'Password must not exceed 128 characters');
      });
    });
  });
}
