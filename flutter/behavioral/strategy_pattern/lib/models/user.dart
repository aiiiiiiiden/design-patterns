/// User model for data serialization demonstration
class User {
  final String id;
  final String name;
  final String email;
  final int age;
  final String role;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.role,
  });

  /// Factory constructor for creating User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      age: json['age'] as int,
      role: json['role'] as String,
    );
  }

  /// Convert User to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'role': role,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.age == age &&
        other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        age.hashCode ^
        role.hashCode;
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, age: $age, role: $role)';
  }

  /// Create a copy with modified fields
  User copyWith({
    String? id,
    String? name,
    String? email,
    int? age,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      role: role ?? this.role,
    );
  }
}
