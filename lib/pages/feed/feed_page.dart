import 'package:ctree/core/provider/post_provider.dart';
import 'package:ctree/pages/feed/components/filters/filter_button.dart';
import 'package:ctree/pages/feed/components/list/post_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ctree/core/models/post_model.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  String _selectedTag = 'All';

  // Filter posts based on the selected tag
  List<PostModel> getFilteredPosts(List<PostModel> posts) {
    if (_selectedTag == 'All') {
      return posts;
    }
    return posts.where((post) => post.tag == _selectedTag).toList();
  }

  // Change the selected tag and update the display
  void _onTagSelected(String tag) {
    setState(() {
      _selectedTag = tag;
    });
  }

  @override
  void initState() {
    super.initState();
    // Load posts when initializing the page
    Future.microtask(
        () => Provider.of<PostProvider>(context, listen: false).fetchPosts());
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final filteredPosts = getFilteredPosts(postProvider.posts);

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PostList(posts: filteredPosts),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter by Tag',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FilterButton(
                        label: 'All',
                        isSelected: _selectedTag == 'All',
                        onTap: () => _onTagSelected('All'),
                      ),
                      const SizedBox(height: 8),
                      FilterButton(
                        label: 'Reports',
                        isSelected: _selectedTag == 'Reports',
                        onTap: () => _onTagSelected('Reports'),
                      ),
                      const SizedBox(height: 8),
                      FilterButton(
                        label: 'News',
                        isSelected: _selectedTag == 'News',
                        onTap: () => _onTagSelected('News'),
                      ),
                      const SizedBox(height: 8),
                      FilterButton(
                        label: 'Innovation',
                        isSelected: _selectedTag == 'Innovation',
                        onTap: () => _onTagSelected('Innovation'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
