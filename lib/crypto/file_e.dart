import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

//

class FileEncryptDecrypt extends StatefulWidget {
  const FileEncryptDecrypt({super.key});

  @override
  State<FileEncryptDecrypt> createState() => _FileEncryptDecryptState();
}

class _FileEncryptDecryptState extends State<FileEncryptDecrypt> {
  File? _file;
  final _keyController = TextEditingController();
  final _storage = FlutterSecureStorage();
  bool _isEncrypted = false;
  String? _operationStatus;

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
        _isEncrypted = false;
        _operationStatus = null;
      });
    }
  }

  void _encryptFile() async {
    if (_file == null || _keyController.text.isEmpty) {
      _showDialog('File or key cannot be empty.');
      return;
    }
    // Ensuring the key is correctly sized for AES
    final key =
        encrypt.Key.fromUtf8(_keyController.text.padRight(32).substring(0, 32));
    // Using a fixed IV for demonstration purposes
    final iv = encrypt.IV.fromLength(16);

    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    final fileBytes = await _file!.readAsBytes();
    final encrypted = encrypter.encryptBytes(fileBytes, iv: iv);

    final directory = await getApplicationDocumentsDirectory();

    // Extract original file extension
    final originalExtension = _file!.path.split('.').last;

    final encryptedFilePath =
        '${directory.path}/encrypted_file.$originalExtension';
    final encryptedFile = File(encryptedFilePath);

    await encryptedFile.writeAsBytes(encrypted.bytes);

    setState(() {
      _file = encryptedFile;
      _isEncrypted = true;
      _operationStatus = 'File encrypted successfully!';
    });
  }

  void _decryptFile() async {
    if (_file == null || _keyController.text.isEmpty) {
      _showDialog('File or key cannot be empty.');
      return;
    }
    final key =
        encrypt.Key.fromUtf8(_keyController.text.padRight(32).substring(0, 32));
    final iv = encrypt.IV.fromLength(16); // Same IV must be used for decryption

    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    try {
      final fileBytes = await _file!.readAsBytes();
      final decrypted =
          encrypter.decryptBytes(encrypt.Encrypted(fileBytes), iv: iv);

      final directory = await getApplicationDocumentsDirectory();
      // Extract original file extension
      final originalExtension = _file!.path.split('.').last;
      final decryptedFilePath =
          '${directory.path}/decrypted_file.$originalExtension';

      final decryptedFile = File(decryptedFilePath);
      await decryptedFile.writeAsBytes(decrypted);

      setState(() {
        _file = decryptedFile;
        _isEncrypted = false;
        _operationStatus = 'File decrypted successfully!';
      });
    } catch (e) {
      _showDialog('Decryption failed: ${e.toString()}');
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Alert'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('File Encrypt/Decrypt')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Browse File'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _keyController,
                decoration: InputDecoration(hintText: 'Enter Secret Key'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _encryptFile,
                  child: Text('Encrypt File'),
                ),
                ElevatedButton(
                  onPressed: _decryptFile,
                  child: Text('Decrypt File'),
                ),
              ],
            ),
            if (_operationStatus != null) Text(_operationStatus!),
            if (_isEncrypted ||
                _operationStatus == 'File decrypted successfully!')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => _saveFile(context),
                  child: Text('Save File'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _saveFile(BuildContext context) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final directory = await getExternalStorageDirectory();
      final path =
          directory?.path ?? (await getApplicationDocumentsDirectory()).path;
      final savePath = await FilePicker.platform.getDirectoryPath();
      if (savePath != null) {
        final fileName = _file!.path.split('/').last;
        final newFile = await _file!.copy('$savePath/$fileName');
        _showDialog('File saved at $savePath/$fileName');
      } else {
        _showDialog('No directory selected');
      }
    } else {
      _showDialog('Storage permission not granted');
    }
  }
}
