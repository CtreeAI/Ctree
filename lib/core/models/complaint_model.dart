class ComplaintModel {
  final String id;
  final String title;
  final String imageUrl;
  final String degree;
  final String orgId;
  final String orgName;
  final String description;
  final String location;
  final String userId; // Adicionado campo userId
  final DateTime createdAt;

  ComplaintModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.degree,
    required this.orgId,
    required this.orgName,
    required this.description,
    required this.location,
    required this.userId, // Adicionado ao construtor
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'degree': degree,
      'orgId': orgId,
      'orgName': orgName,
      'description': description,
      'location': location,
      'userId': userId, // Adicionado ao map
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ComplaintModel.fromMap(Map<String, dynamic> map) {
    return ComplaintModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      degree: map['degree'] ?? '',
      orgId: map['orgId'] ?? '',
      orgName: map['orgName'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      userId: map['userId'] ?? '', // Adicionado ao fromMap
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
