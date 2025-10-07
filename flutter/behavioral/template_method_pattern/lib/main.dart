import 'package:flutter/material.dart';
import 'package:template_method_pattern/models/validation_result.dart';
import 'package:template_method_pattern/validators/email_validator.dart';
import 'package:template_method_pattern/validators/password_validator.dart';
import 'package:template_method_pattern/validators/phone_validator.dart';
import 'package:template_method_pattern/validators/username_validator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Template Method Pattern - Validation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ValidationDemoPage(),
    );
  }
}

class ValidationDemoPage extends StatefulWidget {
  const ValidationDemoPage({super.key});

  @override
  State<ValidationDemoPage> createState() => _ValidationDemoPageState();
}

class _ValidationDemoPageState extends State<ValidationDemoPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  final _usernameValidator = UsernameValidator();
  final _emailValidator = EmailValidator();
  final _passwordValidator = PasswordValidator();
  final _phoneValidator = PhoneValidator(countryCode: 'KR');

  ValidationResult? _usernameResult;
  ValidationResult? _emailResult;
  ValidationResult? _passwordResult;
  ValidationResult? _phoneResult;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _usernameResult = _usernameValidator.validate(_usernameController.text);
      _emailResult = _emailValidator.validate(_emailController.text);
      _passwordResult = _passwordValidator.validate(_passwordController.text);
      _phoneResult = _phoneValidator.validate(_phoneController.text);
    });

    if (_usernameResult!.isValid &&
        _emailResult!.isValid &&
        _passwordResult!.isValid &&
        _phoneResult!.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields are valid!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _usernameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _phoneController.clear();
      _usernameResult = null;
      _emailResult = null;
      _passwordResult = null;
      _phoneResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Template Method Pattern - Validation'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Template Method Pattern Demo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Each validator implements the Template Method pattern with a common validation algorithm',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Username field
              _buildValidatedTextField(
                controller: _usernameController,
                label: 'Username',
                hint: 'Enter username (e.g., john_doe)',
                icon: Icons.person,
                result: _usernameResult,
              ),
              const SizedBox(height: 8),
              const Text(
                'Must be 3-20 characters, start with a letter, and contain only letters, numbers, underscores, and hyphens',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Email field
              _buildValidatedTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'Enter email (e.g., user@example.com)',
                icon: Icons.email,
                result: _emailResult,
              ),
              const SizedBox(height: 8),
              const Text(
                'Must be a valid email address',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Password field
              _buildValidatedTextField(
                controller: _passwordController,
                label: 'Password',
                hint: 'Enter password',
                icon: Icons.lock,
                result: _passwordResult,
                obscureText: true,
              ),
              const SizedBox(height: 8),
              const Text(
                'Must be 8+ characters with uppercase, lowercase, digit, and special character',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Phone field
              _buildValidatedTextField(
                controller: _phoneController,
                label: 'Phone (Korean)',
                hint: 'Enter phone (e.g., 010-1234-5678)',
                icon: Icons.phone,
                result: _phoneResult,
              ),
              const SizedBox(height: 8),
              const Text(
                'Must be a valid Korean phone number starting with 010, 011, 016, 017, 018, or 019',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _validateForm,
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Validate All'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _resetForm,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Pattern explanation
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Template Method Pattern',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'The validation algorithm follows these steps:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      _buildPatternStep('1', 'Check if value is not empty'),
                      _buildPatternStep('2', 'Preprocess the value (trim, lowercase, etc.)'),
                      _buildPatternStep('3', 'Check minimum length'),
                      _buildPatternStep('4', 'Check maximum length'),
                      _buildPatternStep('5', 'Check format (specific to each validator)'),
                      _buildPatternStep('6', 'Perform custom validation (optional)'),
                      const SizedBox(height: 8),
                      const Text(
                        'Each validator implements the specific steps while following the same algorithm structure.',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValidatedTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required ValidationResult? result,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: result != null
            ? Icon(
                result.isValid ? Icons.check_circle : Icons.error,
                color: result.isValid ? Colors.green : Colors.red,
              )
            : null,
        errorText: result != null && !result.isValid ? result.errorMessage : null,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPatternStep(String number, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(description),
            ),
          ),
        ],
      ),
    );
  }
}
