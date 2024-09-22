class GenaiGeneratedResponseModel {
  final String text;
  final String? citationUri;

  GenaiGeneratedResponseModel({required this.text, this.citationUri});

  // Factory constructor to parse JSON response and extract relevant data
  factory GenaiGeneratedResponseModel.fromJson(Map<String, dynamic> json) {
    // Extract text
    String text = '';
    List<dynamic> candidates = json['candidates'] ?? [];
    if (candidates.isNotEmpty) {
      text = candidates[0]['content']['parts'][0]['text'] ?? '';
    }

    // Extract citation URI
    String? citationUri;
    if (candidates.isNotEmpty && candidates[0]['citationMetadata'] != null) {
      List<dynamic> citationSources =
          candidates[0]['citationMetadata']['citationSources'] ?? [];
      if (citationSources.isNotEmpty) {
        citationUri = citationSources[0]['uri'];
      }
    }

    return GenaiGeneratedResponseModel(text: text, citationUri: citationUri);
  }
}
