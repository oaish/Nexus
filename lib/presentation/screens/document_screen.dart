import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import '../../core/widgets/nexus_back_button.dart';
import '../../core/utils/toast_helper.dart';
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
  bool _isGridView = true;
  bool _isBackingUp = false;
  final _supabase = Supabase.instance.client;
  Set<String> _backedUpFiles = {};

  @override
  void initState() {
    super.initState();
    _initializeRepository();
    _loadBackedUpFiles();
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
        ToastHelper.showErrorToast(
            context, 'Error initializing repository: $e');
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
        ToastHelper.showErrorToast(context, 'Error loading documents: $e');
      }
    }
  }

  Future<void> _pickAndAddDocument() async {
    if (!_isInitialized) {
      ToastHelper.showErrorToast(context, 'Repository not initialized');
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
        ToastHelper.showErrorToast(context, 'Error adding document: $e');
      }
    }
  }

  Future<void> _deleteDocument(Document document) async {
    if (!_isInitialized) return;

    try {
      // Show confirmation dialog
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Document'),
          content: Text('Are you sure you want to delete "${document.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (shouldDelete != true) return;

      final documentExists = _documents.any((doc) => doc.id == document.id);
      if (!documentExists) {
        if (mounted) {
          ToastHelper.showErrorToast(context, 'Document no longer exists');
        }
        return;
      }

      // Delete from local storage
      final file = File(document.filePath);
      if (await file.exists()) {
        await file.delete();
      }

      setState(() {
        _backedUpFiles.remove(document.name);
      });

      // Refresh the documents list
      await _loadDocuments();

      if (mounted) {
        ToastHelper.showSuccessToast(context, 'Document deleted successfully');
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showErrorToast(context, 'Error deleting document: $e');
      }
    }
  }

  Future<void> _openDocument(Document document) async {
    if (!_isInitialized) return;

    try {
      await widget.documentRepository.openDocument(document.filePath);
    } catch (e) {
      if (mounted) {
        ToastHelper.showErrorToast(context, 'Error opening document: $e');
      }
    }
  }

  Future<void> _shareDocument(Document document) async {
    try {
      await Share.shareXFiles([XFile(document.filePath)], text: document.name);
    } catch (e) {
      if (mounted) {
        ToastHelper.showErrorToast(context, 'Error sharing document: $e');
      }
    }
  }

  Future<void> _loadBackedUpFiles() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response =
          await _supabase.storage.from('documents').list(path: userId);
      setState(() {
        _backedUpFiles = response.map((file) => file.name).toSet();
      });
    } catch (e) {
      print('Error loading backed up files: $e');
    }
  }

  Future<void> _backupToSupabase() async {
    if (!_isInitialized) return;

    setState(() => _isBackingUp = true);
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      for (var document in _documents) {
        final file = File(document.filePath);
        if (await file.exists()) {
          final fileName = document.name;
          final cloudPath = path.join(userId, fileName);

          // Skip if file is already backed up
          if (_backedUpFiles.contains(fileName)) {
            print('Skipping already backed up file: $fileName');
            continue;
          }

          final fileBytes = await file.readAsBytes();
          print('Uploading file: $fileName');

          await _supabase.storage
              .from('documents')
              .uploadBinary(cloudPath, fileBytes);

          setState(() {
            _backedUpFiles.add(fileName);
          });
        }
      }
      if (mounted) {
        ToastHelper.showSuccessToast(
            context, 'Documents backed up successfully');
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showErrorToast(context, 'Error backing up documents: $e\n');
        print('Error backing up documents: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isBackingUp = false);
      }
    }
  }

  Future<void> _downloadFromCloud(Document document) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final cloudPath = path.join(userId, document.name);
      final response =
          await _supabase.storage.from('documents').download(cloudPath);

      final file = File(document.filePath);
      await file.writeAsBytes(response);

      await _loadDocuments();

      if (mounted) {
        ToastHelper.showSuccessToast(
            context, 'Document downloaded successfully');
      }
    } catch (e) {
      if (mounted) {
        ToastHelper.showErrorToast(context, 'Error downloading document: $e');
      }
    }
  }

  Future<bool> _isFileInCloud(String fileName) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final cloudPath = path.join(userId, fileName);
      final response =
          await _supabase.storage.from('documents').list(path: userId);
      return response.any((file) => file.name == fileName);
    } catch (e) {
      return false;
    }
  }

  void _showDocumentDetails(Document document) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Document Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: 'Orbitron',
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Name', document.name),
            _buildDetailRow('Type', document.fileType.toUpperCase()),
            _buildDetailRow('Size',
                '${(File(document.filePath).lengthSync() / 1024).toStringAsFixed(2)} KB'),
            _buildDetailRow('Path', document.filePath),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Orbitron',
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'Orbitron'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isBackingUp
                            ? HugeIcons.strokeRoundedCloudUpload
                            : HugeIcons.strokeRoundedCloud,
                        color: colorScheme.primary,
                      ),
                      onPressed: _isBackingUp ? null : _backupToSupabase,
                      tooltip: 'Backup to cloud',
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        _isGridView
                            ? HugeIcons.strokeRoundedGridView
                            : HugeIcons.strokeRoundedListView,
                        color: colorScheme.primary,
                      ),
                      onPressed: () =>
                          setState(() => _isGridView = !_isGridView),
                      tooltip: _isGridView
                          ? 'Switch to list view'
                          : 'Switch to grid view',
                    ),
                  ],
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
                            : _isGridView
                                ? GridView.builder(
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
                                      return _buildDocumentCard(document);
                                    },
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(8),
                                    itemCount: _documents.length,
                                    itemBuilder: (context, index) {
                                      final document = _documents[index];
                                      return _buildDocumentListItem(document);
                                    },
                                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentCard(Document document) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = _getIconColorForFileType(document.fileType);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _openDocument(document),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      iconColor.withOpacity(0.2),
                      iconColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: HugeIcon(
                        icon: _getIconForFileType(document.fileType),
                        size: 72,
                        color: iconColor,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        children: [
                          FutureBuilder<bool>(
                            future: _isFileInCloud(document.name),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data == true) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    icon: HugeIcon(
                                      icon:
                                          HugeIcons.strokeRoundedCloudDownload,
                                      size: 20,
                                      color: colorScheme.primary,
                                    ),
                                    onPressed: () =>
                                        _downloadFromCloud(document),
                                    tooltip: 'Download from cloud',
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: colorScheme.surface.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert,
                                  color: colorScheme.primary),
                              onSelected: (value) {
                                switch (value) {
                                  case 'open':
                                    _openDocument(document);
                                    break;
                                  case 'share':
                                    _shareDocument(document);
                                    break;
                                  case 'details':
                                    _showDocumentDetails(document);
                                    break;
                                  case 'delete':
                                    _deleteDocument(document);
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'open',
                                  child: Row(
                                    children: [
                                      HugeIcon(
                                        icon: HugeIcons.strokeRoundedEye,
                                        color: colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('Open'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'share',
                                  child: Row(
                                    children: [
                                      HugeIcon(
                                        icon: HugeIcons.strokeRoundedShare02,
                                        color: colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('Share'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'details',
                                  child: Row(
                                    children: [
                                      HugeIcon(
                                        icon: HugeIcons
                                            .strokeRoundedInformationCircle,
                                        color: colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('Details'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      HugeIcon(
                                        icon: HugeIcons.strokeRoundedDelete02,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('Delete',
                                          style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(12)),
                border: Border(
                  top: BorderSide(
                    color: iconColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      document.fileType.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        color: iconColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentListItem(Document document) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = _getIconColorForFileType(document.fileType);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _openDocument(document),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      iconColor.withOpacity(0.2),
                      iconColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: HugeIcon(
                  icon: _getIconForFileType(document.fileType),
                  size: 32,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        document.fileType.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          color: iconColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  FutureBuilder<bool>(
                    future: _isFileInCloud(document.name),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data == true) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedCloudDownload,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                            onPressed: () => _downloadFromCloud(document),
                            tooltip: 'Download from cloud',
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: colorScheme.primary),
                      onSelected: (value) {
                        switch (value) {
                          case 'open':
                            _openDocument(document);
                            break;
                          case 'share':
                            _shareDocument(document);
                            break;
                          case 'details':
                            _showDocumentDetails(document);
                            break;
                          case 'delete':
                            _deleteDocument(document);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'open',
                          child: Row(
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedEye,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              const Text('Open'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'share',
                          child: Row(
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedShare02,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              const Text('Share'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'details',
                          child: Row(
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedInformationCircle,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              const Text('Details'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedDelete02,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 8),
                              const Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
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
        return const Color(0xFFE57373); // Vibrant red
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.gif':
        return const Color(0xFFFFB74D); // Vibrant orange
      case '.doc':
      case '.docx':
        return const Color(0xFF64B5F6); // Vibrant blue
      case '.xls':
      case '.xlsx':
        return const Color(0xFF81C784); // Vibrant green
      case '.ppt':
      case '.pptx':
        return const Color(0xFFBA68C8); // Vibrant purple
      case '.txt':
        return const Color(0xFF90A4AE); // Vibrant blue-grey
      case '.csv':
        return const Color(0xFF4DB6AC); // Vibrant teal
      case '.zip':
      case '.rar':
        return const Color(0xFFF06292); // Vibrant pink
      case '.exe':
        return const Color(0xFF7986CB); // Vibrant indigo
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
        return const Color(0xFF9575CD); // Vibrant deep purple
      default:
        return const Color(0xFF78909C); // Vibrant blue-grey
    }
  }
}
