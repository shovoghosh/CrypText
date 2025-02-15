import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class RailFenceCipherApp extends StatefulWidget {
  const RailFenceCipherApp({super.key});

  @override
  State<RailFenceCipherApp> createState() => _RailFenceCipherAppState();
}

class _RailFenceCipherAppState extends State<RailFenceCipherApp> {
  final TextEditingController _textController = TextEditingController();

  final _railsController = TextEditingController();
  String _encrypted = '';
  String _decrypted = '';
  RailFenceCipher? _cipher;

  int _key = 0;

  void _encrypt() {
    if (_updateCiphere()) {
      setState(() {
        _encrypted = _cipher!.encrypt(_textController.text);
      });
    }
  }

  void _decrypt() {
    if (_updateCipherd()) {
      setState(() {
        _decrypted = _cipher!.decrypt(_textController.text);
      });
    }
  }

  bool _updateCiphere() {
    try {
      int rails = int.parse(_railsController.text);
      _cipher = RailFenceCipher(rails);
      return true;
    } catch (e) {
      setState(() {
        _encrypted = 'Error: Invalid number of rails';
      });
      return false;
    }
  }

  bool _updateCipherd() {
    try {
      int rails = int.parse(_railsController.text);
      _cipher = RailFenceCipher(rails);
      return true;
    } catch (e) {
      setState(() {
        _decrypted = 'Error: Invalid number of rails';
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Rail Fence Cipher"),
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
                controller: _railsController,
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  _key = int.tryParse(val) ?? 0;
                },
                maxLines: 2,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: _railsController.clear,
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
                  hintText: "Enter The Number of rails",
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
class RailFenceCipher {
  int key; // Number of rails

  RailFenceCipher(this.key);

  String encrypt(String text) {
    List<List<String?>> rails = List.generate(
        key, (_) => List.filled(text.length, null, growable: false));
    bool down = false;
    int row = 0;

    for (int i = 0; i < text.length; i++) {
      rails[row]![i] = text[i];
      if (row == 0 || row == key - 1) down = !down;
      row += down ? 1 : -1;
    }

    return rails.expand((rail) => rail).where((char) => char != null).join();
  }

  String decrypt(String cipherText) {
    List<List<int>> rails = List.generate(key, (_) => <int>[]);
    bool down = false;
    int row = 0;

    for (int i = 0; i < cipherText.length; i++) {
      rails[row].add(i);
      if (row == 0 || row == key - 1) down = !down;
      row += down ? 1 : -1;
    }

    int idx = 0;
    List<String?> result = List.filled(cipherText.length, null);
    for (int i = 0; i < key; i++) {
      for (var pos in rails[i]) {
        result[pos] = cipherText[idx++];
      }
    }

    return result.join();
  }
}
