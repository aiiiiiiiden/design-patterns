import 'base_validator.dart';

/// Concrete validator for email addresses
class EmailValidator extends BaseValidator {
  static const int minLength = 5; // a@b.c
  static const int maxLength = 254; // RFC 5321

  EmailValidator({String fieldName = 'Email'}) : super(fieldName);

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
    // Basic email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(value);
  }

  @override
  String getFormatErrorMessage() {
    return '$fieldName must be a valid email address';
  }

  @override
  String preprocess(String value) {
    // Convert to lowercase and trim
    return super.preprocess(value).toLowerCase();
  }
}
