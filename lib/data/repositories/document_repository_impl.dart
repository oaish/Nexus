import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:open_file/open_file.dart';
import '../../domain/models/document.dart';
import '../../domain/repositories/document_repository.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final _uuid = const Uuid();
  late final Directory _documentsDir;

  Future<void> initialize() async {
    final appDir = await getApplicationDocumentsDirectory();
    _documentsDir = Directory(path.join(appDir.path, 'documents'));

    if (!await _documentsDir.exists()) {
      await _documentsDir.create(recursive: true);
    }
  }

  @override
  Future<List<Document>> getAllDocuments() async {
    final files = await _documentsDir.list().toList();
    final documents = <Document>[];

    for (var file in files) {
      if (file is File) {
        final fileName = path.basename(file.path);
        final fileType = path.extension(file.path).toLowerCase();

        documents.add(Document(
          id: _uuid.v4(),
          name: fileName,
          filePath: file.path,
          fileType: fileType,
          createdAt: file.lastModifiedSync(),
        ));
      }
    }

    return documents;
  }

  @override
  Future<Document> addDocument(String filePath) async {
    final fileName = path.basename(filePath);
    final newPath = path.join(_documentsDir.path, fileName);

    // Copy file to documents directory
    await File(filePath).copy(newPath);

    return Document(
      id: _uuid.v4(),
      name: fileName,
      filePath: newPath,
      fileType: path.extension(filePath).toLowerCase(),
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> deleteDocument(String id) async {
    final documents = await getAllDocuments();
    print('All documents: ${documents}');
    final document = documents.firstWhere((doc) => doc.id == id);
    print('Document to delete: ${document}');

    // Delete the file
    final file = File(document.filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<void> openDocument(String filePath) async {
    await OpenFile.open(filePath);
  }
}
