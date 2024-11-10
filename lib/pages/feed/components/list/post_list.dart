import 'package:ctree/core/models/post_model.dart';
import 'package:ctree/pages/feed/components/post/post_component.dart';
import 'package:flutter/material.dart';

class PostList extends StatelessWidget {
  final List<PostModel> posts;

  const PostList({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        primary: false,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText:
                          "Find what you're looking for with the power of AI!",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 21),
                  PostComponent(post: posts[index]),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: PostComponent(post: posts[index]),
          );
        },
        shrinkWrap: true,
      ),
    );
  }
}
