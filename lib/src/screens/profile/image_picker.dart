import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerDialog extends StatelessWidget {
  final Function(ImageSource) onImageSourceSelected;

  const ImagePickerDialog({super.key, required this.onImageSourceSelected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Selectati poza"),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            GestureDetector(
              child: const Text("Cameră"),
              onTap: () {
                onImageSourceSelected(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
            const Padding(padding: EdgeInsets.all(8.0)),
            GestureDetector(
              child: const Text("Galerie"),
              onTap: () {
                onImageSourceSelected(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: unused_element
void _selectImage(ImageSource source) async {
  // ignore: unused_local_variable
  final pickedFile = await ImagePicker().pickImage(source: source);
}
