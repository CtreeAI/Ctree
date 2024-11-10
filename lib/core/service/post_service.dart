// lib/core/service/post_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctree/core/models/image_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ctree/core/models/post_model.dart';
import 'dart:typed_data';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<PostModel>> fetchPosts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('posts').get();
      return snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Erro ao buscar posts: $e');
      return [];
    }
  }

  Future<String?> _uploadImage(String postId, ImageFile imageFile) async {
    try {
      // Referência para o local onde a imagem será armazenada
      final storageRef = _storage.ref().child('posts/$postId/cover_image');

      // Upload da imagem
      if (imageFile.isWeb) {
        // Para web, usamos putData com Uint8List
        await storageRef.putData(imageFile.file as Uint8List);
      } else {
        // Para mobile, usamos putFile
        await storageRef.putFile(imageFile.file);
      }

      // Obtém a URL da imagem
      final imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Erro ao fazer upload da imagem: $e');
      return null;
    }
  }

  Future<bool> createPost(PostModel post, ImageFile? imageFile) async {
    try {
      // Criar uma referência com ID automático
      final docRef = _firestore.collection('posts').doc();
      final postId = docRef.id;

      String? imageUrl;
      if (imageFile != null) {
        // Fazer upload da imagem e obter a URL
        imageUrl = await _uploadImage(postId, imageFile);
      }

      // Criar o post com o ID gerado e a URL da imagem
      final postData = {
        'id': postId,
        'title': post.title,
        'authorId': post.authorId,
        'author': post.author,
        'resume': post.resume,
        'texto': post.texto,
        'coverImage': imageUrl ?? '',
        'images': post.images,
        'tag': post.tag,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Salvar o post no Firestore
      await docRef.set(postData);
      return true;
    } catch (e) {
      print('Erro ao criar post: $e');
      return false;
    }
  }
}
