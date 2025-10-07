/// Represents the result of a validation operation
class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final String? fieldName;

  const ValidationResult({
    required this.isValid,
    this.errorMessage,
    this.fieldName,
  });

  factory ValidationResult.success({String? fieldName}) {
    return ValidationResult(
      isValid: true,
      fieldName: fieldName,
    );
  }

  factory ValidationResult.failure({
    required String errorMessage,
    String? fieldName,
  }) {
    return ValidationResult(
      isValid: false,
      errorMessage: errorMessage,
      fieldName: fieldName,
    );
  }

  @override
  String toString() {
    if (isValid) {
      return 'ValidationResult(isValid: true${fieldName != null ? ', fieldName: $fieldName' : ''})';
    }
    return 'ValidationResult(isValid: false, errorMessage: $errorMessage${fieldName != null ? ', fieldName: $fieldName' : ''})';
  }
}
