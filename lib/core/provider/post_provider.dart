import 'package:ctree/core/service/post_service.dart';
import 'package:flutter/material.dart';
import 'package:ctree/core/models/post_model.dart';

class PostProvider with ChangeNotifier {
  final PostService _postService = PostService();
  List<PostModel> _posts = [];

  List<PostModel> get posts => _posts;

  Future<void> fetchPosts() async {
    _posts = await _postService.fetchPosts();
    notifyListeners();
  }
}
