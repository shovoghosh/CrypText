import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class DESApp extends StatefulWidget {
  const DESApp({super.key});

  @override
  State<DESApp> createState() => _DESFormState();
}

class _DESFormState extends State<DESApp> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _textController = TextEditingController();

  final TextEditingController _keyController = TextEditingController();

  String _encryptedText = '';

  String _decryptedText = '';

  int _key = 0;

  void _encrypt() {
    setState(() {
      _encryptedText = desEncrypt(_textController.text, _keyController.text);
      _decryptedText = '';
    });
  }

  void _decrypt() {
    setState(() {
      _decryptedText = desDecrypt(_textController.text, _keyController.text);
      _encryptedText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("DES Encryption & Decryption"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        key: _formKey,
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
                  hintText: "Enter Text - 16 Hexadecimal Characters",
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
                  hintText: "Enter The Key - 16 Hexadecimal Characters",
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
                      child: Text('Encrypted: $_encryptedText'.toUpperCase()),
                    )
                  ],
                )),
            const SizedBox(
              height: 10,
            ),
            //copy button
            ElevatedButton(
              onPressed: () async {
                FlutterClipboard.copy(_encryptedText).then(
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
                      child: Text('Decrypted: $_decryptedText'.toUpperCase()),
                    )
                  ],
                )),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    FlutterClipboard.copy(_decryptedText).then(
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
                      _encryptedText = " ";
                      _decryptedText = " ";
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
////
// DES Permutation tables, S-box tables, and other constants

// Initial permutation table
final List<int> initialPermutation = [
  58,
  50,
  42,
  34,
  26,
  18,
  10,
  2,
  60,
  52,
  44,
  36,
  28,
  20,
  12,
  4,
  62,
  54,
  46,
  38,
  30,
  22,
  14,
  6,
  64,
  56,
  48,
  40,
  32,
  24,
  16,
  8,
  57,
  49,
  41,
  33,
  25,
  17,
  9,
  1,
  59,
  51,
  43,
  35,
  27,
  19,
  11,
  3,
  61,
  53,
  45,
  37,
  29,
  21,
  13,
  5,
  63,
  55,
  47,
  39,
  31,
  23,
  15,
  7
];

// Final permutation table (inverse of initial permutation)
final List<int> finalPermutation = [
  40,
  8,
  48,
  16,
  56,
  24,
  64,
  32,
  39,
  7,
  47,
  15,
  55,
  23,
  63,
  31,
  38,
  6,
  46,
  14,
  54,
  22,
  62,
  30,
  37,
  5,
  45,
  13,
  53,
  21,
  61,
  29,
  36,
  4,
  44,
  12,
  52,
  20,
  60,
  28,
  35,
  3,
  43,
  11,
  51,
  19,
  59,
  27,
  34,
  2,
  42,
  10,
  50,
  18,
  58,
  26,
  33,
  1,
  41,
  9,
  49,
  17,
  57,
  25
];

// Expansion table (E-box)
final List<int> expansionTable = [
  32,
  1,
  2,
  3,
  4,
  5,
  4,
  5,
  6,
  7,
  8,
  9,
  8,
  9,
  10,
  11,
  12,
  13,
  12,
  13,
  14,
  15,
  16,
  17,
  16,
  17,
  18,
  19,
  20,
  21,
  20,
  21,
  22,
  23,
  24,
  25,
  24,
  25,
  26,
  27,
  28,
  29,
  28,
  29,
  30,
  31,
  32,
  1
];

// S-boxes
final List<List<List<int>>> sBoxes = [
  [
    [14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7],
    [0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8],
    [4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0],
    [15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13]
  ],
  // Add additional S-boxes here
  [
    [15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10],
    [3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5],
    [0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15],
    [13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9]
  ],

  [
    [10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8],
    [13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1],
    [13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7],
    [1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12]
  ],

  [
    [7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15],
    [13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9],
    [10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4],
    [3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14]
  ],

  [
    [2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9],
    [14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6],
    [4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14],
    [11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3]
  ],

  [
    [12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11],
    [10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8],
    [9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6],
    [4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13]
  ],

  [
    [4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1],
    [13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6],
    [1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2],
    [6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12]
  ],

  [
    [13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7],
    [1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2],
    [7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8],
    [2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11]
  ],
];

// Straight permutation table (P-box)
final List<int> straightPermutationTable = [
  16,
  7,
  20,
  21,
  29,
  12,
  28,
  17,
  1,
  15,
  23,
  26,
  5,
  18,
  31,
  10,
  2,
  8,
  24,
  14,
  32,
  27,
  3,
  9,
  19,
  13,
  30,
  6,
  22,
  11,
  4,
  25,
];

// Key schedule (PC1, PC2, and shifts)
final List<int> pc1 = [
  57,
  49,
  41,
  33,
  25,
  17,
  9,
  1,
  58,
  50,
  42,
  34,
  26,
  18,
  10,
  2,
  59,
  51,
  43,
  35,
  27,
  19,
  11,
  3,
  60,
  52,
  44,
  36,
  63,
  55,
  47,
  39,
  31,
  23,
  15,
  7,
  62,
  54,
  46,
  38,
  30,
  22,
  14,
  6,
  61,
  53,
  45,
  37,
  29,
  21,
  13,
  5,
  28,
  20,
  12,
  4
];
final List<int> pc2 = [
  14,
  17,
  11,
  24,
  1,
  5,
  3,
  28,
  15,
  6,
  21,
  10,
  23,
  19,
  12,
  4,
  26,
  8,
  16,
  7,
  27,
  20,
  13,
  2,
  41,
  52,
  31,
  37,
  47,
  55,
  30,
  40,
  51,
  45,
  33,
  48,
  44,
  49,
  39,
  56,
  34,
  53,
  46,
  42,
  50,
  36,
  29,
  32
];
final List<int> shifts = [1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1];

//
// Convert a hex string to a binary string
String hexToBinary(String hex) {
  return BigInt.parse(hex, radix: 16)
      .toRadixString(2)
      .padLeft(hex.length * 4, '0');
}

// Convert a binary string to a hex string
String binaryToHex(String binary) {
  return BigInt.parse(binary, radix: 2)
      .toRadixString(16)
      .padLeft((binary.length / 4).ceil(), '0');
}

//add1

int bin2dec(String binary) {
  return int.parse(binary, radix: 2);
}

String dec2bin(int num) {
  return num.toRadixString(2).padLeft(4, '0');
}
//add1

// Apply a permutation table to the input data
String permute(String input, List<int> table) {
  return String.fromCharCodes(
      table.map((index) => input.codeUnitAt(index - 1)));
}

// Split the binary data into blocks and perform substitution using the S-boxes
String substitute(String expandedHalf) {
  StringBuffer output = StringBuffer();
  for (int i = 0; i < 8; i++) {
    String sixBitBlock = expandedHalf.substring(i * 6, (i + 1) * 6);
    int row = int.parse('${sixBitBlock[0]}${sixBitBlock[5]}', radix: 2);
    int col = int.parse(sixBitBlock.substring(1, 5), radix: 2);
    int val = sBoxes[i][row][col];
    output.write(val.toRadixString(2).padLeft(4, '0'));
  }
  return output.toString();
}

// XOR two binary strings
String xor(String a, String b) {
  StringBuffer result = StringBuffer();
  for (int i = 0; i < a.length; i++) {
    result.write((int.parse(a[i]) ^ int.parse(b[i])).toString());
  }
  return result.toString();
}

//
// DES round function
String desRound(String input, String key) {
  String left = input.substring(0, input.length ~/ 2);
  String right = input.substring(input.length ~/ 2);
  String expandedRight = permute(right, expansionTable);
  String xored = xor(expandedRight, key);
  String substituted = substitute(xored);
  String permuted = permute(substituted, straightPermutationTable);
  return xor(left, permuted) + right; // Swap happened in next round
}

// Generate 16 48-bit keys from the 64-bit main key
List<String> generateKeys(String mainKey) {
  String permutedKey = permute(mainKey, pc1);
  List<String> roundKeys = [];
  String leftKey = permutedKey.substring(0, permutedKey.length ~/ 2);
  String rightKey = permutedKey.substring(permutedKey.length ~/ 2);
  for (int i = 0; i < 16; i++) {
    leftKey = leftKey.substring(shifts[i]) + leftKey.substring(0, shifts[i]);
    rightKey = rightKey.substring(shifts[i]) + rightKey.substring(0, shifts[i]);
    String combinedKey = leftKey + rightKey;
    roundKeys.add(permute(combinedKey, pc2));
  }
  return roundKeys;
}

// Full DES encryption
String desEncrypt(String plaintext, String key) {
  String binaryPlaintext = hexToBinary(plaintext);
  String binaryKey = hexToBinary(key);
  List<String> keys = generateKeys(binaryKey);
  String permutedInput = permute(binaryPlaintext, initialPermutation);
  for (int i = 0; i < 16; i++) {
    permutedInput = desRound(permutedInput, keys[i]);
  }
  // Swap final round
  String swapped = permutedInput.substring(permutedInput.length ~/ 2) +
      permutedInput.substring(0, permutedInput.length ~/ 2);
  return binaryToHex(permute(swapped, finalPermutation));
}

//
// DES decryption function
String desDecrypt(String ciphertext, String key) {
  String binaryCiphertext = hexToBinary(ciphertext);
  String binaryKey = hexToBinary(key);
  List<String> keys = generateKeys(binaryKey);

  // Initial Permutation
  String permutedInput = permute(binaryCiphertext, initialPermutation);

  // Apply the keys in reverse order for decryption
  for (int i = 15; i >= 0; i--) {
    print("Key: $key, Round: $i, Data: $permutedInput");
    permutedInput = desRound(permutedInput, keys[i]);
  }

  // Swap final round (this step is crucial and must be done correctly)
  String swapped = permutedInput.substring(permutedInput.length ~/ 2) +
      permutedInput.substring(0, permutedInput.length ~/ 2);

  // Final Permutation
  return binaryToHex(permute(swapped, finalPermutation));
}

//
