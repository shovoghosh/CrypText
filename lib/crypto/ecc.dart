import 'dart:math';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class ECCApp extends StatefulWidget {
  const ECCApp({super.key});

  @override
  State<ECCApp> createState() => _ECCAppState();
}

class _ECCAppState extends State<ECCApp> {
  final ECCurve curve =
      ECCurve(1, 6, 11, ECCPoint(2, 4)); // Example curve parameters
  Random random = Random();
  int privateKey = 0;
  ECCPoint? publicKey;

  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _encryptedController = TextEditingController();

  String encryptedMessage = "";
  String decryptedMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Elliptic Curve Cryptography (ECC)'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Private Key: $privateKey'),
            SizedBox(height: 10),
            Text('Public Key: $publicKey'),
            SizedBox(height: 15),

            //

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: generateKeys,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    elevation: 1,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Generate Keys',
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
                      encryptedMessage = " ";
                      decryptedMessage = " ";
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

            //

            SizedBox(height: 10),
            //

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _messageController,
                maxLines: 4,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: _messageController.clear,
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
                  hintText: "Message",
                  labelText: 'Enter message to encrypt',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),
            //
            SelectableText('Encrypted Message: $encryptedMessage'),
            SizedBox(height: 10),
            //

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => encryptMessage(_messageController.text),
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

                //

//copy button
                ElevatedButton(
                  onPressed: () async {
                    FlutterClipboard.copy(encryptedMessage).then(
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
              ],
            ),
            //
            //

            //

            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _encryptedController,
                maxLines: 4,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: _encryptedController.clear,
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
                  hintText: "Encrypted Message",
                  labelText: 'Enter message to decrypt',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            SelectableText('Decrypted Message: $decryptedMessage'),
            SizedBox(height: 10),
//

            //

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => decryptMessage(_encryptedController.text),
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

//copy button
                ElevatedButton(
                  onPressed: () async {
                    FlutterClipboard.copy(decryptedMessage).then(
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
              ],
            ),

            //
          ],
        ),
      ),
    );
  }

  void generateKeys() {
    setState(() {
      privateKey =
          random.nextInt(curve.p); // Simple random private key generation
      publicKey = curve.scalarMultiplication(privateKey, curve.g);
    });
  }

  void encryptMessage(String message) {
    final bytes = message.codeUnits;
    final encryptedBytes = bytes
        .map((b) => (b + 2) % 256)
        .toList(); // Simple encryption: shift ASCII values
    setState(() {
      encryptedMessage = encryptedBytes.join(",");
    });
  }

  void decryptMessage(String encrypted) {
    final encryptedBytes = encrypted.split(",").map(int.parse).toList();
    final decryptedBytes = encryptedBytes
        .map((b) => (b - 2) % 256)
        .toList(); // Simple decryption: reverse shift
    setState(() {
      decryptedMessage = String.fromCharCodes(decryptedBytes);
    });
  }
}

class ECCPoint {
  final int x, y;
  ECCPoint(this.x, this.y);

  @override
  String toString() => '($x, $y)';
}

class ECCurve {
  final int a, b, p; // Curve coefficients and the prime modulus
  final ECCPoint g; // Base point
  ECCurve(this.a, this.b, this.p, this.g);

  ECCPoint scalarMultiplication(int scalar, ECCPoint point) {
    ECCPoint result =
        ECCPoint(0, 0); // Identity element of addition on the curve
    ECCPoint addend = point;
    while (scalar > 0) {
      if (scalar % 2 == 1) {
        result = add(result, addend);
      }
      addend = doublePoint(addend);
      scalar = scalar >> 1;
    }
    return result;
  }

  ECCPoint add(ECCPoint p1, ECCPoint p2) {
    if (p1.x == p2.x && p1.y == p2.y) {
      return doublePoint(p1);
    } else {
      int m = ((p2.y - p1.y) * modInverse(p2.x - p1.x, p)) % p;
      int x3 = (m * m - p1.x - p2.x) % p;
      int y3 = (m * (p1.x - x3) - p1.y) % p;
      return ECCPoint(x3, y3);
    }
  }

  ECCPoint doublePoint(ECCPoint p) {
    int m = ((3 * p.x * p.x + this.a) * modInverse(2 * p.y, this.p)) % this.p;
    int x3 = (m * m - 2 * p.x) % this.p;
    int y3 = (m * (p.x - x3) - p.y) % this.p;
    return ECCPoint(x3, y3);
  }

  int modInverse(int a, int m) {
    a = a % m;
    for (int x = 1; x < m; x++) {
      if ((a * x) % m == 1) return x;
    }
    throw Exception('No modular inverse');
  }
}
