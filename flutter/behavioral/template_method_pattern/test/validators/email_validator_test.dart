import 'package:flutter_test/flutter_test.dart';
import 'package:template_method_pattern/validators/email_validator.dart';

void main() {
  group('EmailValidator', () {
    late EmailValidator validator;

    setUp(() {
      validator = EmailValidator();
    });

    group('Valid emails', () {
      test('should accept valid email', () {
        final result = validator.validate('test@example.com');
        expect(result.isValid, true);
        expect(result.errorMessage, isNull);
      });

      test('should accept email with numbers', () {
        final result = validator.validate('user123@example.com');
        expect(result.isValid, true);
      });

      test('should accept email with dots', () {
        final result = validator.validate('first.last@example.com');
        expect(result.isValid, true);
      });

      test('should accept email with plus sign', () {
        final result = validator.validate('user+tag@example.com');
        expect(result.isValid, true);
      });

      test('should convert email to lowercase', () {
        final result = validator.validate('TEST@EXAMPLE.COM');
        expect(result.isValid, true);
      });
    });

    group('Invalid emails', () {
      test('should reject null email', () {
        final result = validator.validate(null);
        expect(result.isValid, false);
        expect(result.errorMessage, 'Email is required');
      });

      test('should reject empty email', () {
        final result = validator.validate('');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Email is required');
      });

      test('should reject email without @', () {
        final result = validator.validate('testexample.com');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Email must be a valid email address');
      });

      test('should reject email without domain', () {
        final result = validator.validate('test@');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Email must be a valid email address');
      });

      test('should reject email without local part', () {
        final result = validator.validate('@example.com');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Email must be a valid email address');
      });

      test('should reject email without TLD', () {
        final result = validator.validate('test@example');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Email must be a valid email address');
      });

      test('should reject email that is too short', () {
        final result = validator.validate('a@b');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Email must be at least 5 characters');
      });

      test('should reject email with spaces', () {
        final result = validator.validate('test @example.com');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Email must be a valid email address');
      });

      test('should reject email with multiple @', () {
        final result = validator.validate('test@@example.com');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Email must be a valid email address');
      });
    });

    group('Edge cases', () {
      test('should trim whitespace', () {
        final result = validator.validate('  test@example.com  ');
        expect(result.isValid, true);
      });

      test('should handle very long email within limit', () {
        final localPart = 'a' * 64;
        final domainPart = 'b' * 63;
        final email = '$localPart@$domainPart.com';
        final result = validator.validate(email);
        expect(result.isValid, email.length <= EmailValidator.maxLength);
      });
    });
  });
}
