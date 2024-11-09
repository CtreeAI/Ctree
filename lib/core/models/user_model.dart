class UserModel {
  final String displayName;
  final String role;
  final String uuid;

  UserModel({
    required this.displayName,
    required this.role,
    required this.uuid,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      displayName: map['displayName'] ?? '',
      role: map['role'] ?? '',
      uuid: id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'role': role,
      'uuid': uuid,
    };
  }
}
