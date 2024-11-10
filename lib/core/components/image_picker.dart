// lib/core/components/image_picker_modal.dart
import 'dart:io';
import 'package:ctree/core/models/image_file.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerModal extends StatefulWidget {
  final Function(ImageFile?) onImageSelected;

  const ImagePickerModal({Key? key, required this.onImageSelected})
      : super(key: key);

  @override
  _ImagePickerModalState createState() => _ImagePickerModalState();
}

class _ImagePickerModalState extends State<ImagePickerModal> {
  final ImagePicker _picker = ImagePicker();
  ImageFile? _image;

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        if (kIsWeb) {
          // Web implementation
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _image = ImageFile(
              file: bytes,
              url: pickedFile.path,
              isWeb: true,
            );
          });
        } else {
          // Mobile implementation
          setState(() {
            _image = ImageFile(
              file: File(pickedFile.path),
              isWeb: false,
            );
          });
        }
        widget.onImageSelected(_image);
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao selecionar imagem')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Text(
              'Escolher imagem',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _image == null
                ? ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Escolher imagem da galeria'),
                  )
                : _buildSelectedImage(),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImage() {
    if (_image == null) return const SizedBox.shrink();

    if (_image!.isWeb) {
      return Image.memory(_image!.file);
    } else {
      return Image.file(_image!.file as File);
    }
  }
}
