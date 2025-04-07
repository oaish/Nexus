import 'package:path/path.dart' as path;

class Document {
  final String id;
  final String name;
  final String filePath;
  final String fileType;
  final DateTime createdAt;

  Document({
    required this.id,
    required this.name,
    required this.filePath,
    required this.fileType,
    required this.createdAt,
  });

  String get extension => path.extension(filePath).toLowerCase();

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] as String,
      name: json['name'] as String,
      filePath: json['filePath'] as String,
      fileType: json['fileType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'filePath': filePath,
      'fileType': fileType,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
