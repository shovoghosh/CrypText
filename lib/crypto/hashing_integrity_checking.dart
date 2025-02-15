import 'dart:typed_data';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class HashingApp extends StatefulWidget {
  const HashingApp({super.key});

  @override
  State<HashingApp> createState() => _HashingAppState();
}

class _HashingAppState extends State<HashingApp> {
  final TextEditingController _inputController = TextEditingController();
  String _hashResult = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('SHA-1 Hashing App'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
//
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _inputController,
                maxLines: 4,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: _inputController.clear,
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
                  hintText: "Text/Number Input..",
                  labelText: 'Enter text to hash',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            //

            SizedBox(height: 20),

//
            ElevatedButton(
              onPressed: () => _hashText(_inputController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                elevation: 1,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Compute Hash',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),

            //
            SizedBox(height: 20),
            //

            SelectableText(
              'Hash: $_hashResult',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            //

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //

//copy button
                ElevatedButton(
                  onPressed: () async {
                    FlutterClipboard.copy(_hashResult).then(
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

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _hashResult = " ";
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

  void _hashText(String input) {
    setState(() {
      _hashResult = sha1Hash(input);
    });
  }

  String sha1Hash(String input) {
    // Constants for the SHA-1 algorithm
    int h0 = 0x67452301;
    int h1 = 0xEFCDAB89;
    int h2 = 0x98BADCFE;
    int h3 = 0x10325476;
    int h4 = 0xC3D2E1F0;

    List<int> bytes = input.codeUnits.toList();
    int originalLength = bytes.length;
    bytes.add(0x80);
    while (bytes.length % 64 != 56) {
      bytes.add(0);
    }

    int bitLength = originalLength * 8;
    bytes.addAll([
      0, 0, 0, 0, // High word
      (bitLength >> 24) & 0xFF,
      (bitLength >> 16) & 0xFF,
      (bitLength >> 8) & 0xFF,
      bitLength & 0xFF
    ]);

    Uint8List message = Uint8List.fromList(bytes);

    for (int i = 0; i < message.length; i += 64) {
      Uint32List w = Uint32List(80);
      for (int j = 0; j < 16; j++) {
        int index = i + j * 4;
        w[j] = (message[index] << 24) |
            (message[index + 1] << 16) |
            (message[index + 2] << 8) |
            message[index + 3];
      }

      for (int j = 16; j < 80; j++) {
        w[j] = leftRotate(w[j - 3] ^ w[j - 8] ^ w[j - 14] ^ w[j - 16], 1);
      }

      int a = h0, b = h1, c = h2, d = h3, e = h4;

      for (int j = 0; j < 80; j++) {
        int f, k;
        if (j < 20) {
          f = (b & c) | (~b & d);
          k = 0x5A827999;
        } else if (j < 40) {
          f = b ^ c ^ d;
          k = 0x6ED9EBA1;
        } else if (j < 60) {
          f = (b & c) | (b & d) | (c & d);
          k = 0x8F1BBCDC;
        } else {
          f = b ^ c ^ d;
          k = 0xCA62C1D6;
        }

        int temp = leftRotate(a, 5) + f + e + k + w[j];
        e = d;
        d = c;
        c = leftRotate(b, 30);
        b = a;
        a = temp;
      }

      h0 = (h0 + a) & 0xFFFFFFFF;
      h1 = (h1 + b) & 0xFFFFFFFF;
      h2 = (h2 + c) & 0xFFFFFFFF;
      h3 = (h3 + d) & 0xFFFFFFFF;
      h4 = (h4 + e) & 0xFFFFFFFF;
    }

    return [h0, h1, h2, h3, h4]
        .map((v) => v.toRadixString(16).padLeft(8, '0'))
        .join();
  }

  int leftRotate(int n, int bits) {
    return ((n << bits) | (n >> (32 - bits))) & 0xFFFFFFFF;
  }
}
