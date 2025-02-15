import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

class Rc4App extends StatefulWidget {
  const Rc4App({super.key});

  @override
  State<Rc4App> createState() => _Rc4AppState();
}

class _Rc4AppState extends State<Rc4App> {
  final TextEditingController _textController = TextEditingController();

  final TextEditingController _keyController = TextEditingController();

  String _encrypted = '';
  String _decrypted = '';

  int _key = 0;

  void _encrypt() {
    String key = _keyController.text;
    String data = _textController.text;
    if (key.isNotEmpty && data.isNotEmpty) {
      RC4 rc4 = RC4(key);
      setState(() {
        _encrypted = rc4.encrypt(data);
      });
    }
  }

  void _decrypt() {
    String key = _keyController.text;
    String data = _textController.text;
    if (key.isNotEmpty && data.isNotEmpty) {
      RC4 rc4 = RC4(key);
      setState(() {
        _decrypted = rc4.decrypt(data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("RC4 Encryption/Decryption"),
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
                  hintText: "Enter The Text",
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
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  _key = int.tryParse(val) ?? 0;
                },
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
                  hintText: "Enter Key",
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
            //output 1
            Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(left: 25, right: 25, top: 25),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Text('Encrypted: $_encrypted'),
                    )
                  ],
                )),
            const SizedBox(
              height: 10,
            ),
            //copy button
            ElevatedButton(
              onPressed: () async {
                FlutterClipboard.copy(_encrypted).then(
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
            const SizedBox(
              height: 5,
            ),
            //output 2
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
                      child: Text('Decrypted: $_decrypted'),
                    )
                  ],
                )),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    FlutterClipboard.copy(_decrypted).then(
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
                      _encrypted = " ";
                      _decrypted = " ";
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
class RC4 {
  List<int> sBox = List<int>.filled(256, 0);

  RC4(String key) {
    List<int> keyBytes = key.codeUnits;
    int j = 0;

    // Initialize sBox
    for (int i = 0; i < 256; i++) {
      sBox[i] = i;
    }

    // Key-scheduling algorithm (KSA)
    for (int i = 0; i < 256; i++) {
      j = (j + sBox[i] + keyBytes[i % keyBytes.length]) % 256;
      int temp = sBox[i];
      sBox[i] = sBox[j];
      sBox[j] = temp;
    }
  }

  String encrypt(String plaintext) {
    return _process(plaintext);
  }

  String decrypt(String ciphertext) {
    return _process(ciphertext);
  }

  String _process(String data) {
    List<int> dataBytes = data.codeUnits;
    List<int> result = List<int>.filled(dataBytes.length, 0);
    int i = 0;
    int j = 0;

    // Pseudo-random generation algorithm (PRGA)
    for (int k = 0; k < dataBytes.length; k++) {
      i = (i + 1) % 256;
      j = (j + sBox[i]) % 256;
      int temp = sBox[i];
      sBox[i] = sBox[j];
      sBox[j] = temp;

      int t = (sBox[i] + sBox[j]) % 256;
      result[k] = dataBytes[k] ^ sBox[t];
    }

    return String.fromCharCodes(result);
  }
}
