import 'dart:math';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class DSASignatureApp extends StatefulWidget {
  const DSASignatureApp({super.key});

  @override
  State<DSASignatureApp> createState() => _DSASignatureAppState();
}

class _DSASignatureAppState extends State<DSASignatureApp> {
  final TextEditingController _messageController = TextEditingController();
  String _signature = "";
  String _verificationResult = "";
  String _hashResult = ""; // To store and display the hash of the input text

  // Simulated DSA parameters (not secure, just for demonstration)
  final int p = 383; // A large prime number (still small for example purposes)
  final int q = 191; // A divisor of p-1
  final int g = 2; // A number less than p and a primitive root modulo p
  int? privateKey;
  int? publicKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('DSA For Signature'),
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                        hintText: "Type your message..",
                        labelText: 'Enter message to sign',
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
                  SizedBox(height: 10),

                  //
                  if (_hashResult.isNotEmpty)
                    Text(
                        'Message Hash: $_hashResult'), // Display the hash after keys are generated
                  Text('Public key: $publicKey'),
                  Text('Private key: $privateKey'),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: signMessage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          elevation: 1,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Sign Message',
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
                          FlutterClipboard.copy('Signature = $_signature').then(
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
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
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

                  SizedBox(height: 10),

                  Text('Signature: $_signature'),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: verifySignature,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          elevation: 1,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Verify Signature',
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
                            _verificationResult = "";
                            _signature = "";
                            publicKey = null;
                            privateKey = null;
                          });
                          // Perform an action when the button is pressed
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
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
                  SizedBox(height: 10),
                  Text('Verification Result: $_verificationResult'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void generateKeys() {
    Random rand = Random();
    privateKey = rand.nextInt(q - 1) + 1; // privateKey in the range [1, q-1]
    publicKey = powerMod(g, privateKey!, p); // publicKey = g^privateKey mod p
    setState(() {});

    _hashResult = hash(_messageController.text)
        .toString(); // Compute and display the hash of the message
  }

  void signMessage() {
    if (privateKey == null) {
      _signature = "No keys generated.";
      return;
    }
    int k = Random().nextInt(q - 1) + 1; // Random k for each signature
    int r = powerMod(g, k, p) % q; // r = (g^k mod p) mod q
    int kInv = modInverse(k, q); // k^-1 mod q
    int s = (kInv * (hash(_messageController.text) + privateKey! * r)) %
        q; // s = k^-1(hash + privateKey * r) mod q
    _signature = "r: $r, s: $s";
    setState(() {});
  }

  void verifySignature() {
    if (publicKey == null || _signature.isEmpty || !_signature.contains(',')) {
      _verificationResult = "Invalid data.";
      return;
    }
    List<String> parts = _signature.split(', ');
    int r = int.parse(parts[0].split(': ')[1]);
    int s = int.parse(parts[1].split(': ')[1]);

    int w = modInverse(s, q); // w = s^-1 mod q
    int u1 = (hash(_messageController.text) * w) % q; // u1 = hash * w mod q
    int u2 = (r * w) % q; // u2 = r * w mod q
    int v = ((powerMod(g, u1, p) * powerMod(publicKey!, u2, p)) % p) %
        q; // v = ((g^u1 * publicKey^u2) mod p) mod q

    if (v == r) {
      _verificationResult = "Signature valid.";
    } else {
      _verificationResult = "Signature invalid.";
    }
    setState(() {});
  }

  int powerMod(int base, int exp, int mod) {
    int result = 1;
    while (exp > 0) {
      if (exp % 2 == 1) result = (result * base) % mod;
      base = (base * base) % mod;
      exp >>= 1;
    }
    return result;
  }

  int modInverse(int a, int m) {
    for (int x = 1; x < m; x++) {
      if ((a * x) % m == 1) return x;
    }
    return 1; // Should throw an exception in real applications if inverse does not exist
  }

  int hash(String message) {
    int h = 0x9E3779B9; // Using a 32-bit number instead
    for (int i = 0; i < message.length; i++) {
      h ^= message.codeUnitAt(i);
      h = (h * 0x01000193) % 0xFFFFFFFF;
      h = ((h << 5) | (h >> 27)); // Perform a rotate left operation
    }
    return h % q;
  }
}
