import 'package:flutter_test/flutter_test.dart';
import 'package:template_method_pattern/validators/phone_validator.dart';

void main() {
  group('PhoneValidator', () {
    group('Korean phone numbers', () {
      late PhoneValidator validator;

      setUp(() {
        validator = PhoneValidator(countryCode: 'KR');
      });

      test('should accept valid Korean phone number', () {
        final result = validator.validate('01012345678');
        expect(result.isValid, true);
        expect(result.errorMessage, isNull);
      });

      test('should accept phone number with 010 prefix', () {
        final result = validator.validate('01098765432');
        expect(result.isValid, true);
      });

      test('should accept phone number with 011 prefix', () {
        final result = validator.validate('01112345678');
        expect(result.isValid, true);
      });

      test('should accept phone number with 016 prefix', () {
        final result = validator.validate('01612345678');
        expect(result.isValid, true);
      });

      test('should accept phone number with 017 prefix', () {
        final result = validator.validate('01712345678');
        expect(result.isValid, true);
      });

      test('should accept phone number with 018 prefix', () {
        final result = validator.validate('01812345678');
        expect(result.isValid, true);
      });

      test('should accept phone number with 019 prefix', () {
        final result = validator.validate('01912345678');
        expect(result.isValid, true);
      });

      test('should remove hyphens from phone number', () {
        final result = validator.validate('010-1234-5678');
        expect(result.isValid, true);
      });

      test('should remove spaces from phone number', () {
        final result = validator.validate('010 1234 5678');
        expect(result.isValid, true);
      });

      test('should remove parentheses from phone number', () {
        final result = validator.validate('(010)1234-5678');
        expect(result.isValid, true);
      });

      test('should reject invalid prefix', () {
        final result = validator.validate('02012345678');
        expect(result.isValid, false);
        expect(result.errorMessage, contains('valid Korean phone number'));
      });

      test('should reject phone number that is too short', () {
        final result = validator.validate('0101234');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Phone must be at least 10 digits');
      });

      test('should reject null phone number', () {
        final result = validator.validate(null);
        expect(result.isValid, false);
        expect(result.errorMessage, 'Phone is required');
      });

      test('should reject empty phone number', () {
        final result = validator.validate('');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Phone is required');
      });
    });

    group('International phone numbers', () {
      late PhoneValidator validator;

      setUp(() {
        validator = PhoneValidator(countryCode: 'US');
      });

      test('should accept valid international phone number', () {
        final result = validator.validate('+12345678901');
        expect(result.isValid, true);
      });

      test('should accept phone number without plus sign', () {
        final result = validator.validate('12345678901');
        expect(result.isValid, true);
      });

      test('should accept 10-digit phone number', () {
        final result = validator.validate('1234567890');
        expect(result.isValid, true);
      });

      test('should accept 15-digit phone number', () {
        final result = validator.validate('123456789012345');
        expect(result.isValid, true);
      });

      test('should reject phone number with letters', () {
        final result = validator.validate('123abc7890');
        expect(result.isValid, false);
        expect(result.errorMessage, contains('valid phone number'));
      });

      test('should reject phone number that is too short', () {
        final result = validator.validate('123456789');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Phone must be at least 10 digits');
      });

      test('should reject phone number that is too long', () {
        final result = validator.validate('1234567890123456');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Phone must not exceed 15 digits');
      });

      test('should remove formatting characters', () {
        final result = validator.validate('(123) 456-7890');
        expect(result.isValid, true);
      });
    });

    group('Edge cases', () {
      test('should trim whitespace', () {
        final validator = PhoneValidator(countryCode: 'KR');
        final result = validator.validate('  010-1234-5678  ');
        expect(result.isValid, true);
      });

      test('should handle custom field name', () {
        final validator = PhoneValidator(
          fieldName: 'Mobile Number',
          countryCode: 'KR',
        );
        final result = validator.validate('');
        expect(result.isValid, false);
        expect(result.errorMessage, 'Mobile Number is required');
      });
    });
  });
}
