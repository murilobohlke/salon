import 'dart:convert';

class UserModel {
  final String name;
  final String email;
  final String phone;
  final String id;
  final String image;
  
  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.id,
    required this.image
  });
  

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? id,
    String? image,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      id: id ?? this.id,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'id': id,
      'image': image,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      id: map['id'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, phone: $phone, id: $id, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.name == name &&
      other.email == email &&
      other.phone == phone &&
      other.id == id &&
      other.image == image;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      id.hashCode ^
      image.hashCode;
  }
}
