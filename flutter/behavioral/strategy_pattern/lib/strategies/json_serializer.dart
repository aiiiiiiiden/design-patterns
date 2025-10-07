import 'dart:convert';
import '../models/user.dart';
import 'data_serializer_strategy.dart';

/// Concrete Strategy: JSON serialization
/// Serializes data to JSON format
class JsonSerializer implements DataSerializerStrategy {
  @override
  String serialize(List<User> users) {
    try {
      final List<Map<String, dynamic>> jsonList =
          users.map((user) => user.toJson()).toList();

      return jsonEncode(jsonList);
    } catch (e) {
      throw FormatException('Failed to serialize to JSON: $e');
    }
  }

  @override
  List<User> deserialize(String data) {
    try {
      final List<dynamic> jsonList = jsonDecode(data) as List<dynamic>;

      return jsonList
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw FormatException('Failed to deserialize from JSON: $e');
    }
  }

  @override
  String getFormatName() => 'JSON';

  @override
  String getFileExtension() => '.json';

  @override
  String getMimeType() => 'application/json';
}
