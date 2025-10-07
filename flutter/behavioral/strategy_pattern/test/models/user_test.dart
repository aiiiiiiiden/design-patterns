import 'package:flutter_test/flutter_test.dart';
import 'package:strategy_pattern/models/user.dart';

void main() {
  group('User Model Tests', () {
    test('should create User instance with all fields', () {
      const user = User(
        id: '1',
        name: 'Test User',
        email: 'test@example.com',
        age: 30,
        role: 'Tester',
      );

      expect(user.id, '1');
      expect(user.name, 'Test User');
      expect(user.email, 'test@example.com');
      expect(user.age, 30);
      expect(user.role, 'Tester');
    });

    test('should serialize User to JSON correctly', () {
      const user = User(
        id: '123',
        name: 'Alice',
        email: 'alice@test.com',
        age: 25,
        role: 'Developer',
      );

      final json = user.toJson();

      expect(json['id'], '123');
      expect(json['name'], 'Alice');
      expect(json['email'], 'alice@test.com');
      expect(json['age'], 25);
      expect(json['role'], 'Developer');
    });

    test('should deserialize User from JSON correctly', () {
      final json = {
        'id': '456',
        'name': 'Bob',
        'email': 'bob@test.com',
        'age': 35,
        'role': 'Manager',
      };

      final user = User.fromJson(json);

      expect(user.id, '456');
      expect(user.name, 'Bob');
      expect(user.email, 'bob@test.com');
      expect(user.age, 35);
      expect(user.role, 'Manager');
    });

    test('should perform round-trip JSON serialization', () {
      const originalUser = User(
        id: '789',
        name: 'Charlie',
        email: 'charlie@test.com',
        age: 42,
        role: 'Designer',
      );

      final json = originalUser.toJson();
      final deserializedUser = User.fromJson(json);

      expect(deserializedUser.id, originalUser.id);
      expect(deserializedUser.name, originalUser.name);
      expect(deserializedUser.email, originalUser.email);
      expect(deserializedUser.age, originalUser.age);
      expect(deserializedUser.role, originalUser.role);
    });

    test('should handle special characters in name and email', () {
      const user = User(
        id: '1',
        name: "O'Brien",
        email: 'user+tag@example.com',
        age: 30,
        role: 'Tester',
      );

      final json = user.toJson();
      final deserializedUser = User.fromJson(json);

      expect(deserializedUser.name, "O'Brien");
      expect(deserializedUser.email, 'user+tag@example.com');
    });
  });
}
