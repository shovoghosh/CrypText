import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';

class RsaApp extends StatefulWidget {
  const RsaApp({super.key});

  @override
  State<RsaApp> createState() => _RsaAppState();
}

class _RsaAppState extends State<RsaApp> {
  final TextEditingController _textController = TextEditingController();

  String _encrypted = '';
  String _decrypted = '';

  int p = 61; // Initialize with a prime number
  int q = 53; // Initialize with a prime number
  late int n = p * q; // n = p * q
  late int phi = (p - 1) * (q - 1); // Phi(n)
  int e = 17; // Public key (part of)
  late int d = modInverse(e, phi); // Private key (part of)

  List<BigInt> _encryptedText = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("RSA Encryption/Decryption"),
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
            ElevatedButton(
              onPressed: _generateKeys,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                elevation: 1,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Generate New Keys',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            //1
            //plaintext

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _textController,
                onChanged: (value) => _encrypted = value,
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
                      child: SelectableText(
                          'Encrypted Message: ${_encryptedText.join(", ")}'),
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
                      child: SelectableText('Decrypted Message: $_decrypted'),
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

//main code ...
//

  void _generateKeys() {
    setState(() {
      p = generatePrimeNumber();
      q = generatePrimeNumber();
      n = p * q;
      phi = (p - 1) * (q - 1);
      e = findCoprime(phi);
      d = modInverse(e, phi);
    });
  }

  void _encrypt() {
    _encryptedText.clear();
    for (var char in _encrypted.runes) {
      final encrypted =
          BigInt.from(char).modPow(BigInt.from(e), BigInt.from(n));
      _encryptedText.add(encrypted);
    }
    setState(() {});
  }

  void _decrypt() {
    _decrypted = '';
    for (var encryptedChar in _encryptedText) {
      final decryptedChar =
          encryptedChar.modPow(BigInt.from(d), BigInt.from(n)).toInt();
      _decrypted += String.fromCharCode(decryptedChar);
    }
    setState(() {});
  }

  int generatePrimeNumber() {
    final random = Random();
    while (true) {
      int candidate = random.nextInt(100) +
          100; // Generate a prime in the range 100-200 for simplicity
      if (isPrime(candidate)) return candidate;
    }
  }

  bool isPrime(int num) {
    if (num <= 1) return false;
    for (int i = 2; i <= sqrt(num); i++) {
      if (num % i == 0) return false;
    }
    return true;
  }

  int modInverse(int a, int m) {
    int m0 = m, t, q;
    int x0 = 0, x1 = 1;
    if (m == 1) return 0;
    while (a > 1) {
      q = a ~/ m;
      t = m;
      m = a % m;
      a = t;
      t = x0;
      x0 = x1 - q * x0;
      x1 = t;
    }
    if (x1 < 0) x1 += m0;
    return x1;
  }

  int findCoprime(int phi) {
    for (int i = 2; i < phi; i++) {
      if (gcd(i, phi) == 1) return i;
    }
    return 17; // Fallback to a commonly used small prime if no other is found
  }

  int gcd(int a, int b) {
    if (b == 0) return a;
    return gcd(b, a % b);
  }
}
