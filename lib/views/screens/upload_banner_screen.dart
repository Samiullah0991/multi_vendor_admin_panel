import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../widgets/upload_banner_list.dart';

class UploadBanners extends StatefulWidget {
  static const String id = '\UploadBanners';
  const UploadBanners({super.key});

  @override
  State<UploadBanners> createState() => _UploadBannersState();
}

class _UploadBannersState extends State<UploadBanners> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Uint8List? _imageBytes;
  String? _fileName;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.size > 2 * 1024 * 1024) {
          _showError('Image must be less than 2MB');
          return;
        }

        // Validate image extension
        final ext = file.extension?.toLowerCase();
        if (ext == null || !['jpg', 'jpeg', 'png', 'webp'].contains(ext)) {
          _showError('Only JPG, PNG, or WebP images are allowed');
          return;
        }

        setState(() {
          _imageBytes = file.bytes;
          _fileName = 'banner_${DateTime.now().millisecondsSinceEpoch}.$ext';
        });
      }
    } catch (e) {
      _showError('Failed to pick image: ${e.toString()}');
    }
  }

  Future<String> _uploadImage() async {
    try {
      if (_imageBytes == null) throw Exception('No image selected');

      final ref = _storage.ref('homeBanners').child(_fileName!);
      final metadata = SettableMetadata(
        contentType: 'image/${_fileName!.split('.').last}',
        cacheControl: 'public, max-age=31536000',
      );

      final uploadTask = ref.putData(_imageBytes!, metadata);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      _showError('Upload failed: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> _saveBanner() async {
    if (_imageBytes == null) {
      _showError('Please select an image first');
      return;
    }

    setState(() => _isUploading = true);
    EasyLoading.show(status: 'Uploading...');

    try {
      final imageUrl = await _uploadImage();

      await _firestore.collection('banners').doc(_fileName).set({
        'image': imageUrl,
        'fileName': _fileName,
        'timestamp': FieldValue.serverTimestamp(),
        'createdAt': DateTime.now().toIso8601String(),
      });

      _showSuccess('Banner uploaded successfully!');
      setState(() {
        _imageBytes = null;
        _fileName = null;
      });
    } catch (e) {
      _showError('Failed to save banner: ${e.toString()}');
    } finally {
      setState(() => _isUploading = false);
      EasyLoading.dismiss();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildUploadSection(),
          const Divider(color: Colors.grey),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Banner List',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
          const UploadBannerList(),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        children: [
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: _imageBytes != null
                ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                : const Center(child: Text('No image selected')),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUploadButton(),
              const SizedBox(width: 20),
              _buildSaveButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return ElevatedButton(
      onPressed: _isUploading ? null : _pickImage,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow.shade900,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: const Text(
        'Select Image',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _isUploading || _imageBytes == null ? null : _saveBanner,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: const Text(
        'Upload Banner',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}