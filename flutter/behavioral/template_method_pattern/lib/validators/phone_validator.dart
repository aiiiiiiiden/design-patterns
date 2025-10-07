import 'base_validator.dart';

/// Concrete validator for phone numbers
class PhoneValidator extends BaseValidator {
  static const int minLength = 10;
  static const int maxLength = 15;

  final String countryCode;

  PhoneValidator({
    String fieldName = 'Phone',
    this.countryCode = 'KR', // Default to Korea
  }) : super(fieldName);

  @override
  bool checkMinLength(String value) {
    return value.length >= minLength;
  }

  @override
  String getMinLengthErrorMessage() {
    return '$fieldName must be at least $minLength digits';
  }

  @override
  bool checkMaxLength(String value) {
    return value.length <= maxLength;
  }

  @override
  String getMaxLengthErrorMessage() {
    return '$fieldName must not exceed $maxLength digits';
  }

  @override
  bool checkFormat(String value) {
    // Check if contains only digits and optional + at start
    if (countryCode == 'KR') {
      // Korean phone number format: 010-XXXX-XXXX or 01XXXXXXXXX
      final koreanPhoneRegex = RegExp(r'^01[016789]\d{7,8}$');
      return koreanPhoneRegex.hasMatch(value);
    } else {
      // International format: +[country code][number] or just digits
      final intlPhoneRegex = RegExp(r'^\+?\d{10,15}$');
      return intlPhoneRegex.hasMatch(value);
    }
  }

  @override
  String getFormatErrorMessage() {
    if (countryCode == 'KR') {
      return '$fieldName must be a valid Korean phone number (e.g., 01012345678)';
    }
    return '$fieldName must be a valid phone number';
  }

  @override
  String preprocess(String value) {
    // Remove common separators like -, (, ), and spaces
    return super
        .preprocess(value)
        .replaceAll(RegExp(r'[\s\-\(\)]'), '');
  }
}
