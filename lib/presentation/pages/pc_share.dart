import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../widgets/nexus_back_button.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  WebSocketChannel? channel;
  List<String> fileList = [];
  bool isConnected = false;
  bool scannedOnce = false;
  final TextEditingController _manualInputController = TextEditingController();
  bool _isManualInputMode = false;

  @override
  void dispose() {
    controller?.dispose();
    channel?.sink.close();
    _manualInputController.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController ctrl) {
    controller = ctrl;
    ctrl.scannedDataStream.listen((scanData) {
      if (!scannedOnce && scanData.code != null) {
        scannedOnce = true;
        controller?.pauseCamera();
        _connectToServer(scanData.code!);
      }
    });
  }

  void _connectToServer(String qrData) {
    try {
      final decoded = jsonDecode(qrData);
      final wsUrl = decoded['wsUrl'] as String?;
      final sessionId = decoded['sessionId'] as String?;

      if (wsUrl == null || sessionId == null) {
        throw Exception('Invalid QR code data');
      }

      channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      channel?.sink.add(jsonEncode({'type': 'init', 'sessionId': sessionId}));

      channel?.stream.listen((message) async {
        final data = jsonDecode(message);

        switch (data['type']) {
          case 'init-ok':
            channel?.sink.add(jsonEncode({'type': 'client-connected'}));
            break;

          case 'ready':
            channel?.sink.add(jsonEncode({'type': 'list'}));
            break;

          case 'list':
            final files = data['files'];
            setState(() {
              fileList = (files == null || files.isEmpty)
                  ? []
                  : List<String>.from(files);
              isConnected = true;
            });

            if (files == null || files.isEmpty) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('📭 No files available')),
              );
            }
            break;

          case 'file':
            final fileName = data['name'] as String?;
            final fileContent = data['content'] as String?;
            if (fileName != null && fileContent != null) {
              await _downloadFile(fileName, fileContent);
            }
            break;

          case 'expired':
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("⚠️ Session expired")),
            );
            Future.delayed(const Duration(milliseconds: 500), () {
              if (!mounted) return;
              setState(() {
                isConnected = false;
                fileList.clear();
                scannedOnce = false;
              });
              if (!Platform.isWindows && !_isManualInputMode) {
                controller?.resumeCamera();
              }
            });
            break;
        }
      }, onError: (error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('WebSocket Error: $error')),
        );
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Invalid QR or connection failed: $e')),
      );
    }
  }

  Future<void> _downloadFile(String name, String base64Content) async {
    try {
      PermissionStatus status;

      if (Platform.isAndroid) {
        if (await Permission.storage.isGranted) {
          status = PermissionStatus.granted;
        } else {
          if (await Permission.manageExternalStorage.request().isGranted) {
            status = PermissionStatus.granted;
          } else {
            status = await Permission.storage.request();
          }
        }
      } else {
        status =
            PermissionStatus.granted; // Windows doesn't need storage permission
      }

      if (!status.isGranted) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Storage permission denied')),
        );
        return;
      }

      final bytes = base64Decode(base64Content);

      Directory? dir;
      if (Platform.isWindows) {
        // Use Downloads folder on Windows
        final downloadsPath =
            '${Platform.environment['USERPROFILE']}\\Downloads';
        dir = Directory(downloadsPath);
        if (!await dir.exists()) {
          dir = await getApplicationDocumentsDirectory();
        }
      } else {
        dir = Directory('/storage/emulated/0/Download');
        if (!await dir.exists()) {
          dir = await getExternalStorageDirectory();
        }
      }

      if (dir == null) {
        throw Exception('Could not access storage directory');
      }

      final file = File('${dir.path}/$name');
      await file.writeAsBytes(bytes);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Downloaded: ${file.path}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to download: $e')),
      );
    }
  }

  Future<void> _uploadFileToServer() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.single.path == null) return;

    final path = result.files.single.path!;
    final name = result.files.single.name;
    final bytes = await File(path).readAsBytes();

    if (bytes.length > 10 * 1024 * 1024) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ File too large (max 10 MB)')),
      );
      return;
    }

    final uploadMessage = jsonEncode({
      'type': 'upload',
      'name': "${name.split('.').first}-receivedfile.${name.split('.').last}",
      'content': base64Encode(bytes),
    });

    channel?.sink.add(uploadMessage);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('📤 Uploaded: $name')),
    );
  }

  void _requestFile(String fileName) {
    channel?.sink.add(jsonEncode({'type': 'download', 'file': fileName}));
  }

  void _logoutAndReturnToScan() {
    channel?.sink.close();
    setState(() {
      isConnected = false;
      fileList.clear();
      scannedOnce = false;
    });
    if (!Platform.isWindows && !_isManualInputMode) {
      controller?.resumeCamera();
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("👋 Logged out")),
    );
  }

  void _handleManualInput() {
    final input = _manualInputController.text.trim();
    if (input.isNotEmpty) {
      _connectToServer(input);
    }
  }

  void _toggleInputMode() {
    setState(() {
      _isManualInputMode = !_isManualInputMode;
      if (_isManualInputMode) {
        controller?.pauseCamera();
      } else {
        controller?.resumeCamera();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = const Color(0xFF4E7CFF);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            NexusBackButton(
              isExtended: true,
              extendedChild: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'PC Share',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Orbitron',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isConnected
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 28, 20, 12),
                          child: Text(
                            "Available Files",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Orbitron',
                            ),
                          ),
                        ),
                        Expanded(
                          child: FileListView(
                            files: fileList,
                            onFileTap: _requestFile,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _uploadFileToServer,
                                  icon: const Icon(Icons.upload_file),
                                  label: const Text('Upload File'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              IconButton(
                                onPressed: _logoutAndReturnToScan,
                                icon: const Icon(Icons.logout),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.red.withOpacity(0.1),
                                  foregroundColor: Colors.red,
                                  padding: const EdgeInsets.all(12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Platform.isWindows
                      ? _buildWindowsInputScreen()
                      : _buildAndroidConnectionScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAndroidConnectionScreen() {
    final primaryColor = const Color(0xFF4E7CFF);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedComputerPhoneSync,
                size: 80,
                color: primaryColor.withOpacity(0.7),
              ),
              const SizedBox(height: 32),
              const Text(
                "Connect to PC",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Orbitron',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Choose how you want to connect",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontFamily: 'Orbitron',
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildConnectionOption(
                    icon: HugeIcons.strokeRoundedQrCode,
                    title: "Scan QR Code",
                    isSelected: !_isManualInputMode,
                    onTap: () {
                      if (_isManualInputMode) {
                        _toggleInputMode();
                      }
                    },
                  ),
                  const SizedBox(width: 24),
                  _buildConnectionOption(
                    icon: HugeIcons.strokeRoundedKeyboard,
                    title: "Enter Code",
                    isSelected: _isManualInputMode,
                    onTap: () {
                      if (!_isManualInputMode) {
                        _toggleInputMode();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: _isManualInputMode
              ? _buildManualInputScreen()
              : QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: primaryColor,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: MediaQuery.of(context).size.width * 0.8,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildConnectionOption({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final primaryColor = const Color(0xFF4E7CFF);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(
              icon: icon,
              size: 32,
              color: isSelected ? Colors.white : primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Orbitron',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWindowsInputScreen() {
    final primaryColor = const Color(0xFF4E7CFF);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedComputerPhoneSync,
            size: 80,
            color: primaryColor.withOpacity(0.7),
          ),
          const SizedBox(height: 32),
          const Text(
            "Enter Connection Code",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Orbitron',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Paste the connection code from your PC",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontFamily: 'Orbitron',
            ),
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _manualInputController,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Orbitron',
              ),
              decoration: InputDecoration(
                hintText: "Paste connection code here",
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontFamily: 'Orbitron',
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _handleManualInput,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Connect",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Orbitron',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualInputScreen() {
    final primaryColor = const Color(0xFF4E7CFF);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Enter Connection Code",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Orbitron',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Paste the connection code from your PC",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontFamily: 'Orbitron',
            ),
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _manualInputController,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Orbitron',
              ),
              decoration: InputDecoration(
                hintText: "Paste connection code here",
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontFamily: 'Orbitron',
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _handleManualInput,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Connect",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Orbitron',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FileListView extends StatelessWidget {
  final List<String> files;
  final Function(String) onFileTap;

  const FileListView({
    super.key,
    required this.files,
    required this.onFileTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF4E7CFF);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final fileName = files[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: Colors.white.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedFile01,
                color: primaryColor,
                size: 24,
              ),
            ),
            title: Text(
              fileName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Orbitron',
              ),
            ),
            trailing: IconButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedDownload01,
                color: primaryColor,
                size: 24,
              ),
              onPressed: () => onFileTap(fileName),
            ),
            onTap: () => onFileTap(fileName),
          ),
        );
      },
    );
  }
}
