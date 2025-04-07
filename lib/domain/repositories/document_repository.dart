import '../models/document.dart';

abstract class DocumentRepository {
  Future<List<Document>> getAllDocuments();
  Future<Document> addDocument(String filePath);
  Future<void> deleteDocument(String id);
  Future<void> openDocument(String filePath);
}
