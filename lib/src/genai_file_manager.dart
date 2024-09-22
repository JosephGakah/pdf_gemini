import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:pdf_gemini/src/genai_file_model.dart';

class GenaiFileManager {
  final String geminiApiKey;

  Dio dio = Dio();
  String baseUrl = "https://generativelanguage.googleapis.com";

  Future<GenaiFile> uploadFile(
    String fileName,
    String fileType,
    Uint8List fileData,
  ) async {
    final int fileLength = fileData.lengthInBytes;

    try {
      // Step 1: Start the resumable upload and get the upload URL.
      Response initialResponse = await dio.post(
        '$baseUrl/upload/v1beta/files?key=$geminiApiKey',
        options: Options(headers: {
          'X-Goog-Upload-Protocol': 'resumable',
          'X-Goog-Upload-Command': 'start',
          'X-Goog-Upload-Header-Content-Length': fileLength.toString(),
          'X-Goog-Upload-Header-Content-Type': 'application/pdf',
          'Content-Type': 'application/json',
        }),
        data: {
          'file': {'display_name': fileName}
        },
      );

      final String uploadUrl =
          initialResponse.headers.value('X-Goog-Upload-URL') ?? '';

      if (uploadUrl.isEmpty) {
        throw "Error: No upload URL received";
      }

      // Step 2: Upload the actual bytes using Uint8List.
      Response uploadResponse = await dio.put(
        uploadUrl,
        options: Options(headers: {
          'Content-Length': fileLength.toString(),
          'X-Goog-Upload-Offset': '0',
          'X-Goog-Upload-Command': 'upload, finalize',
        }),
        data: Stream.fromIterable(
          fileData.map((e) => [e]),
        ), // Converts Uint8List to a stream
      );

      if (uploadResponse.statusCode == 200) {
        return GenaiFile.fromJson(uploadResponse.data['file']);
      } else {
        throw 'Error during file upload: ${uploadResponse.statusMessage}';
      }
    } catch (e) {
      throw 'Error uploading file: $e';
    }
  }

  Future<List<GenaiFile>> getUploadedFiles() async {
    try {
      Response response = await dio.get(
        "$baseUrl/v1beta/files?key=$geminiApiKey",
      );

      if (response.statusCode == 200) {
        List<dynamic> filesJson = response.data['files'];
        return filesJson.map((file) => GenaiFile.fromJson(file)).toList();
      } else {
        throw "Failed to retrieve uploaded files. Status code: ${response.statusCode}";
      }
    } catch (e) {
      throw "Failed to retrieve uploaded files";
    }
  }

  Future<GenaiFile> getGenaiFile(
    String fileName,
    String fileType,
    Uint8List fileData,
  ) async {
    try {
      final files = await getUploadedFiles();

      for (var file in files) {
        if (file.displayName == fileName) {
          return file;
        }
      }

      final genaiFile = await uploadFile(
        fileName,
        fileType,
        fileData,
      );

      return genaiFile;
    } catch (e) {
      throw "Error: $e";
    }
  }

  GenaiFileManager({
    required this.geminiApiKey,
  });
}
