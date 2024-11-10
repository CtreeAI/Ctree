import 'package:ctree/core/models/image_file.dart';
import 'package:flutter/material.dart';
import 'package:ctree/core/models/post_model.dart';
import 'package:ctree/core/service/post_service.dart';

class PostProvider with ChangeNotifier {
  final PostService _postService = PostService();
  List<PostModel> _posts = [];
  bool _isLoading = false;
  String? _error;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPosts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _posts = await _postService.fetchPosts();
    } catch (e) {
      _error = 'Erro ao carregar posts: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createPost(PostModel post, ImageFile? imageFile) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final success = await _postService.createPost(post, imageFile);

      if (success) {
        // Atualiza a lista de posts após criar um novo
        await fetchPosts();
      }

      return success;
    } catch (e) {
      _error = 'Erro ao criar post: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
