import '../models/user.dart';

/// Strategy interface for data serialization
/// This defines the contract that all concrete serialization strategies must follow
abstract interface class DataSerializerStrategy {
  /// Serialize a list of users to a string in the specific format
  String serialize(List<User> users);

  /// Deserialize a string back to a list of users
  List<User> deserialize(String data);

  /// Get the name of this serialization format
  String getFormatName();

  /// Get the file extension for this format
  String getFileExtension();

  /// Get the MIME type for this format
  String getMimeType();
}
