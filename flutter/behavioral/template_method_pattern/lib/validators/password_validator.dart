import '../models/validation_result.dart';
import 'base_validator.dart';

/// Concrete validator for passwords
class PasswordValidator extends BaseValidator {
  static const int minLength = 8;
  static const int maxLength = 128;

  final bool requireUppercase;
  final bool requireLowercase;
  final bool requireDigit;
  final bool requireSpecialChar;

  PasswordValidator({
    String fieldName = 'Password',
    this.requireUppercase = true,
    this.requireLowercase = true,
    this.requireDigit = true,
    this.requireSpecialChar = true,
  }) : super(fieldName);

  @override
  bool checkMinLength(String value) {
    return value.length >= minLength;
  }

  @override
  String getMinLengthErrorMessage() {
    return '$fieldName must be at least $minLength characters';
  }

  @override
  bool checkMaxLength(String value) {
    return value.length <= maxLength;
  }

  @override
  String getMaxLengthErrorMessage() {
    return '$fieldName must not exceed $maxLength characters';
  }

  @override
  bool checkFormat(String value) {
    // Password format is checked in performCustomValidation
    // This just checks if it's not all whitespace
    return value.trim().isNotEmpty;
  }

  @override
  String getFormatErrorMessage() {
    return '$fieldName cannot be only whitespace';
  }

  @override
  String preprocess(String value) {
    // Don't trim passwords to preserve intentional whitespace
    return value;
  }

  @override
  ValidationResult? performCustomValidation(String value) {
    if (requireUppercase && !value.contains(RegExp(r'[A-Z]'))) {
      return ValidationResult.failure(
        errorMessage: '$fieldName must contain at least one uppercase letter',
        fieldName: fieldName,
      );
    }

    if (requireLowercase && !value.contains(RegExp(r'[a-z]'))) {
      return ValidationResult.failure(
        errorMessage: '$fieldName must contain at least one lowercase letter',
        fieldName: fieldName,
      );
    }

    if (requireDigit && !value.contains(RegExp(r'[0-9]'))) {
      return ValidationResult.failure(
        errorMessage: '$fieldName must contain at least one digit',
        fieldName: fieldName,
      );
    }

    if (requireSpecialChar && !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return ValidationResult.failure(
        errorMessage: '$fieldName must contain at least one special character',
        fieldName: fieldName,
      );
    }

    return null; // All custom validations passed
  }
}
