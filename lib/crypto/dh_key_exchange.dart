import 'dart:math';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

//
class DHKeyExchangeApp extends StatefulWidget {
  const DHKeyExchangeApp({super.key});

  @override
  State<DHKeyExchangeApp> createState() => _DHKeyExchangeAppState();
}

class _DHKeyExchangeAppState extends State<DHKeyExchangeApp> {
//

  final int p = 7919; // A large prime number
  final int g = 10; // A base (primitive root modulo p)

  final TextEditingController _privateKeyAController = TextEditingController();
  final TextEditingController _privateKeyBController = TextEditingController();

  int? publicKeyA;
  int? publicKeyB;
  int? sharedSecretA;
  int? sharedSecretB;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Diffie-Hellman Key Exchange'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
//
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _privateKeyAController,
                maxLines: 4,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: _privateKeyAController.clear,
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
                  hintText: "Input Numbers..",
                  labelText: 'Enter Private Key for User A',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),

//

            SizedBox(height: 20),

            //
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _privateKeyBController,
                maxLines: 4,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: _privateKeyBController.clear,
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
                  hintText: "Input Numbers..",
                  labelText: 'Enter Private Key for User B',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            //

            //

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: generatePublicKeys,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    elevation: 1,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Generate Public Keys',
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
                    FlutterClipboard.copy(
                            'User A: Public Key = $publicKeyA \n User B: Public Key = $publicKeyB')
                        .then(
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

            SizedBox(height: 10),

            //
            if (publicKeyA != null) Text('User A: Public Key = $publicKeyA'),
            if (publicKeyB != null) Text('User B: Public Key = $publicKeyB'),
            //
            SizedBox(height: 10),
            //

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: computeSharedSecrets,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    elevation: 1,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Compute Secrets',
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
                      publicKeyA = null;
                      publicKeyB = null;
                      sharedSecretA = null;
                      sharedSecretB = null;
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

            SizedBox(height: 20),

            //

            if (sharedSecretA != null)
              Text('Shared Secret for A: $sharedSecretA'),
            if (sharedSecretB != null)
              Text('Shared Secret for B: $sharedSecretB'),
          ],
        ),
      ),
    );
  }

  void generatePublicKeys() {
    int privateKeyA = int.tryParse(_privateKeyAController.text) ?? 1;
    int privateKeyB = int.tryParse(_privateKeyBController.text) ?? 1;

    // Ensure private keys are within the valid range
    privateKeyA = privateKeyA % (p - 1);
    privateKeyB = privateKeyB % (p - 1);

    publicKeyA = powerMod(g, privateKeyA, p);
    publicKeyB = powerMod(g, privateKeyB, p);

    // Clear previous shared secrets
    sharedSecretA = null;
    sharedSecretB = null;

    setState(() {});
  }

  void computeSharedSecrets() {
    if (publicKeyA == null || publicKeyB == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please generate public keys first."),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    int privateKeyA = int.tryParse(_privateKeyAController.text) ?? 1;
    int privateKeyB = int.tryParse(_privateKeyBController.text) ?? 1;

    // Compute shared secrets
    sharedSecretA = powerMod(publicKeyB!, privateKeyA, p);
    sharedSecretB = powerMod(publicKeyA!, privateKeyB, p);

    setState(() {});
  }

  int powerMod(int base, int exp, int mod) {
    int result = 1;
    base = base % mod;
    while (exp > 0) {
      if (exp % 2 == 1) {
        result = (result * base) % mod;
      }
      exp = exp >> 1;
      base = (base * base) % mod;
    }
    return result;
  }
}
