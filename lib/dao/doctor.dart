import 'package:uuid/uuid.dart';

class Patient {
  String id;
  String name;
  String email;
  String contact;
  String password;

  Patient({
    String? id, // Make id nullable
    required this.name,
    required this.email,
    required this.contact,
    required this.password,
  }) : id = id ?? const Uuid().v4(); // Assign a UUID if id is null

  // Factory constructor to create a Patient object from a map
  factory Patient.fromMap(Map<String, dynamic> map, String documentId) {
    return Patient(
      id: documentId,
      name: map['name'] as String,
      email: map['email'] as String,
      contact: map['contact'] as String,
      password: map['password'] as String,
    );
  }

  // Method to convert a Patient object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'contact': contact,
      'password': password,
    };
  }
}
