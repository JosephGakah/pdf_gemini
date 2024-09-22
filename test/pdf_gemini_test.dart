import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdf_gemini/pdf_gemini.dart';

void main() {
  group('PDFChatClient', () {
    const geminiApiKey = '';
    final genaiService = GenaiClient(geminiApiKey: geminiApiKey);

    test('Prompt PDF Test', () async {
      // Create a temporary test file
      final testFile = File('').readAsBytesSync();

      try {
        await genaiService.promptDocument(
          'Your file name',
          'pdf',
          testFile,
          'your prompt',
        );
      } catch (e) {
        fail('Failed: $e');
      }
    });
  });
}
