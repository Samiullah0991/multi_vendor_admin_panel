import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_admin_panel/views/widgets/category_widget.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = '\categoryScreen';
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String categoryName;
  Uint8List? _imageBytes;
  String? _fileName;
  String? _fileExtension;

  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        final file = result.files.first;

        // Validate image type
        if (!_isValidImageType(file.extension)) {
          EasyLoading.showError('Invalid image type. Please upload JPEG, PNG, or WebP');
          return;
        }

        setState(() {
          _imageBytes = file.bytes;
          _fileName = '${DateTime.now().millisecondsSinceEpoch}.${file.extension}';
          _fileExtension = file.extension?.toLowerCase();
        });
      }
    } catch (e) {
      EasyLoading.showError('Error picking image: ${e.toString()}');
    }
  }

  bool _isValidImageType(String? extension) {
    if (extension == null) return false;
    final validTypes = ['jpg', 'jpeg', 'png', 'webp'];
    return validTypes.contains(extension.toLowerCase());
  }

  Future<String> _uploadImageToStorage(Uint8List imageBytes) async {
    try {
      Reference ref = _firebaseStorage.ref().child('category').child(_fileName!);
      UploadTask uploadTask = ref.putData(imageBytes);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      EasyLoading.showError('Error uploading image');
      throw e;
    }
  }

  Future<void> uploadToFirebase() async {
    if (!_formKey.currentState!.validate()) {
      EasyLoading.showError('Please fill all fields correctly');
      return;
    }

    if (_imageBytes == null) {
      EasyLoading.showError('Please select an image');
      return;
    }

    try {
      EasyLoading.show(status: 'Uploading...');

      String imageUrl = await _uploadImageToStorage(_imageBytes!);

      await _firestore.collection('categories').doc(_fileName).set({
        'image': imageUrl,
        'categoryName': categoryName,
        'createdAt': FieldValue.serverTimestamp(),
        'fileExtension': _fileExtension,
      });

      setState(() {
        _formKey.currentState!.reset();
        _imageBytes = null;
        _fileName = null;
      });

      EasyLoading.showSuccess('Category uploaded successfully');
    } catch (e) {
      EasyLoading.showError('Error uploading category: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Categories',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                    ),
                  ),
                ),
                const Divider(color: Colors.grey),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        children: [
                          Container(
                            height: 140,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade500,
                              border: Border.all(color: Colors.grey.shade800),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: _imageBytes != null
                                  ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                                  : const Text('Category Image'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow.shade900,
                            ),
                            onPressed: pickImage,
                            child: const Text(
                              'Upload Image',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        onChanged: (value) => categoryName = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Category name cannot be empty';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Enter Category Name',
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        side: MaterialStateProperty.all(
                          BorderSide(color: Colors.yellow.shade900),
                        ),
                      ),
                      onPressed: () {
                        _formKey.currentState?.reset();
                        setState(() {
                          _imageBytes = null;
                        });
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade900,
                      ),
                      onPressed: uploadToFirebase,
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.grey),
              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Category List',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
          const SizedBox(height: 15),
          const CategoryListWidget(),
        ],
      ),
    );
  }
}