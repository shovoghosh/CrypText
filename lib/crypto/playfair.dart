import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class PlayfairApp extends StatefulWidget {
  const PlayfairApp({super.key});

  @override
  State<PlayfairApp> createState() => _PlayfairAppState();
}

class _PlayfairAppState extends State<PlayfairApp> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  String _output = '';

  void _encrypt() {
    final cipher = PlayfairCipher(_keyController.text);
    setState(() {
      _output = cipher.encrypt(_textController.text);
    });
  }

  void _decrypt() {
    final cipher = PlayfairCipher(_keyController.text);
    setState(() {
      _output = cipher.decrypt(_textController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Playfair Cipher"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //1
            //plaintext

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _textController,
                maxLines: 4,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: _textController.clear,
                    icon: const Icon(Icons.clear),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  fillColor: Theme.of(context).colorScheme.secondary,
                  hintStyle:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                  hintText: "Enter The PlainText",
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            //2
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _keyController,
                maxLines: 2,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: _keyController.clear,
                    icon: const Icon(Icons.clear),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  fillColor: Theme.of(context).colorScheme.secondary,
                  hintStyle:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                  hintText: "Enter The Key",
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            // two buttons

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _encrypt,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    elevation: 1,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Encrypt',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),

                //second button
                ElevatedButton(
                  onPressed: _decrypt,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    elevation: 1,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Decrypt',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            //output
            Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(
                    left: 25, right: 25, top: 5, bottom: 25),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Text('Output: $_output'),
                    )
                  ],
                )),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    FlutterClipboard.copy(_output).then(
                      (value) {
                        return ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Text Copied'),
                          ),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    elevation: 1,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Copy',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),

                //second button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _output = " ";
                    });
                    // Perform an action when the button is pressed
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    elevation: 1,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//main code ...
//
class PlayfairCipher {
  String key;
  List<List<String>> matrix = [];

  PlayfairCipher(this.key) {
    generateMatrix();
  }

  void generateMatrix() {
    var alphabet = 'ABCDEFGHIKLMNOPQRSTUVWXYZ';
    var keyForMatrix = key
        .toUpperCase()
        .replaceAll('J', 'I')
        .replaceAll(RegExp(r'[^A-Z]'), '');
    // Remove duplicates from the key
    keyForMatrix = String.fromCharCodes(keyForMatrix.runes.toSet());
    // Create a unique string by combining the modified key with the alphabet and then removing duplicates
    keyForMatrix += alphabet;
    keyForMatrix = String.fromCharCodes(keyForMatrix.runes.toSet());
    // Remove characters to fit exactly into a 5x5 matrix
    keyForMatrix = keyForMatrix.substring(0, 25);

    // Fill the matrix
    for (int i = 0; i < 5; i++) {
      var row = List<String>.filled(5, '', growable: false);
      for (int j = 0; j < 5; j++) {
        row[j] = keyForMatrix[i * 5 + j];
      }
      matrix.add(row);
    }
  }

  String _pairUp(String text) {
    text = text
        .toUpperCase()
        .replaceAll('J', 'I')
        .replaceAll(RegExp(r'[^A-Z]'), '');
    List<String> pairs = [];
    for (int i = 0; i < text.length; i++) {
      if (i + 1 < text.length && text[i] == text[i + 1]) {
        pairs.add(text[i] + 'X');
      } else {
        if (i + 1 < text.length) {
          pairs.add(text[i] + text[i + 1]);
        } else {
          pairs.add(text[i] + 'X');
        }
        i++;
      }
    }
    return pairs.join(' ');
  }

  String _findPosition(String c, bool row) {
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        if (matrix[i][j] == c) {
          return row ? i.toString() : j.toString();
        }
      }
    }
    return '';
  }

  String encrypt(String text) {
    String pairedText = _pairUp(text);
    String encryptedText = '';
    List<String> pairs = pairedText.split(' ');
    for (String pair in pairs) {
      int row1 = int.parse(_findPosition(pair[0], true));
      int col1 = int.parse(_findPosition(pair[0], false));
      int row2 = int.parse(_findPosition(pair[1], true));
      int col2 = int.parse(_findPosition(pair[1], false));

      if (row1 == row2) {
        // Same row
        col1 = (col1 + 1) % 5;
        col2 = (col2 + 1) % 5;
      } else if (col1 == col2) {
        // Same column
        row1 = (row1 + 1) % 5;
        row2 = (row2 + 1) % 5;
      } else {
        // Rectangle swap
        int temp = col1;
        col1 = col2;
        col2 = temp;
      }

      encryptedText += matrix[row1][col1] + matrix[row2][col2];
    }
    return encryptedText;
  }

  String decrypt(String text) {
    // Implement the decryption method similarly
    return text;
  }
}
