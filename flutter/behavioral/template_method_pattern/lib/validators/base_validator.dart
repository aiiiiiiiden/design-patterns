import '../models/validation_result.dart';

/// Abstract base class implementing Template Method pattern for data validation
///
/// This class defines the skeleton of the validation algorithm in the validate() method.
/// Subclasses must implement the specific validation steps.
abstract class BaseValidator {
  final String fieldName;

  BaseValidator(this.fieldName);

  /// Template Method - defines the skeleton of the validation algorithm
  /// This method should NOT be overridden by subclasses
  ValidationResult validate(String? value) {
    // Step 1: Check if value is null or empty
    if (!checkNotEmpty(value)) {
      return ValidationResult.failure(
        errorMessage: '$fieldName is required',
        fieldName: fieldName,
      );
    }

    // Step 2: Preprocess the value (e.g., trim whitespace)
    final processedValue = preprocess(value!);

    // Step 3: Check minimum length
    if (!checkMinLength(processedValue)) {
      return ValidationResult.failure(
        errorMessage: getMinLengthErrorMessage(),
        fieldName: fieldName,
      );
    }

    // Step 4: Check maximum length
    if (!checkMaxLength(processedValue)) {
      return ValidationResult.failure(
        errorMessage: getMaxLengthErrorMessage(),
        fieldName: fieldName,
      );
    }

    // Step 5: Perform format validation (specific to each validator)
    if (!checkFormat(processedValue)) {
      return ValidationResult.failure(
        errorMessage: getFormatErrorMessage(),
        fieldName: fieldName,
      );
    }

    // Step 6: Perform additional custom validation (optional hook)
    final customValidationResult = performCustomValidation(processedValue);
    if (customValidationResult != null) {
      return customValidationResult;
    }

    // All validations passed
    return ValidationResult.success(fieldName: fieldName);
  }

  /// Hook method: Check if value is not null or empty
  /// Can be overridden if needed
  bool checkNotEmpty(String? value) {
    return value != null && value.isNotEmpty;
  }

  /// Hook method: Preprocess the input value
  /// Default implementation trims whitespace
  /// Can be overridden for custom preprocessing
  String preprocess(String value) {
    return value.trim();
  }

  /// Abstract method: Check minimum length
  /// Must be implemented by subclasses
  bool checkMinLength(String value);

  /// Abstract method: Get minimum length error message
  /// Must be implemented by subclasses
  String getMinLengthErrorMessage();

  /// Abstract method: Check maximum length
  /// Must be implemented by subclasses
  bool checkMaxLength(String value);

  /// Abstract method: Get maximum length error message
  /// Must be implemented by subclasses
  String getMaxLengthErrorMessage();

  /// Abstract method: Check format specific to the validator type
  /// Must be implemented by subclasses
  bool checkFormat(String value);

  /// Abstract method: Get format error message
  /// Must be implemented by subclasses
  String getFormatErrorMessage();

  /// Hook method: Perform additional custom validation
  /// Returns null if validation passes, or ValidationResult if it fails
  /// Can be overridden for additional validation logic
  ValidationResult? performCustomValidation(String value) {
    return null; // No additional validation by default
  }
}
