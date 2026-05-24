import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

enum UploadDestination { firebase, externalApi }

final fileUploadServiceProvider = Provider<FileUploadService>((ref) {
  // You would normally watch your configured Dio provider here
  return FileUploadService(Dio());
});

class FileUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Dio _dio;

  FileUploadService(this._dio);

  /// Uploads a file and returns the public download URL.
  Future<String> uploadFile({
    required File file,
    required String pathPrefix, // e.g., 'users/avatars'
    UploadDestination destination = UploadDestination.firebase,
    String? apiUrl, // Required if destination is externalApi
  }) async {
    final fileName = p.basename(file.path);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uniqueFileName = '${timestamp}_$fileName';

    try {
      if (destination == UploadDestination.firebase) {
        return await _uploadToFirebase(file, '$pathPrefix/$uniqueFileName');
      } else {
        if (apiUrl == null) throw Exception('API URL is required for externalApi upload.');
        return await _uploadToExternalApi(file, apiUrl);
      }
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  Future<String> _uploadToFirebase(File file, String storagePath) async {
    final ref = _storage.ref().child(storagePath);
    final uploadTask = await ref.putFile(file);
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> _uploadToExternalApi(File file, String apiUrl) async {
    final fileName = p.basename(file.path);

    // Package the file into a MultiPart form
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      // Add other required form fields here if your API needs them
    });

    final response = await _dio.post(
      apiUrl,
      data: formData,
      options: Options(
        headers: {
          "Content-Type": "multipart/form-data",
          // "Authorization": "Bearer YOUR_TOKEN",
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Adjust this based on how your specific API returns the URL
      return response.data['url'] ?? 'Success';
    } else {
      throw Exception('API rejected the upload with status: ${response.statusCode}');
    }
  }
}