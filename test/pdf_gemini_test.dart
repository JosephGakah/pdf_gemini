import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdf_gemini/pdf_gemini.dart';

void main() {
  group('PDFChatClient', () {
    const geminiApiKey = '';
    final genaiService = GenaiClient(geminiApiKey: geminiApiKey);

    test('Prompt PDF Test', () async {
      // Create a temporary test file
      final testFile = File('your_file_path').readAsBytesSync();

      try {
        await genaiService.promptDocument(
            'file_name', 'pdf', testFile, 'your_prompt');
      } catch (e) {
        fail('Failed: $e');
      }
    });
  });
}
