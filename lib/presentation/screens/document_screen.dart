import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../core/widgets/nexus_back_button.dart';
import '../../domain/models/document.dart';
import '../../domain/repositories/document_repository.dart';
import '../../data/repositories/document_repository_impl.dart';

class DocumentScreen extends StatefulWidget {
  final DocumentRepository documentRepository;

  const DocumentScreen({
    Key? key,
    required this.documentRepository,
  }) : super(key: key);

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  List<Document> _documents = [];
  bool _isLoading = true;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeRepository();
  }

  Future<void> _initializeRepository() async {
    try {
      if (widget.documentRepository is DocumentRepositoryImpl) {
        await (widget.documentRepository as DocumentRepositoryImpl)
            .initialize();
      }
      setState(() => _isInitialized = true);
      await _loadDocuments();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isInitialized = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing repository: $e')),
        );
      }
    }
  }

  Future<void> _loadDocuments() async {
    if (!_isInitialized) return;

    setState(() => _isLoading = true);
    try {
      final documents = await widget.documentRepository.getAllDocuments();
      if (mounted) {
        setState(() {
          _documents = documents;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading documents: $e')),
        );
      }
    }
  }

  Future<void> _pickAndAddDocument() async {
    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Repository not initialized')),
      );
      return;
    }

    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        await widget.documentRepository.addDocument(file.path);
        await _loadDocuments();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding document: $e')),
        );
      }
    }
  }

  Future<void> _deleteDocument(Document document) async {
    if (!_isInitialized) return;

    try {
      await widget.documentRepository.deleteDocument(document.id);
      await _loadDocuments();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting document: $e')),
        );
      }
    }
  }

  Future<void> _openDocument(Document document) async {
    if (!_isInitialized) return;

    try {
      await widget.documentRepository.openDocument(document.filePath);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening document: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: NexusBackButton(
                isExtended: true,
                extendedChild: Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Document Manager',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Orbitron',
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: GestureDetector(
                        onTap: _isInitialized ? _pickAndAddDocument : null,
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedAddSquare,
                          color: colorScheme.onPrimary,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: !_isInitialized
                  ? const Center(
                      child: Text('Initializing...',
                          style: TextStyle(fontFamily: 'Orbitron')))
                  : _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _documents.isEmpty
                          ? const Center(
                              child: Text('No documents yet',
                                  style: TextStyle(fontFamily: 'Orbitron')))
                          : GridView.builder(
                              padding: const EdgeInsets.all(8),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: _documents.length,
                              itemBuilder: (context, index) {
                                final document = _documents[index];
                                return Card(
                                  child: InkWell(
                                    onTap: () => _openDocument(document),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: HugeIcon(
                                              icon: _getIconForFileType(
                                                  document.fileType),
                                              size: 72,
                                              color: _getIconColorForFileType(
                                                  document.fileType),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                document.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontFamily: 'Orbitron',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                document.fileType.toUpperCase(),
                                                style: TextStyle(
                                                  fontFamily: 'Orbitron',
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForFileType(String fileType) {
    switch (fileType.toLowerCase()) {
      case '.pdf':
        return HugeIcons.strokeRoundedPdf02;
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
        return HugeIcons.strokeRoundedImage02;
      case '.doc':
      case '.docx':
        return HugeIcons.strokeRoundedDoc02;
      case '.xls':
      case '.xlsx':
        return HugeIcons.strokeRoundedGoogleSheet;
      case '.ppt':
      case '.pptx':
        return HugeIcons.strokeRoundedPresentationBarChart02;
      case '.txt':
        return HugeIcons.strokeRoundedTxt02;
      case '.csv':
        return HugeIcons.strokeRoundedCsv02;
      case '.zip':
        return HugeIcons.strokeRoundedZip02;
      case '.rar':
        return HugeIcons.strokeRoundedRar02;
      case '.exe':
        return HugeIcons.strokeRoundedWindowsOld;
      case '.c':
      case '.cpp':
      case '.h':
      case '.hpp':
      case '.java':
      case '.class':
      case '.js':
      case '.jsx':
      case '.ts':
      case '.tsx':
      case '.css':
      case '.html':
      case '.php':
      case '.py':
      case '.rb':
      case '.swift':
      case '.kotlin':
      case '.go':
      case '.dart':
      case '.json':
      case '.xml':
      case '.yaml':
      case '.yml':
        return HugeIcons.strokeRoundedSourceCode;

      default:
        return HugeIcons.strokeRoundedFileEmpty02;
    }
  }

  Color _getIconColorForFileType(String fileType) {
    switch (fileType.toLowerCase()) {
      case '.pdf':
        return Colors.red;
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
        return Colors.orange;
      case '.doc':
      case '.docx':
        return Colors.blue;
      case '.xls':
      case '.xlsx':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
