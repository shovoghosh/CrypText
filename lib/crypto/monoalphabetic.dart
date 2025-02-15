import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class MonoalphabeticCipher extends StatefulWidget {
  const MonoalphabeticCipher({super.key});

  @override
  State<MonoalphabeticCipher> createState() => _MonoalphabeticCipherState();
}

class _MonoalphabeticCipherState extends State<MonoalphabeticCipher> {
  final _cipher = MonoalphabeticCipher1();
  final _controller = TextEditingController();

  String _decrypted = '';
  String _encrypted = '';
  int _key = 0;

  void _encrypt() {
    setState(() {
      _encrypted = _cipher.encrypt(_controller.text);
    });
  }

  void _decrypt() {
    setState(() {
      _decrypted = _cipher.decrypt(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Monoalphabetic Cipher"),
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
                controller: _controller,
                maxLines: 4,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: _controller.clear,
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
class MonoalphabeticCipher1 {
  static const String _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _cipherAlphabet =
      'QWERTYUIOPLKJHGFDSAZXCVBNM'; // Example substitution

  String encrypt(String input) {
    return _transform(input, true);
  }

  String decrypt(String input) {
    return _transform(input, false);
  }

  String _transform(String input, bool encrypt) {
    Map<String, String> map = {};
    if (encrypt) {
      for (int i = 0; i < _alphabet.length; i++) {
        map[_alphabet[i]] = _cipherAlphabet[i];
      }
    } else {
      for (int i = 0; i < _alphabet.length; i++) {
        map[_cipherAlphabet[i]] = _alphabet[i];
      }
    }

    return input.toUpperCase().split('').map((char) {
      if (map.containsKey(char)) {
        return map[char];
      }
      return char; // Non-alphabetic characters are not transformed
    }).join('');
  }
}
