import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({Key? key}) : super(key: key);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _image;
  bool isUploading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      maxHeight: 1080,
      maxWidth: 1920,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('No image selected'),
                content: const Text('Please select an image to upload'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ));
      return;
    }

    setState(() {
      isUploading = true;
    });

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Image Uploaded!'),
              content: const Text('You can preview the image in the app now'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ));

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('meals');
    await collectionReference.doc(DateTime.now().toString()).set({
      'image': base64Encode(_image!.readAsBytesSync()),
    });

    setState(() {
      isUploading = false;
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isUploading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedContainer(
                padding: const EdgeInsets.all(20),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                height: 500,
                width: 250,
                child: _image == null
                    ? const Center(
                        child: Text('No Image Selected'),
                      )
                    : Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _getImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _getImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: FloatingActionButton(
                  onPressed: _uploadImage,
                  child: const Icon(Icons.upload),
                ),
              ),
            ],
          );
  }
}
