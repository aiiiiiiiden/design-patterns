import 'package:flutter_test/flutter_test.dart';
import 'package:strategy_pattern/models/user.dart';
import 'package:strategy_pattern/strategies/json_serializer.dart';

void main() {
  late JsonSerializer serializer;

  setUp(() {
    serializer = JsonSerializer();
  });

  group('JsonSerializer Tests', () {
    test('should return correct format name', () {
      expect(serializer.getFormatName(), 'JSON');
    });

    test('should return correct file extension', () {
      expect(serializer.getFileExtension(), '.json');
    });

    test('should return correct MIME type', () {
      expect(serializer.getMimeType(), 'application/json');
    });

    test('should serialize single user to JSON', () {
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

      expect(result, contains('"id":"1"'));
      expect(result, contains('"name":"Alice"'));
      expect(result, contains('"email":"alice@example.com"'));
      expect(result, contains('"age":28'));
      expect(result, contains('"role":"Developer"'));
    });

    test('should serialize multiple users to JSON', () {
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

      expect(result, contains('"id":"1"'));
      expect(result, contains('"name":"Alice"'));
      expect(result, contains('"id":"2"'));
      expect(result, contains('"name":"Bob"'));
    });

    test('should serialize empty list to empty JSON array', () {
      const users = <User>[];

      final result = serializer.serialize(users);

      expect(result, '[]');
    });

    test('should deserialize JSON to users list', () {
      const jsonString =
          '[{"id":"1","name":"Alice","email":"alice@example.com","age":28,"role":"Developer"}]';

      final users = serializer.deserialize(jsonString);

      expect(users.length, 1);
      expect(users[0].id, '1');
      expect(users[0].name, 'Alice');
      expect(users[0].email, 'alice@example.com');
      expect(users[0].age, 28);
      expect(users[0].role, 'Developer');
    });

    test('should deserialize multiple users from JSON', () {
      const jsonString = '''
      [
        {"id":"1","name":"Alice","email":"alice@example.com","age":28,"role":"Developer"},
        {"id":"2","name":"Bob","email":"bob@example.com","age":35,"role":"Designer"}
      ]
      ''';

      final users = serializer.deserialize(jsonString);

      expect(users.length, 2);
      expect(users[0].name, 'Alice');
      expect(users[1].name, 'Bob');
    });

    test('should deserialize empty JSON array to empty list', () {
      const jsonString = '[]';

      final users = serializer.deserialize(jsonString);

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

    test('should handle special characters in JSON', () {
      const users = [
        User(
          id: '1',
          name: 'O\'Brien "The Great"',
          email: 'test@example.com',
          age: 30,
          role: 'Manager',
        ),
      ];

      final serialized = serializer.serialize(users);
      final deserialized = serializer.deserialize(serialized);

      expect(deserialized[0].name, 'O\'Brien "The Great"');
    });

    test('should throw FormatException for invalid JSON', () {
      const invalidJson = '{invalid json}';

      expect(
        () => serializer.deserialize(invalidJson),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw FormatException for non-array JSON', () {
      const invalidJson = '{"id":"1","name":"Alice"}';

      expect(
        () => serializer.deserialize(invalidJson),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
