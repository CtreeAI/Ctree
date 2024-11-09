import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctree/core/models/post_model.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PostModel>> fetchPosts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('posts').get();
      return snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
