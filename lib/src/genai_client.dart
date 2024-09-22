import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:pdf_gemini/pdf_gemini.dart';
import 'package:pdf_gemini/src/genai_generated_response_model.dart';

class GenaiClient {
  final String geminiApiKey;
  final GenaiFileManager genaiFileManager;
  String baseUrl = "https://generativelanguage.googleapis.com/v1beta";

  GenaiClient({required this.geminiApiKey})
      : genaiFileManager = GenaiFileManager(geminiApiKey: geminiApiKey);

  Future<GenaiGeneratedResponseModel> promptDocument(
    String fileName,
    String fileType,
    Uint8List fileData,
    String prompt,
  ) async {
    try {
      final file = await genaiFileManager.getGenaiFile(
        fileName,
        fileType,
        fileData,
      );

      final response = await Dio().post(
        '$baseUrl/models/gemini-1.5-flash:generateContent?key=$geminiApiKey',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": "Can you add a few more lines to this poem?"},
                {
                  "file_data": {
                    "mime_type": "application/$fileType",
                    "file_uri": file.uri,
                  }
                }
              ]
            }
          ]
        }),
      );

      var genaiResponse = GenaiGeneratedResponseModel.fromJson(response.data);

      return genaiResponse;
    } catch (e) {
      throw "Error $e";
    }
  }
}
