import '../models/validation_result.dart';
import 'base_validator.dart';

/// Concrete validator for usernames
class UsernameValidator extends BaseValidator {
  static const int minLength = 3;
  static const int maxLength = 20;

  final List<String> reservedNames;

  UsernameValidator({
    String fieldName = 'Username',
    this.reservedNames = const ['admin', 'root', 'system', 'user'],
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
    // Username can contain letters, numbers, underscores, and hyphens
    // Must start with a letter
    final usernameRegex = RegExp(r'^[a-zA-Z][a-zA-Z0-9_-]*$');
    return usernameRegex.hasMatch(value);
  }

  @override
  String getFormatErrorMessage() {
    return '$fieldName must start with a letter and contain only letters, numbers, underscores, and hyphens';
  }

  @override
  ValidationResult? performCustomValidation(String value) {
    // Check if username is in reserved names list
    if (reservedNames.contains(value.toLowerCase())) {
      return ValidationResult.failure(
        errorMessage: '$fieldName "$value" is reserved and cannot be used',
        fieldName: fieldName,
      );
    }

    return null;
  }
}
