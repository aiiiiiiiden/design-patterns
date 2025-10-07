import 'package:flutter_test/flutter_test.dart';
import 'package:strategy_pattern/context/data_converter.dart';
import 'package:strategy_pattern/models/user.dart';
import 'package:strategy_pattern/strategies/csv_serializer.dart';
import 'package:strategy_pattern/strategies/json_serializer.dart';
import 'package:strategy_pattern/strategies/xml_serializer.dart';

void main() {
  late DataConverter converter;

  setUp(() {
    converter = DataConverter();
  });

  group('DataConverter Context Tests', () {
    test('should not have strategy initially', () {
      expect(converter.hasStrategy, false);
      expect(converter.strategy, isNull);
    });

    test('should set JSON strategy', () {
      final strategy = JsonSerializer();
      converter.setStrategy(strategy);

      expect(converter.hasStrategy, true);
      expect(converter.strategy, strategy);
      expect(converter.getFormatName(), 'JSON');
    });

    test('should set CSV strategy', () {
      final strategy = CsvSerializer();
      converter.setStrategy(strategy);

      expect(converter.hasStrategy, true);
      expect(converter.strategy, strategy);
      expect(converter.getFormatName(), 'CSV');
    });

    test('should set XML strategy', () {
      final strategy = XmlSerializer();
      converter.setStrategy(strategy);

      expect(converter.hasStrategy, true);
      expect(converter.strategy, strategy);
      expect(converter.getFormatName(), 'XML');
    });

    test('should throw StateError when serializing without strategy', () {
      const users = [
        User(
          id: '1',
          name: 'Alice',
          email: 'alice@example.com',
          age: 28,
          role: 'Developer',
        ),
      ];

      expect(
        () => converter.serialize(users),
        throwsStateError,
      );
    });

    test('should throw StateError when deserializing without strategy', () {
      const data = '[]';

      expect(
        () => converter.deserialize(data),
        throwsStateError,
      );
    });

    test('should serialize with JSON strategy', () {
      converter.setStrategy(JsonSerializer());

      const users = [
        User(
          id: '1',
          name: 'Alice',
          email: 'alice@example.com',
          age: 28,
          role: 'Developer',
        ),
      ];

      final result = converter.serialize(users);

      expect(result, contains('"id":"1"'));
      expect(result, contains('"name":"Alice"'));
    });

    test('should serialize with CSV strategy', () {
      converter.setStrategy(CsvSerializer());

      const users = [
        User(
          id: '1',
          name: 'Alice',
          email: 'alice@example.com',
          age: 28,
          role: 'Developer',
        ),
      ];

      final result = converter.serialize(users);

      expect(result, contains('id,name,email,age,role'));
      expect(result, contains('1,Alice,alice@example.com,28,Developer'));
    });

    test('should serialize with XML strategy', () {
      converter.setStrategy(XmlSerializer());

      const users = [
        User(
          id: '1',
          name: 'Alice',
          email: 'alice@example.com',
          age: 28,
          role: 'Developer',
        ),
      ];

      final result = converter.serialize(users);

      expect(result, contains('<?xml'));
      expect(result, contains('<users>'));
      expect(result, contains('<name>Alice</name>'));
    });

    test('should switch between strategies at runtime', () {
      const users = [
        User(
          id: '1',
          name: 'Alice',
          email: 'alice@example.com',
          age: 28,
          role: 'Developer',
        ),
      ];

      // JSON strategy
      converter.setStrategy(JsonSerializer());
      final jsonResult = converter.serialize(users);
      expect(jsonResult, contains('"name":"Alice"'));

      // Switch to CSV strategy
      converter.setStrategy(CsvSerializer());
      final csvResult = converter.serialize(users);
      expect(csvResult, contains('Alice'));
      expect(csvResult, contains('id,name,email'));

      // Switch to XML strategy
      converter.setStrategy(XmlSerializer());
      final xmlResult = converter.serialize(users);
      expect(xmlResult, contains('<name>Alice</name>'));
    });

    test('should deserialize with JSON strategy', () {
      converter.setStrategy(JsonSerializer());

      const jsonString =
          '[{"id":"1","name":"Alice","email":"alice@example.com","age":28,"role":"Developer"}]';

      final users = converter.deserialize(jsonString);

      expect(users.length, 1);
      expect(users[0].name, 'Alice');
    });

    test('should deserialize with CSV strategy', () {
      converter.setStrategy(CsvSerializer());

      const testUsers = [
        User(
          id: '1',
          name: 'Alice',
          email: 'alice@example.com',
          age: 28,
          role: 'Developer',
        ),
      ];

      final csvString = converter.serialize(testUsers);
      final users = converter.deserialize(csvString);

      expect(users.length, 1);
      expect(users[0].name, 'Alice');
    });

    test('should deserialize with XML strategy', () {
      converter.setStrategy(XmlSerializer());

      const xmlString = '''<?xml version="1.0"?>
<users>
  <user>
    <id>1</id>
    <name>Alice</name>
    <email>alice@example.com</email>
    <age>28</age>
    <role>Developer</role>
  </user>
</users>''';

      final users = converter.deserialize(xmlString);

      expect(users.length, 1);
      expect(users[0].name, 'Alice');
    });

    test('should perform round-trip conversion with JSON strategy', () {
      converter.setStrategy(JsonSerializer());

      const originalUsers = [
        User(
          id: '1',
          name: 'Alice',
          email: 'alice@example.com',
          age: 28,
          role: 'Developer',
        ),
      ];

      final convertedUsers = converter.convert(originalUsers);

      expect(convertedUsers.length, 1);
      expect(convertedUsers[0].id, originalUsers[0].id);
      expect(convertedUsers[0].name, originalUsers[0].name);
    });

    test('should get format name from current strategy', () {
      expect(converter.getFormatName(), isNull);

      converter.setStrategy(JsonSerializer());
      expect(converter.getFormatName(), 'JSON');

      converter.setStrategy(CsvSerializer());
      expect(converter.getFormatName(), 'CSV');

      converter.setStrategy(XmlSerializer());
      expect(converter.getFormatName(), 'XML');
    });

    test('should get file extension from current strategy', () {
      expect(converter.getFileExtension(), isNull);

      converter.setStrategy(JsonSerializer());
      expect(converter.getFileExtension(), '.json');

      converter.setStrategy(CsvSerializer());
      expect(converter.getFileExtension(), '.csv');

      converter.setStrategy(XmlSerializer());
      expect(converter.getFileExtension(), '.xml');
    });

    test('should get MIME type from current strategy', () {
      expect(converter.getMimeType(), isNull);

      converter.setStrategy(JsonSerializer());
      expect(converter.getMimeType(), 'application/json');

      converter.setStrategy(CsvSerializer());
      expect(converter.getMimeType(), 'text/csv');

      converter.setStrategy(XmlSerializer());
      expect(converter.getMimeType(), 'application/xml');
    });

    test('should handle empty list with all strategies', () {
      const emptyUsers = <User>[];

      // JSON
      converter.setStrategy(JsonSerializer());
      final jsonResult = converter.serialize(emptyUsers);
      expect(converter.deserialize(jsonResult), isEmpty);

      // CSV
      converter.setStrategy(CsvSerializer());
      final csvResult = converter.serialize(emptyUsers);
      expect(converter.deserialize(csvResult), isEmpty);

      // XML
      converter.setStrategy(XmlSerializer());
      final xmlResult = converter.serialize(emptyUsers);
      expect(converter.deserialize(xmlResult), isEmpty);
    });

    test('should handle multiple users with all strategies', () {
      const users = [
        User(
          id: '1',
          name: 'Alice',
          email: 'alice@example.com',
          age: 28,
          role: 'Developer',
        ),
        User(
          id: '2',
          name: 'Bob',
          email: 'bob@example.com',
          age: 35,
          role: 'Designer',
        ),
        User(
          id: '3',
          name: 'Charlie',
          email: 'charlie@example.com',
          age: 42,
          role: 'Manager',
        ),
      ];

      // JSON
      converter.setStrategy(JsonSerializer());
      final jsonConverted = converter.convert(users);
      expect(jsonConverted.length, 3);

      // CSV
      converter.setStrategy(CsvSerializer());
      final csvConverted = converter.convert(users);
      expect(csvConverted.length, 3);

      // XML
      converter.setStrategy(XmlSerializer());
      final xmlConverted = converter.convert(users);
      expect(xmlConverted.length, 3);
    });
  });
}
