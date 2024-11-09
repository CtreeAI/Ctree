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
  String _selectedTag = 'Todos';

  // Filtrar posts com base na tag selecionada
  List<PostModel> getFilteredPosts(List<PostModel> posts) {
    if (_selectedTag == 'Todos') {
      return posts;
    }
    return posts.where((post) => post.tag == _selectedTag).toList();
  }

  // Alterar a tag selecionada e atualizar a exibição
  void _onTagSelected(String tag) {
    setState(() {
      _selectedTag = tag;
    });
  }

  @override
  void initState() {
    super.initState();
    // Carregar posts ao inicializar a página
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
                  'Filtrar por Tag',
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
                        label: 'Todos',
                        isSelected: _selectedTag == 'Todos',
                        onTap: () => _onTagSelected('Todos'),
                      ),
                      const SizedBox(height: 8),
                      FilterButton(
                        label: 'Denúncias',
                        isSelected: _selectedTag == 'Denúncias',
                        onTap: () => _onTagSelected('Denúncias'),
                      ),
                      const SizedBox(height: 8),
                      FilterButton(
                        label: 'Notícias',
                        isSelected: _selectedTag == 'Notícias',
                        onTap: () => _onTagSelected('Notícias'),
                      ),
                      const SizedBox(height: 8),
                      FilterButton(
                        label: 'Inovação',
                        isSelected: _selectedTag == 'Inovações',
                        onTap: () => _onTagSelected('Inovações'),
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
