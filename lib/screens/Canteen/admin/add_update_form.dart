import 'dart:io';
import 'dart:convert';

import 'package:CampusCompass/screens/Canteen/admin/logic/food_item_cubit.dart';
import 'package:CampusCompass/screens/Canteen/admin/models/food_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class FoodItemForm extends StatefulWidget {
  bool? isEditing;
  FoodItem? item;
  FoodItemForm({
    Key? key,
    this.item,
    this.isEditing,
  }) : super(key: key);

  @override
  _FoodItemFormState createState() => _FoodItemFormState();
}

class _FoodItemFormState extends State<FoodItemForm> {
  final Map<String, dynamic> _foodItem = {};
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _storedImage;
  String? _storedImageURL;
  bool isUpdated = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _cameraImage() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 200,
      maxWidth: 200,
      imageQuality: 100,
    );
    if (imageFile == null) return;
    setState(() {
      _storedImage = File(imageFile.path);
      _storedImageURL = base64UrlEncode(_storedImage!.readAsBytesSync());
    });
  }

  Future<void> _fileImage() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 200,
      maxWidth: 200,
    );
    if (imageFile == null) return;
    setState(() {
      isUpdated = true;
      _storedImage = File(imageFile.path);
      _storedImageURL = base64UrlEncode(_storedImage!.readAsBytesSync());
    });
  }

  void _saveFoodItem() {
    final name = _nameController.text;
    final price = _priceController.text;

    if (_storedImage == null && widget.isEditing == null) {
      _storedImageURL =
          '_9j_4QBqRXhpZgAATU0AKgAAAAgABAEAAAQAAAABAAAAWQEBAAQAAAABAAAAyIdpAAQAAAABAAAAPgESAAMAAAABAAAAAAAAAAAAAZIIAAQAAAABAAAAAAAAAAAAAQESAAMAAAABAAAAAAAAAAD_4AAQSkZJRgABAQAAAQABAAD_4gIoSUNDX1BST0ZJTEUAAQEAAAIYAAAAAAQwAABtbnRyUkdCIFhZWiAAAAAAAAAAAAAAAABhY3NwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAA9tYAAQAAAADTLQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlkZXNjAAAA8AAAAHRyWFlaAAABZAAAABRnWFlaAAABeAAAABRiWFlaAAABjAAAABRyVFJDAAABoAAAAChnVFJDAAABoAAAAChiVFJDAAABoAAAACh3dHB0AAAByAAAABRjcHJ0AAAB3AAAADxtbHVjAAAAAAAAAAEAAAAMZW5VUwAAAFgAAAAcAHMAUgBHAEIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFhZWiAAAAAAAABvogAAOPUAAAOQWFlaIAAAAAAAAGKZAAC3hQAAGNpYWVogAAAAAAAAJKAAAA-EAAC2z3BhcmEAAAAAAAQAAAACZmYAAPKnAAANWQAAE9AAAApbAAAAAAAAAABYWVogAAAAAAAA9tYAAQAAAADTLW1sdWMAAAAAAAAAAQAAAAxlblVTAAAAIAAAABwARwBvAG8AZwBsAGUAIABJAG4AYwAuACAAMgAwADEANv_bAEMAAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQ';
    }

    if (name.isEmpty && widget.isEditing == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter a name for the food item.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    if (price.isEmpty && widget.isEditing == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter a price for the food item.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    if (widget.isEditing == null) {
      setState(() {
        _foodItem['photo'] = _storedImageURL!;
        _foodItem['name'] = name;
        _foodItem['price'] = int.parse(price);
      });
    } else {
      setState(() {
        _foodItem['photo'] = _storedImageURL ?? widget.item!.image;
        _foodItem['name'] = name.isNotEmpty ? name : widget.item!.name;
        _foodItem['price'] =
            int.parse(price.isNotEmpty ? price : widget.item!.price.toString());
      });
    }

    BlocProvider.of<FoodItemCubit>(context).postFoodItem(
        _foodItem..addAll({'availability': true}), widget.isEditing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food Item'),
      ),
      body: BlocConsumer<FoodItemCubit, FoodItemState>(
        listener: (context, state) {
          if (state is FoodItemSuccessState) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar
              ..showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Food item saved successfully!'),
                ),
              );
            Navigator.pop(context);
          } else if (state is FoodItemErrorState) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar
              ..showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Error saving food item.'),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state is FoodItemInitialState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Preview selected photo (if any)
                  if (widget.item == null || isUpdated == true)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      height: _storedImageURL == null ? 0 : 250,
                      width: _storedImageURL == null ? 0 : 250,
                      child: _storedImageURL == null
                          ? null
                          : Image.memory(base64Decode(_storedImageURL!)),
                    ),

                  if (widget.item != null && isUpdated == false)
                    Column(children: [
                      const SizedBox(height: 6.0),
                      const Text(
                        'Preview uploaded photo',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      SizedBox(
                        height: 250,
                        width: 250,
                        child: Image.memory(
                          base64Decode(widget.item!.image!),
                        ),
                      ),
                    ]),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo),
                    label: Text(
                      widget.item == null ? 'Select Photo' : 'Select New Photo',
                    ),
                    onPressed: _fileImage,
                  ),

                  // Food item name input
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText:
                          widget.item == null ? 'Name' : widget.item!.name,
                      border: const OutlineInputBorder(),
                    ),
                  ),

                  // Food item price
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: widget.item == null
                          ? 'Price'
                          : '₹ ${widget.item!.price.toString()}',
                      border: const OutlineInputBorder(),
                    ),
                  ),

                  // Save button
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _saveFoodItem,
                    child: const Text('Save'),
                  ),
                ],
              ),
            );
          } else if (state is FoodItemLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FoodItemErrorState) {
            return Center(
                child: Text('Error saving food item: ${state.error}'));
          } else {
            return const Center(child: Text('Unknown error'));
          }
        },
      ),
    );
  }
}
