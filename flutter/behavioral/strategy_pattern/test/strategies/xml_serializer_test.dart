import 'package:flutter_test/flutter_test.dart';
import 'package:strategy_pattern/models/user.dart';
import 'package:strategy_pattern/strategies/xml_serializer.dart';

void main() {
  late XmlSerializer serializer;

  setUp(() {
    serializer = XmlSerializer();
  });

  group('XmlSerializer Tests', () {
    test('should return correct format name', () {
      expect(serializer.getFormatName(), 'XML');
    });

    test('should return correct file extension', () {
      expect(serializer.getFileExtension(), '.xml');
    });

    test('should return correct MIME type', () {
      expect(serializer.getMimeType(), 'application/xml');
    });

    test('should serialize single user to XML', () {
      const users = [
        User(
          id: '1',
          name: 'Alice',
          email: 'alice@example.com',
          age: 28,
          role: 'Developer',
        ),
      ];

      final result = serializer.serialize(users);

      expect(result, contains('<?xml version="1.0" encoding="UTF-8"?>'));
      expect(result, contains('<users>'));
      expect(result, contains('<user>'));
      expect(result, contains('<id>1</id>'));
      expect(result, contains('<name>Alice</name>'));
      expect(result, contains('<email>alice@example.com</email>'));
      expect(result, contains('<age>28</age>'));
      expect(result, contains('<role>Developer</role>'));
      expect(result, contains('</user>'));
      expect(result, contains('</users>'));
    });

    test('should serialize multiple users to XML', () {
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
      ];

      final result = serializer.serialize(users);

      expect(result, contains('<name>Alice</name>'));
      expect(result, contains('<name>Bob</name>'));
      expect('<user>'.allMatches(result).length, 2);
    });

    test('should serialize empty list to empty XML structure', () {
      const users = <User>[];

      final result = serializer.serialize(users);

      expect(result, contains('<?xml version="1.0" encoding="UTF-8"?>'));
      expect(result, contains('<users/>'));
    });

    test('should handle special XML characters', () {
      const users = [
        User(
          id: '1',
          name: 'Alice & Bob',
          email: 'test@example.com',
          age: 30,
          role: 'Developer <Senior>',
        ),
      ];

      final result = serializer.serialize(users);

      expect(result, contains('Alice &amp; Bob'));
      expect(result, contains('Developer &lt;Senior>'));
    });

    test('should deserialize XML to users list', () {
      const xmlString = '''<?xml version="1.0" encoding="UTF-8"?>
<users>
  <user>
    <id>1</id>
    <name>Alice</name>
    <email>alice@example.com</email>
    <age>28</age>
    <role>Developer</role>
  </user>
</users>''';

      final users = serializer.deserialize(xmlString);

      expect(users.length, 1);
      expect(users[0].id, '1');
      expect(users[0].name, 'Alice');
      expect(users[0].email, 'alice@example.com');
      expect(users[0].age, 28);
      expect(users[0].role, 'Developer');
    });

    test('should deserialize multiple users from XML', () {
      const xmlString = '''<?xml version="1.0" encoding="UTF-8"?>
<users>
  <user>
    <id>1</id>
    <name>Alice</name>
    <email>alice@example.com</email>
    <age>28</age>
    <role>Developer</role>
  </user>
  <user>
    <id>2</id>
    <name>Bob</name>
    <email>bob@example.com</email>
    <age>35</age>
    <role>Designer</role>
  </user>
</users>''';

      final users = serializer.deserialize(xmlString);

      expect(users.length, 2);
      expect(users[0].name, 'Alice');
      expect(users[1].name, 'Bob');
    });

    test('should deserialize empty XML structure to empty list', () {
      const xmlString = '''<?xml version="1.0" encoding="UTF-8"?>
<users/>''';

      final users = serializer.deserialize(xmlString);

      expect(users, isEmpty);
    });

    test('should perform round-trip serialization', () {
      const originalUsers = [
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
      ];

      final serialized = serializer.serialize(originalUsers);
      final deserialized = serializer.deserialize(serialized);

      expect(deserialized.length, originalUsers.length);
      expect(deserialized[0].id, originalUsers[0].id);
      expect(deserialized[0].name, originalUsers[0].name);
      expect(deserialized[1].id, originalUsers[1].id);
      expect(deserialized[1].name, originalUsers[1].name);
    });

    test('should handle escaped XML entities in round-trip', () {
      const users = [
        User(
          id: '1',
          name: 'Alice & Bob',
          email: 'test@example.com',
          age: 30,
          role: 'Developer <Senior>',
        ),
      ];

      final serialized = serializer.serialize(users);
      final deserialized = serializer.deserialize(serialized);

      expect(deserialized[0].name, 'Alice & Bob');
      expect(deserialized[0].role, 'Developer <Senior>');
    });

    test('should throw FormatException for invalid XML', () {
      const invalidXml = '<invalid><xml>';

      expect(
        () => serializer.deserialize(invalidXml),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw FormatException for XML without users element', () {
      const invalidXml = '''<?xml version="1.0"?>
<root>
  <user>
    <id>1</id>
  </user>
</root>''';

      expect(
        () => serializer.deserialize(invalidXml),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw FormatException for invalid age value', () {
      const invalidXml = '''<?xml version="1.0"?>
<users>
  <user>
    <id>1</id>
    <name>Alice</name>
    <email>alice@example.com</email>
    <age>invalid</age>
    <role>Developer</role>
  </user>
</users>''';

      expect(
        () => serializer.deserialize(invalidXml),
        throwsA(isA<FormatException>()),
      );
    });

    test('should serialize with pretty printing', () {
      const users = [
        User(
          id: '1',
          name: 'Alice',
          email: 'alice@example.com',
          age: 28,
          role: 'Developer',
        ),
      ];

      final result = serializer.serialize(users);

      // Check that the output contains newlines and indentation
      expect(result, contains('\n'));
      expect(result, contains('  '));
    });
  });
}
