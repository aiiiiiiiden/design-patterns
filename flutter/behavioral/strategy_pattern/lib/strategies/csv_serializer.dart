import 'package:csv/csv.dart';
import '../models/user.dart';
import 'data_serializer_strategy.dart';

/// Concrete Strategy: CSV serialization
/// Serializes data to CSV format
class CsvSerializer implements DataSerializerStrategy {
  static const List<String> _headers = ['id', 'name', 'email', 'age', 'role'];

  @override
  String serialize(List<User> users) {
    try {
      // Create CSV data with headers
      final List<List<dynamic>> csvData = [
        _headers,
        ...users.map((user) => [
              user.id,
              user.name,
              user.email,
              user.age,
              user.role,
            ]),
      ];

      return const ListToCsvConverter().convert(csvData);
    } catch (e) {
      throw FormatException('Failed to serialize to CSV: $e');
    }
  }

  @override
  List<User> deserialize(String data) {
    try {
      final List<List<dynamic>> csvData =
          const CsvToListConverter().convert(data);

      if (csvData.isEmpty) {
        return [];
      }

      // Skip header row
      final List<List<dynamic>> dataRows = csvData.skip(1).toList();

      return dataRows.map((row) {
        if (row.length < 5) {
          throw FormatException('Invalid CSV row: expected 5 fields, got ${row.length}');
        }

        return User(
          id: row[0].toString(),
          name: row[1].toString(),
          email: row[2].toString(),
          age: int.parse(row[3].toString()),
          role: row[4].toString(),
        );
      }).toList();
    } catch (e) {
      throw FormatException('Failed to deserialize from CSV: $e');
    }
  }

  @override
  String getFormatName() => 'CSV';

  @override
  String getFileExtension() => '.csv';

  @override
  String getMimeType() => 'text/csv';
}
