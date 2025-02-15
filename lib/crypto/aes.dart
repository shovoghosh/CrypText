import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

class AesApp extends StatefulWidget {
  const AesApp({super.key});

  @override
  State<AesApp> createState() => _AesAppState();
}

class _AesAppState extends State<AesApp> {
  final TextEditingController _textController = TextEditingController();

  String _encrypted = '';
  String _decrypted = '';

  final _keyController = TextEditingController();

  AES? _aes;

  int _key = 0;

  void _encrypt() {
    if (_keyController.text.isNotEmpty) {
      _aes =
          AES(_keyController.text); // Initialize AES with the user-provided key
      var plaintext = Uint8List.fromList(utf8.encode(_textController.text));
      var encrypted = _aes!.encrypt(plaintext);

      setState(() {
        _encrypted = base64Encode(encrypted);
      });
    } else {
      setState(() {
        _encrypted = 'Please enter a key';
      });
    }
  }

  void _decrypt() {
    if (_aes != null) {
      var ciphertext = base64Decode(_encrypted);
      var decrypted = _aes!.decrypt(ciphertext);
      setState(() {
        _decrypted = utf8.decode(decrypted);
      });
    } else {
      setState(() {
        _decrypted = 'Please encrypt something first';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("AES Encryption/Decryption"),
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
                  hintText: "Enter The Text - 16 Characters",
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
                  hintText: "Enter Key - 16 Hexadecimal Characters",
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
class AES {
  static const int Nb = 4;
  int Nk = 4;
  int Nr = 10;
  List<Uint8List> roundKeys = [];

  AES(String key) {
    var keyBytes = Uint8List.fromList(utf8.encode(key));
    keyExpansion(keyBytes);
  }

  void keyExpansion(Uint8List key) {
    // Key size must be exactly 16 bytes (128 bits) for AES-128
    if (key.length != 16) {
      throw ArgumentError('Key must be exactly 128 bits long');
    }

    int currentSize = 0;
    int rconIteration = 1;
    Uint8List temp = Uint8List(4);

    // The first round key is the key itself
    for (int i = 0; i < Nk; i++, currentSize += 4) {
      roundKeys.add(Uint8List.fromList(
          [key[4 * i], key[4 * i + 1], key[4 * i + 2], key[4 * i + 3]]));
    }

    // All other round keys are found from the previous round keys
    while (currentSize < (Nb * (Nr + 1)) * 4) {
      for (int i = 0; i < 4; i++) {
        temp[i] = roundKeys.last[i];
      }

      if (currentSize % (Nk * 4) == 0) {
        temp = _keyScheduleCore(temp, rconIteration++);
        temp[0] ^= roundKeys[roundKeys.length - Nk][0];
        temp[1] ^= roundKeys[roundKeys.length - Nk][1];
        temp[2] ^= roundKeys[roundKeys.length - Nk][2];
        temp[3] ^= roundKeys[roundKeys.length - Nk][3];
      } else if (Nk > 6 && currentSize % (Nk * 4) == 16) {
        temp = _subWord(temp);
        temp[0] ^= roundKeys[roundKeys.length - Nk][0];
        temp[1] ^= roundKeys[roundKeys.length - Nk][1];
        temp[2] ^= roundKeys[roundKeys.length - Nk][2];
        temp[3] ^= roundKeys[roundKeys.length - Nk][3];
      } else {
        for (int i = 0; i < 4; i++) {
          temp[i] ^= roundKeys[roundKeys.length - Nk][i];
        }
      }

      roundKeys.add(Uint8List.fromList([temp[0], temp[1], temp[2], temp[3]]));
      currentSize += 4;
    }
  }

  Uint8List _keyScheduleCore(Uint8List inWord, int iteration) {
    // Rotate the input 8 bits to the left
    Uint8List out = Uint8List(4);
    out[0] = inWord[1];
    out[1] = inWord[2];
    out[2] = inWord[3];
    out[3] = inWord[0];

    // Apply S-box substitution on all 4 bytes of the output
    for (int i = 0; i < 4; i++) {
      out[i] = sBox[out[i]];
    }

    // XOR the output with the Rcon value for this iteration
    out[0] ^= rCon[iteration];
    return out;
  }

  Uint8List _subWord(Uint8List inWord) {
    Uint8List out = Uint8List(4);
    for (int i = 0; i < 4; i++) {
      out[i] = sBox[inWord[i]];
    }
    return out;
  }

  // Rijndael S-box
  static const List<int> sBox = [
    0x63,
    0x7c,
    0x77,
    0x7b,
    0xf2,
    0x6b,
    0x6f,
    0xc5,
    0x30,
    0x01,
    0x67,
    0x2b,
    0xfe,
    0xd7,
    0xab,
    0x76,
    0xca,
    0x82,
    0xc9,
    0x7d,
    0xfa,
    0x59,
    0x47,
    0xf0,
    0xad,
    0xd4,
    0xa2,
    0xaf,
    0x9c,
    0xa4,
    0x72,
    0xc0,
    0xb7,
    0xfd,
    0x93,
    0x26,
    0x36,
    0x3f,
    0xf7,
    0xcc,
    0x34,
    0xa5,
    0xe5,
    0xf1,
    0x71,
    0xd8,
    0x31,
    0x15,
    0x04,
    0xc7,
    0x23,
    0xc3,
    0x18,
    0x96,
    0x05,
    0x9a,
    0x07,
    0x12,
    0x80,
    0xe2,
    0xeb,
    0x27,
    0xb2,
    0x75,
    0x09,
    0x83,
    0x2c,
    0x1a,
    0x1b,
    0x6e,
    0x5a,
    0xa0,
    0x52,
    0x3b,
    0xd6,
    0xb3,
    0x29,
    0xe3,
    0x2f,
    0x84,
    0x53,
    0xd1,
    0x00,
    0xed,
    0x20,
    0xfc,
    0xb1,
    0x5b,
    0x6a,
    0xcb,
    0xbe,
    0x39,
    0x4a,
    0x4c,
    0x58,
    0xcf,
    0xd0,
    0xef,
    0xaa,
    0xfb,
    0x43,
    0x4d,
    0x33,
    0x85,
    0x45,
    0xf9,
    0x02,
    0x7f,
    0x50,
    0x3c,
    0x9f,
    0xa8,
    0x51,
    0xa3,
    0x40,
    0x8f,
    0x92,
    0x9d,
    0x38,
    0xf5,
    0xbc,
    0xb6,
    0xda,
    0x21,
    0x10,
    0xff,
    0xf3,
    0xd2,
    0xcd,
    0x0c,
    0x13,
    0xec,
    0x5f,
    0x97,
    0x44,
    0x17,
    0xc4,
    0xa7,
    0x7e,
    0x3d,
    0x64,
    0x5d,
    0x19,
    0x73,
    0x60,
    0x81,
    0x4f,
    0xdc,
    0x22,
    0x2a,
    0x90,
    0x88,
    0x46,
    0xee,
    0xb8,
    0x14,
    0xde,
    0x5e,
    0x0b,
    0xdb,
    0xe0,
    0x32,
    0x3a,
    0x0a,
    0x49,
    0x06,
    0x24,
    0x5c,
    0xc2,
    0xd3,
    0xac,
    0x62,
    0x91,
    0x95,
    0xe4,
    0x79,
    0xe7,
    0xc8,
    0x37,
    0x6d,
    0x8d,
    0xd5,
    0x4e,
    0xa9,
    0x6c,
    0x56,
    0xf4,
    0xea,
    0x65,
    0x7a,
    0xae,
    0x08,
    0xba,
    0x78,
    0x25,
    0x2e,
    0x1c,
    0xa6,
    0xb4,
    0xc6,
    0xe8,
    0xdd,
    0x74,
    0x1f,
    0x4b,
    0xbd,
    0x8b,
    0x8a,
    0x70,
    0x3e,
    0xb5,
    0x66,
    0x48,
    0x03,
    0xf6,
    0x0e,
    0x61,
    0x35,
    0x57,
    0xb9,
    0x86,
    0xc1,
    0x1d,
    0x9e,
    0xe1,
    0xf8,
    0x98,
    0x11,
    0x69,
    0xd9,
    0x8e,
    0x94,
    0x9b,
    0x1e,
    0x87,
    0xe9,
    0xce,
    0x55,
    0x28,
    0xdf,
    0x8c,
    0xa1,
    0x89,
    0x0d,
    0xbf,
    0xe6,
    0x42,
    0x68,
    0x41,
    0x99,
    0x2d,
    0x0f,
    0xb0,
    0x54,
    0xbb,
    0x16
  ];

  // Rcon (round constant) array
  static const List<int> rCon = [
    0x00,
    0x01,
    0x02,
    0x03,
    0x04,
    0x05,
    0x06,
    0x07,
    0x08,
    0x09,
    0x0A,
    0x0B,
    0x0C,
    0x0D,
    0x0E,
    0x0F,
    0x10,
    0x11,
    0x12,
    0x13,
    0x14,
    0x15,
    0x16,
    0x17,
    0x18,
    0x19,
    0x1A,
    0x1B,
    0x1C,
    0x1D,
    0x1E,
    0x1F,
    0x20,
    0x21,
    0x22,
    0x23,
    0x24,
    0x25,
    0x26,
    0x27,
    0x28,
    0x29,
    0x2A,
    0x2B,
    0x2C,
    0x2D,
    0x2E,
    0x2F,
    0x30,
    0x31,
    0x32,
    0x33,
    0x34,
    0x35,
    0x36,
    0x37,
    0x38,
    0x39,
    0x3A,
    0x3B,
    0x3C,
    0x3D,
    0x3E,
    0x3F,
    0x40,
    0x41,
    0x42,
    0x43,
    0x44,
    0x45,
    0x46,
    0x47,
    0x48,
    0x49,
    0x4A,
    0x4B,
    0x4C,
    0x4D,
    0x4E,
    0x4F,
    0x50,
    0x51,
    0x52,
    0x53,
    0x54,
    0x55,
    0x56,
    0x57,
    0x58,
    0x59,
    0x5A,
    0x5B,
    0x5C,
    0x5D,
    0x5E,
    0x5F,
    0x60,
    0x61,
    0x62,
    0x63,
    0x64,
    0x65,
    0x66,
    0x67,
    0x68,
    0x69,
    0x6A,
    0x6B,
    0x6C,
    0x6D,
    0x6E,
    0x6F,
    0x70,
    0x71,
    0x72,
    0x73,
    0x74,
    0x75,
    0x76,
    0x77,
    0x78,
    0x79,
    0x7A,
    0x7B,
    0x7C,
    0x7D,
    0x7E,
    0x7F,
    0x80,
    0x81,
    0x82,
    0x83,
    0x84,
    0x85,
    0x86,
    0x87,
    0x88,
    0x89,
    0x8A,
    0x8B,
    0x8C,
    0x8D,
    0x8E,
    0x8F,
    0x90,
    0x91,
    0x92,
    0x93,
    0x94,
    0x95,
    0x96,
    0x97,
    0x98,
    0x99,
    0x9A,
    0x9B,
    0x9C,
    0x9D,
    0x9E,
    0x9F,
    0xA0,
    0xA1,
    0xA2,
    0xA3,
    0xA4,
    0xA5,
    0xA6,
    0xA7,
    0xA8,
    0xA9,
    0xAA,
    0xAB,
    0xAC,
    0xAD,
    0xAE,
    0xAF,
    0xB0,
    0xB1,
    0xB2,
    0xB3,
    0xB4,
    0xB5,
    0xB6,
    0xB7,
    0xB8,
    0xB9,
    0xBA,
    0xBB,
    0xBC,
    0xBD,
    0xBE,
    0xBF,
    0xC0,
    0xC1,
    0xC2,
    0xC3,
    0xC4,
    0xC5,
    0xC6,
    0xC7,
    0xC8,
    0xC9,
    0xCA,
    0xCB,
    0xCC,
    0xCD,
    0xCE,
    0xCF,
    0xD0,
    0xD1,
    0xD2,
    0xD3,
    0xD4,
    0xD5,
    0xD6,
    0xD7,
    0xD8,
    0xD9,
    0xDA,
    0xDB,
    0xDC,
    0xDD,
    0xDE,
    0xDF,
    0xE0,
    0xE1,
    0xE2,
    0xE3,
    0xE4,
    0xE5,
    0xE6,
    0xE7,
    0xE8,
    0xE9,
    0xEA,
    0xEB,
    0xEC,
    0xED,
    0xEE,
    0xEF,
    0xF0,
    0xF1,
    0xF2,
    0xF3,
    0xF4,
    0xF5,
    0xF6,
    0xF7,
    0xF8,
    0xF9,
    0xFA,
    0xFB,
    0xFC,
    0xFD,
    0xFE,
    0xFF
  ];

  Uint8List encrypt(Uint8List plaintext) {
    List<Uint8List> state = [];
    for (int i = 0; i < 4; i++) {
      state.add(Uint8List(4));
      for (int j = 0; j < 4; j++) {
        state[i][j] = plaintext[i + 4 * j];
      }
    }

    addRoundKey(state, 0);

    for (int round = 1; round < Nr; round++) {
      subBytes(state);
      shiftRows(state);
      mixColumns(state);
      addRoundKey(state, round);
    }

    // Final round
    subBytes(state);
    shiftRows(state);
    addRoundKey(state, Nr);

    // Convert state back to Uint8List
    Uint8List output = Uint8List(16);
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        output[i + 4 * j] = state[i][j];
      }
    }

    return output;
  }

  Uint8List hexStringToBytes(String hex) {
    // Removing any whitespace or non-visible characters
    hex = hex.replaceAll(RegExp(r'\s+'), '');

    // Check for non-hexadecimal characters
    if (RegExp(r'[^0-9A-Fa-f]').hasMatch(hex)) {
      throw FormatException('Hex string contains invalid characters');
    }

    // Ensure the string has an even number of characters
    if (hex.length % 2 != 0) {
      throw FormatException('Hex string must have an even length');
    }

    List<int> bytes = [];
    for (int i = 0; i < hex.length; i += 2) {
      String hexByte = hex.substring(i, i + 2);
      bytes.add(int.parse(hexByte, radix: 16));
    }
    return Uint8List.fromList(bytes);
  }

  void subBytes(List<Uint8List> state) {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        state[i][j] = sBox[state[i][j]];
      }
    }
  }

  void shiftRows(List<Uint8List> state) {
    Uint8List temp = Uint8List(4);
    for (int r = 1; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        temp[c] = state[r][(c + r) % 4];
      }
      for (int c = 0; c < 4; c++) {
        state[r][c] = temp[c];
      }
    }
  }

  void mixColumns(List<Uint8List> state) {
    for (int c = 0; c < 4; c++) {
      Uint8List a = Uint8List(4);
      Uint8List b = Uint8List(4);

      // Copy current state column to `a` and prepare `b` where each element in `b` is `a` multiplied by 2
      for (int i = 0; i < 4; i++) {
        a[i] = state[i][c];
        b[i] = (a[i] << 1) &
            0xFF; // Multiply by 2 in GF(2^8) and apply mask to ensure byte limit
        if ((a[i] & 0x80) != 0) {
          // if the high bit is 1, we need to reduce modulo 0x11B (x^8 + x^4 + x^3 + x + 1)
          b[i] ^= 0x1B;
        }
      }

      // Mix columns by calculating new values
      state[0][c] = (b[0] ^ a[1] ^ b[1] ^ a[2] ^ a[3]);
      state[1][c] = (a[0] ^ b[1] ^ a[2] ^ b[2] ^ a[3]);
      state[2][c] = (a[0] ^ a[1] ^ b[2] ^ a[3] ^ b[3]);
      state[3][c] = (a[0] ^ b[0] ^ a[1] ^ a[2] ^ b[3]);
    }
  }

  static const List<int> invSBox = [
    0x52,
    0x09,
    0x6a,
    0xd5,
    0x30,
    0x36,
    0xa5,
    0x38,
    0xbf,
    0x40,
    0xa3,
    0x9e,
    0x81,
    0xf3,
    0xd7,
    0xfb,
    0x7c,
    0xe3,
    0x39,
    0x82,
    0x9b,
    0x2f,
    0xff,
    0x87,
    0x34,
    0x8e,
    0x43,
    0x44,
    0xc4,
    0xde,
    0xe9,
    0xcb,
    0x54,
    0x7b,
    0x94,
    0x32,
    0xa6,
    0xc2,
    0x23,
    0x3d,
    0xee,
    0x4c,
    0x95,
    0x0b,
    0x42,
    0xfa,
    0xc3,
    0x4e,
    0x08,
    0x2e,
    0xa1,
    0x66,
    0x28,
    0xd9,
    0x24,
    0xb2,
    0x76,
    0x5b,
    0xa2,
    0x49,
    0x6d,
    0x8b,
    0xd1,
    0x25,
    0x72,
    0xf8,
    0xf6,
    0x64,
    0x86,
    0x68,
    0x98,
    0x16,
    0xd4,
    0xa4,
    0x5c,
    0xcc,
    0x5d,
    0x65,
    0xb6,
    0x92,
    0x6c,
    0x70,
    0x48,
    0x50,
    0xfd,
    0xed,
    0xb9,
    0xda,
    0x5e,
    0x15,
    0x46,
    0x57,
    0xa7,
    0x8d,
    0x9d,
    0x84,
    0x90,
    0xd8,
    0xab,
    0x00,
    0x8c,
    0xbc,
    0xd3,
    0x0a,
    0xf7,
    0xe4,
    0x58,
    0x05,
    0xb8,
    0xb3,
    0x45,
    0x06,
    0xd0,
    0x2c,
    0x1e,
    0x8f,
    0xca,
    0x3f,
    0x0f,
    0x02,
    0xc1,
    0xaf,
    0xbd,
    0x03,
    0x01,
    0x13,
    0x8a,
    0x6b,
    0x3a,
    0x91,
    0x11,
    0x41,
    0x4f,
    0x67,
    0xdc,
    0xea,
    0x97,
    0xf2,
    0xcf,
    0xce,
    0xf0,
    0xb4,
    0xe6,
    0x73,
    0x96,
    0xac,
    0x74,
    0x22,
    0xe7,
    0xad,
    0x35,
    0x85,
    0xe2,
    0xf9,
    0x37,
    0xe8,
    0x1c,
    0x75,
    0xdf,
    0x6e,
    0x47,
    0xf1,
    0x1a,
    0x71,
    0x1d,
    0x29,
    0xc5,
    0x89,
    0x6f,
    0xb7,
    0x62,
    0x0e,
    0xaa,
    0x18,
    0xbe,
    0x1b,
    0xfc,
    0x56,
    0x3e,
    0x4b,
    0xc6,
    0xd2,
    0x79,
    0x20,
    0x9a,
    0xdb,
    0xc0,
    0xfe,
    0x78,
    0xcd,
    0x5a,
    0xf4,
    0x1f,
    0xdd,
    0xa8,
    0x33,
    0x88,
    0x07,
    0xc7,
    0x31,
    0xb1,
    0x12,
    0x10,
    0x59,
    0x27,
    0x80,
    0xec,
    0x5f,
    0x60,
    0x51,
    0x7f,
    0xa9,
    0x19,
    0xb5,
    0x4a,
    0x0d,
    0x2d,
    0xe5,
    0x7a,
    0x9f,
    0x93,
    0xc9,
    0x9c,
    0xef,
    0xa0,
    0xe0,
    0x3b,
    0x4d,
    0xae,
    0x2a,
    0xf5,
    0xb0,
    0xc8,
    0xeb,
    0xbb,
    0x3c,
    0x83,
    0x53,
    0x99,
    0x61,
    0x17,
    0x2b,
    0x04,
    0x7e,
    0xba,
    0x77,
    0xd6,
    0x26,
    0xe1,
    0x69,
    0x14,
    0x63,
    0x55,
    0x21,
    0x0c,
    0x7d
  ];

  Uint8List decrypt(Uint8List ciphertext) {
    List<Uint8List> state = [];
    for (int i = 0; i < 4; i++) {
      state.add(Uint8List(4));
      for (int j = 0; j < 4; j++) {
        state[i][j] = ciphertext[i + 4 * j];
      }
    }

    addRoundKey(state, Nr);

    for (int round = Nr - 1; round > 0; round--) {
      invShiftRows(state);
      invSubBytes(state);
      addRoundKey(state, round);
      invMixColumns(state);
    }

    invShiftRows(state);
    invSubBytes(state);
    addRoundKey(state, 0);

    Uint8List output = Uint8List(16);
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        output[i + 4 * j] = state[i][j];
      }
    }

    return output;
  }

  void addRoundKey(List<Uint8List> state, int round) {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        state[j][i] ^= roundKeys[round * Nb + i][j];
      }
    }
  }

  void invSubBytes(List<Uint8List> state) {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        state[i][j] = invSBox[state[i][j]];
      }
    }
  }

  void invShiftRows(List<Uint8List> state) {
    Uint8List temp = Uint8List(4);
    // Row 1
    for (int i = 0; i < 4; i++) temp[i] = state[1][(i + 3) % 4];
    for (int i = 0; i < 4; i++) state[1][i] = temp[i];
    // Row 2
    for (int i = 0; i < 4; i++) temp[i] = state[2][(i + 2) % 4];
    for (int i = 0; i < 4; i++) state[2][i] = temp[i];
    // Row 3
    for (int i = 0; i < 4; i++) temp[i] = state[3][(i + 1) % 4];
    for (int i = 0; i < 4; i++) state[3][i] = temp[i];
  }

  void invMixColumns(List<Uint8List> state) {
    for (int i = 0; i < 4; i++) {
      Uint8List column = Uint8List(4);
      for (int j = 0; j < 4; j++) {
        column[j] = state[j][i];
      }

      state[0][i] = mul(column[0], 0x0e) ^
          mul(column[1], 0x0b) ^
          mul(column[2], 0x0d) ^
          mul(column[3], 0x09);
      state[1][i] = mul(column[0], 0x09) ^
          mul(column[1], 0x0e) ^
          mul(column[2], 0x0b) ^
          mul(column[3], 0x0d);
      state[2][i] = mul(column[0], 0x0d) ^
          mul(column[1], 0x09) ^
          mul(column[2], 0x0e) ^
          mul(column[3], 0x0b);
      state[3][i] = mul(column[0], 0x0b) ^
          mul(column[1], 0x0d) ^
          mul(column[2], 0x09) ^
          mul(column[3], 0x0e);
    }
  }

  int mul(int a, int b) {
    int product = 0;
    for (int i = 0; i < 8; i++) {
      if ((b & 0x01) != 0) {
        product ^= a;
      }
      int hi_bit = a & 0x80;
      a <<= 1;
      if (hi_bit != 0) {
        a ^= 0x1b; // x^8 + x^4 + x^3 + x + 1
      }
      b >>= 1;
    }
    return product;
  }
}
