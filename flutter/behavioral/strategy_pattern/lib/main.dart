import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'context/data_converter.dart';
import 'models/user.dart';
import 'strategies/csv_serializer.dart';
import 'strategies/json_serializer.dart';
import 'strategies/xml_serializer.dart';
import 'strategies/data_serializer_strategy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strategy Pattern - Data Format Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DataConverterPage(),
    );
  }
}

class DataConverterPage extends StatefulWidget {
  const DataConverterPage({super.key});

  @override
  State<DataConverterPage> createState() => _DataConverterPageState();
}

class _DataConverterPageState extends State<DataConverterPage> {
  final DataConverter _converter = DataConverter();
  final List<User> _sampleUsers = [
    const User(
      id: '1',
      name: 'Alice Johnson',
      email: 'alice@example.com',
      age: 28,
      role: 'Developer',
    ),
    const User(
      id: '2',
      name: 'Bob Smith',
      email: 'bob@example.com',
      age: 35,
      role: 'Designer',
    ),
    const User(
      id: '3',
      name: 'Charlie Brown',
      email: 'charlie@example.com',
      age: 42,
      role: 'Manager',
    ),
  ];

  String _output = '';
  String _selectedFormat = 'JSON';

  @override
  void initState() {
    super.initState();
    _converter.setStrategy(JsonSerializer());
  }

  void _convertData() {
    try {
      final serialized = _converter.serialize(_sampleUsers);
      setState(() {
        _output = serialized;
      });
    } catch (e) {
      _showError('Serialization Error: $e');
    }
  }

  void _changeFormat(String format) {
    setState(() {
      _selectedFormat = format;
      switch (format) {
        case 'JSON':
          _converter.setStrategy(JsonSerializer());
          break;
        case 'CSV':
          _converter.setStrategy(CsvSerializer());
          break;
        case 'XML':
          _converter.setStrategy(XmlSerializer());
          break;
      }
      _output = '';
    });
  }

  void _copyToClipboard() {
    if (_output.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _output));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Strategy Pattern - Data Converter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            const Text(
              'Data Format Converter',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Demonstrates Strategy Pattern with runtime format selection',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Sample Data Display
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sample Users:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._sampleUsers.map((user) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                child: Text(user.name[0]),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${user.email} • ${user.role} • Age: ${user.age}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Format Selection
            const Text(
              'Select Output Format:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'JSON',
                  label: Text('JSON'),
                  icon: Icon(Icons.code),
                ),
                ButtonSegment(
                  value: 'CSV',
                  label: Text('CSV'),
                  icon: Icon(Icons.table_chart),
                ),
                ButtonSegment(
                  value: 'XML',
                  label: Text('XML'),
                  icon: Icon(Icons.description),
                ),
              ],
              selected: {_selectedFormat},
              onSelectionChanged: (Set<String> selected) {
                _changeFormat(selected.first);
              },
            ),
            const SizedBox(height: 24),

            // Convert Button
            ElevatedButton.icon(
              onPressed: _convertData,
              icon: const Icon(Icons.transform),
              label: Text('Convert to $_selectedFormat'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 24),

            // Output Display
            if (_output.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Output ($_selectedFormat):',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: _copyToClipboard,
                    tooltip: 'Copy to clipboard',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SelectableText(
                  _output,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Strategy Pattern Explanation
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Strategy Pattern',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'This app demonstrates the Strategy pattern by:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    _buildBulletPoint('Defining a common interface (DataSerializerStrategy)'),
                    _buildBulletPoint('Implementing multiple strategies (JSON, CSV, XML)'),
                    _buildBulletPoint('Allowing runtime strategy selection'),
                    _buildBulletPoint('Encapsulating each algorithm separately'),
                    const SizedBox(height: 8),
                    Text(
                      'Current Strategy: ${_converter.getFormatName() ?? "None"}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      'MIME Type: ${_converter.getMimeType() ?? "N/A"}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
