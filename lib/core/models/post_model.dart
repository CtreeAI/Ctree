class PostModel {
  final String id;
  final String title;
  final String authorId;
  final String author;
  final String resume;
  final String texto;
  final String coverImage;
  final List<String> images;
  final String tag;

  PostModel({
    required this.id,
    required this.title,
    required this.authorId,
    required this.author,
    required this.resume,
    required this.texto,
    required this.coverImage,
    required this.images,
    required this.tag,
  });

  PostModel copyWith({
    String? id,
    String? title,
    String? authorId,
    String? author,
    String? resume,
    String? texto,
    String? coverImage,
    List<String>? images,
    String? tag,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      authorId: authorId ?? this.authorId,
      author: author ?? this.author,
      resume: resume ?? this.resume,
      texto: texto ?? this.texto,
      coverImage: coverImage ?? this.coverImage,
      images: images ?? this.images,
      tag: tag ?? this.tag,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'authorId': authorId,
      'author': author,
      'resume': resume,
      'texto': texto,
      'coverImage': coverImage,
      'images': images,
      'tag': tag,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map, String id) {
    return PostModel(
      id: id,
      title: map['title'] ?? '',
      authorId: map['authorId'] ?? '',
      author: map['author'] ?? '',
      resume: map['resume'] ?? '',
      texto: map['texto'] ?? '',
      coverImage: map['coverImage'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      tag: map['tag'] ?? '',
    );
  }
}
