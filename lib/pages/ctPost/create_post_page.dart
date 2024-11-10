import 'dart:io';
import 'package:ctree/core/components/image_picker.dart';
import 'package:ctree/core/models/image_file.dart';
import 'package:ctree/core/provider/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/post_model.dart';
import '../auth/data/auth_repository.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _resumeController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String? _selectedTag;
  ImageFile? _postImage;
  String? _authorId;
  String? _authorName;

  void _handleImageSelection(ImageFile? image) {
    setState(() {
      _postImage = image;
    });
  }

  Future<void> _getCurrentUser() async {
    final currentUser = AuthRepository.currentUserModel;
    if (currentUser != null) {
      setState(() {
        _authorId = currentUser.uuid;
        _authorName = currentUser.displayName;
      });
    }
  }

  Widget _buildSelectedImage() {
    if (_postImage == null) return const SizedBox.shrink();

    if (_postImage!.isWeb) {
      return Image.memory(_postImage!.file);
    } else {
      return Image.file(_postImage!.file as File);
    }
  }

  Future<void> _submitPost() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_authorId == null || _authorName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erro: Não foi possível obter os dados do autor')),
        );
        return;
      }

      // Criar o post model
      final post = PostModel(
        id: '', // ID será gerado pelo Firestore
        title: _titleController.text,
        authorId: _authorId!,
        author: _authorName!,
        resume: _resumeController.text,
        texto: _contentController.text,
        coverImage: '', // URL será definida após o upload
        images: [],
        tag: _selectedTag ?? '',
      );

      // Obter o provider
      final postProvider = Provider.of<PostProvider>(context, listen: false);

      // Mostrar indicador de loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // Criar o post
        final success = await postProvider.createPost(post, _postImage);

        // Fechar o indicador de loading
        if (context.mounted) {
          Navigator.pop(context);
        }

        if (success) {
          if (context.mounted) {
            // Mostrar mensagem de sucesso
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post criado com sucesso!')),
            );

            // Limpar o formulário
            _titleController.clear();
            _resumeController.clear();
            _contentController.clear();
            setState(() {
              _postImage = null;
              _selectedTag = null;
            });
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Erro ao criar post')),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.pop(context); // Fechar loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao criar post: $e')),
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Post')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título do Post',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o título';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _resumeController,
                    decoration: const InputDecoration(
                      labelText: 'Resumo do Post',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o resumo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: 'Conteúdo do Post',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o conteúdo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildSelectedImage(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitPost,
                    child: const Text('Publicar'),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => ImagePickerModal(
                        onImageSelected: _handleImageSelection,
                      ),
                    ),
                    child: const Text(
                      'Escolher imagem para o post',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedTag,
                    items: ['Denúncias', 'Notícias', 'Inovações']
                        .map((tag) => DropdownMenuItem(
                              value: tag,
                              child: Text(tag),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTag = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Tag do Post',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecione uma tag';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
