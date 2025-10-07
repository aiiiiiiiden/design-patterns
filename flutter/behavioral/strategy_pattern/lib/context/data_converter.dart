import '../models/user.dart';
import '../strategies/data_serializer_strategy.dart';

/// Context class that uses a DataSerializerStrategy
/// This class demonstrates the Strategy pattern by allowing
/// the serialization algorithm to be changed at runtime
class DataConverter {
  DataSerializerStrategy? _strategy;

  /// Get the current strategy
  DataSerializerStrategy? get strategy => _strategy;

  /// Set the serialization strategy
  /// This allows changing the serialization format at runtime
  void setStrategy(DataSerializerStrategy strategy) {
    _strategy = strategy;
  }

  /// Serialize users using the current strategy
  /// Throws StateError if no strategy is set
  String serialize(List<User> users) {
    if (_strategy == null) {
      throw StateError('Serialization strategy not set. Call setStrategy() first.');
    }
    return _strategy!.serialize(users);
  }

  /// Deserialize data using the current strategy
  /// Throws StateError if no strategy is set
  List<User> deserialize(String data) {
    if (_strategy == null) {
      throw StateError('Deserialization strategy not set. Call setStrategy() first.');
    }
    return _strategy!.deserialize(data);
  }

  /// Get the current format name
  String? getFormatName() => _strategy?.getFormatName();

  /// Get the current file extension
  String? getFileExtension() => _strategy?.getFileExtension();

  /// Get the current MIME type
  String? getMimeType() => _strategy?.getMimeType();

  /// Check if a strategy is set
  bool get hasStrategy => _strategy != null;

  /// Convenience method: serialize and deserialize in one go (for testing)
  List<User> convert(List<User> users) {
    final serialized = serialize(users);
    return deserialize(serialized);
  }
}
