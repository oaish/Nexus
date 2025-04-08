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

  @override
  void dispose() {
    controller?.dispose();
    channel?.sink.close();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController ctrl) {
    controller = ctrl;
    ctrl.scannedDataStream.listen((scanData) {
      if (!scannedOnce && scanData.code != null) {
        scannedOnce = true;
        controller!.pauseCamera();
        _connectToServer(scanData.code!);
      }
    });
  }

  void _connectToServer(String qrData) {
    try {
      final decoded = jsonDecode(qrData);
      final wsUrl = decoded['wsUrl'];
      final sessionId = decoded['sessionId'];

      channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      channel!.sink.add(jsonEncode({'type': 'init', 'sessionId': sessionId}));

      channel!.stream.listen((message) async {
        final data = jsonDecode(message);

        switch (data['type']) {
          case 'init-ok':
            channel!.sink.add(jsonEncode({'type': 'client-connected'}));
            break;

          case 'ready':
            channel!.sink.add(jsonEncode({'type': 'list'}));
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('📭 No files available')),
              );
            }
            break;

          case 'file':
            await _downloadFile(data['name'], data['content']);
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
              controller?.resumeCamera();
            });
            break;
        }
      }, onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('WebSocket Error: $error')),
        );
      });
    } catch (e) {
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
        status = await Permission.storage.request();
      }

      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Storage permission denied')),
        );
        return;
      }

      final bytes = base64Decode(base64Content);
      Directory? dir = Directory('/storage/emulated/0/Download');
      if (!await dir.exists()) {
        dir = await getExternalStorageDirectory();
      }

      final file = File('${dir!.path}/$name');
      await file.writeAsBytes(bytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Downloaded: ${file.path}')),
      );
    } catch (e) {
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
    controller?.resumeCamera();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("👋 Logged out")),
    );
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
                spacing: 10,
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
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Orbitron',
                            ),
                          ),
                        ),
                        Expanded(
                          child: FileListView(
                            fileList: fileList,
                            onRequest: _requestFile,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: primaryColor.withOpacity(0.1),
                              border: Border.all(
                                  color: primaryColor.withOpacity(0.5)),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: _uploadFileToServer,
                              icon: Icon(
                                HugeIcons.strokeRoundedCloudUpload,
                                color: primaryColor,
                              ),
                              label: const Text(
                                "Upload File",
                                style: TextStyle(
                                  fontFamily: 'Orbitron',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                textStyle: const TextStyle(fontSize: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                      overlay: QrScannerOverlayShape(
                        borderColor: primaryColor,
                        borderRadius: 16,
                        borderLength: 40,
                        borderWidth: 10,
                        cutOutSize: 280,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class FileListView extends StatelessWidget {
  final List<String> fileList;
  final void Function(String) onRequest;

  const FileListView({
    super.key,
    required this.fileList,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF4E7CFF);

    if (fileList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              HugeIcons.strokeRoundedFolder01,
              size: 64,
              color: primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No files available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: primaryColor.withOpacity(0.5),
                fontFamily: 'Orbitron',
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      itemCount: fileList.length,
      itemBuilder: (context, index) {
        final file = fileList[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF262626),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: primaryColor.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                HugeIcons.strokeRoundedFile01,
                color: primaryColor,
              ),
            ),
            title: Text(
              file,
              style: const TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: 'Orbitron',
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                HugeIcons.strokeRoundedDownload01,
                color: primaryColor,
              ),
              onPressed: () => onRequest(file),
            ),
          ),
        );
      },
    );
  }
}
