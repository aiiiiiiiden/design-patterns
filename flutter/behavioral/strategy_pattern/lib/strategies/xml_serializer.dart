import 'package:xml/xml.dart';
import '../models/user.dart';
import 'data_serializer_strategy.dart';

/// Concrete Strategy: XML serialization
/// Serializes data to XML format
class XmlSerializer implements DataSerializerStrategy {
  @override
  String serialize(List<User> users) {
    try {
      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0" encoding="UTF-8"');
      builder.element('users', nest: () {
        for (final user in users) {
          builder.element('user', nest: () {
            builder.element('id', nest: user.id);
            builder.element('name', nest: user.name);
            builder.element('email', nest: user.email);
            builder.element('age', nest: user.age.toString());
            builder.element('role', nest: user.role);
          });
        }
      });

      return builder.buildDocument().toXmlString(pretty: true);
    } catch (e) {
      throw FormatException('Failed to serialize to XML: $e');
    }
  }

  @override
  List<User> deserialize(String data) {
    try {
      final document = XmlDocument.parse(data);
      final usersElement = document.findElements('users').first;
      final userElements = usersElement.findElements('user');

      return userElements.map((userElement) {
        final id = userElement.findElements('id').first.innerText;
        final name = userElement.findElements('name').first.innerText;
        final email = userElement.findElements('email').first.innerText;
        final age = int.parse(userElement.findElements('age').first.innerText);
        final role = userElement.findElements('role').first.innerText;

        return User(
          id: id,
          name: name,
          email: email,
          age: age,
          role: role,
        );
      }).toList();
    } catch (e) {
      throw FormatException('Failed to deserialize from XML: $e');
    }
  }

  @override
  String getFormatName() => 'XML';

  @override
  String getFileExtension() => '.xml';

  @override
  String getMimeType() => 'application/xml';
}
