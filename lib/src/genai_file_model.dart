class GenaiFile {
  final String name;
  final String displayName;
  final String mimeType;
  final int sizeBytes;
  final DateTime createTime;
  final DateTime updateTime;
  final DateTime expirationTime;
  final String sha256Hash;
  final String uri;
  final String state;

  // Constructor
  GenaiFile({
    required this.name,
    required this.displayName,
    required this.mimeType,
    required this.sizeBytes,
    required this.createTime,
    required this.updateTime,
    required this.expirationTime,
    required this.sha256Hash,
    required this.uri,
    required this.state,
  });

  // Factory constructor to create an GenaiFile instance from a map (JSON)
  factory GenaiFile.fromJson(Map<String, dynamic> json) {
    return GenaiFile(
      name: json['name'],
      displayName: json['displayName'],
      mimeType: json['mimeType'],
      sizeBytes: int.parse(json['sizeBytes']),
      createTime: DateTime.parse(json['createTime']),
      updateTime: DateTime.parse(json['updateTime']),
      expirationTime: DateTime.parse(json['expirationTime']),
      sha256Hash: json['sha256Hash'],
      uri: json['uri'],
      state: json['state'],
    );
  }

  // Method to convert an GenaiFile instance back to JSON format
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'displayName': displayName,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes.toString(),
      'createTime': createTime.toIso8601String(),
      'updateTime': updateTime.toIso8601String(),
      'expirationTime': expirationTime.toIso8601String(),
      'sha256Hash': sha256Hash,
      'uri': uri,
      'state': state,
    };
  }
}
