import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class HillCipher extends StatefulWidget {
  const HillCipher({super.key});

  @override
  State<HillCipher> createState() => _HillCipherState();
}

class _HillCipherState extends State<HillCipher> {
  final _cipher = HillCipher1();
  final _inputController = TextEditingController();
  final _keyController = TextEditingController();
  String _result = '';

  void _encrypt() {
    setState(() {
      _result = _cipher.encrypt(_inputController.text, _keyController.text);
    });
  }

  void _decrypt() {
    setState(() {
      _result = _cipher.decrypt(_inputController.text, _keyController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Hill Cipher"),
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
                  hintText: "Enter The Key (4 characters)",
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
                      child: Text('Output: $_result'),
                    )
                  ],
                )),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    FlutterClipboard.copy(_result).then(
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
                      _result = " ";
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
class HillCipher1 {
  static const _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const _modulus = 26;

  HillCipher1();

  String encrypt(String plaintext, String key) {
    var keyMatrix = _createKeyMatrix(key);
    return _transform(plaintext, keyMatrix);
  }

  String decrypt(String ciphertext, String key) {
    var keyMatrix = _createKeyMatrix(key);
    var inverseKeyMatrix = _calculateInverseMatrix(keyMatrix);
    return _transform(ciphertext, inverseKeyMatrix);
  }

  List<List<int>> _createKeyMatrix(String key) {
    // Assuming the key length is 4 for a 2x2 matrix.
    key = key.padRight(4, key).toUpperCase().substring(0, 4);
    List<int> values =
        key.split('').map((char) => _alphabet.indexOf(char)).toList();
    return [
      [values[0], values[1]],
      [values[2], values[3]],
    ];
  }

  List<List<int>> _calculateInverseMatrix(List<List<int>> matrix) {
    int a = matrix[0][0];
    int b = matrix[0][1];
    int c = matrix[1][0];
    int d = matrix[1][1];
    int det = a * d - b * c;
    int invDet = _modularMultiplicativeInverse(det, _modulus);

    // Modular inverse of matrix
    List<List<int>> invMatrix = [
      [d * invDet % _modulus, -b * invDet % _modulus],
      [-c * invDet % _modulus, a * invDet % _modulus],
    ];

    // Adjust negatives
    return invMatrix
        .map((row) => row.map((val) => (val + _modulus) % _modulus).toList())
        .toList();
  }

  int _modularMultiplicativeInverse(int a, int m) {
    a = a % m;
    for (int x = 1; x < m; x++) {
      if ((a * x) % m == 1) {
        return x;
      }
    }
    throw Exception('No modular inverse found');
  }

  String _transform(String input, List<List<int>> keyMatrix) {
    input = input.toUpperCase().replaceAll(RegExp('[^A-Z]'), '');
    StringBuffer result = StringBuffer();

    for (int i = 0; i < input.length; i += 2) {
      List<int> chunk = [0, 0];
      for (int j = 0; j < 2; j++) {
        if (i + j < input.length) {
          chunk[j] = _alphabet.indexOf(input[i + j]);
        }
      }

      List<int> transformedChunk = _multiplyMatrixAndVector(keyMatrix, chunk);

      for (int value in transformedChunk) {
        result.write(_alphabet[value % _alphabet.length]);
      }
    }

    return result.toString();
  }

  List<int> _multiplyMatrixAndVector(List<List<int>> matrix, List<int> vector) {
    List<int> result = [0, 0];
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        result[i] += matrix[i][j] * vector[j];
      }
      result[i] = result[i] % _modulus;
    }
    return result;
  }
}
