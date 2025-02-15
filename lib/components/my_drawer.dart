import 'package:chatapp/crypto/aes.dart';
import 'package:chatapp/crypto/caesar_cipher.dart';
import 'package:chatapp/crypto/columnar.dart';
import 'package:chatapp/crypto/des.dart';
import 'package:chatapp/crypto/dh_key_exchange.dart';
import 'package:chatapp/crypto/dsa_signature.dart';
import 'package:chatapp/crypto/ecc.dart';
import 'package:chatapp/crypto/file_e.dart';
import 'package:chatapp/crypto/hashing_integrity_checking.dart';
import 'package:chatapp/crypto/hill_cipher.dart';
import 'package:chatapp/crypto/monoalphabetic.dart';
import 'package:chatapp/crypto/otp.dart';
import 'package:chatapp/crypto/playfair.dart';
import 'package:chatapp/crypto/polyalphabetic.dart';
import 'package:chatapp/crypto/rail_fence.dart';
import 'package:chatapp/crypto/rc4.dart';
import 'package:chatapp/crypto/rsa.dart';
import 'package:chatapp/pages/settings_page.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    //get auth service
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  DrawerHeader(
                    child: Center(
                      child: Lottie.asset(
                        'assets/usera.json',
                        height: MediaQuery.of(context).size.height * 0.3,
                        animate: true,
                      ),

                      // Image.asset(
                      //   "assets/icons/mess_l.png",
                      //   width: 80,
                      //   height: 80,
                      // ),

                      // Icon(
                      //   Icons.message,
                      //   color: Theme.of(context).colorScheme.primary,
                      //   size: 40,
                      // ),
                    ),
                  ),

                  //home list title
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: const Text("H O M E"),
                      leading: const Icon(Icons.home),
                      onTap: () {
                        //pop the drawer
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Divider(
                    color: Colors.black,
                    thickness: 0.2,
                  ),

                  const Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text("Cryptographic Algorithms"),
                  ),
                  const Divider(
                    color: Colors.black,
                    thickness: 0.2,
                  ),

                  //all the crypto functions
                  //1
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: const Text("Caesar Cipher"),
                      leading: const Icon(Icons.aod),
                      onTap: () {
                        //pop the drawer
                        Navigator.pop(context);
                        //navigate to settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CaesarCipher(),
                          ),
                        );
                      },
                    ),
                  ),

                  //2
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: const Text("Monoalphabetic"),
                      leading: const Icon(Icons.aod),
                      onTap: () {
                        //pop the drawer
                        Navigator.pop(context);
                        //navigate to settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MonoalphabeticCipher(),
                          ),
                        );
                      },
                    ),
                  ),
                  //3
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: const Text("Polyalphabetic"),
                      leading: const Icon(Icons.aod),
                      onTap: () {
                        //pop the drawer
                        Navigator.pop(context);
                        //navigate to settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PolyalphabeticCipher(),
                          ),
                        );
                      },
                    ),
                  ),
                  //4
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: const Text("Hill Cipher"),
                      leading: const Icon(Icons.aod),
                      onTap: () {
                        //pop the drawer
                        Navigator.pop(context);
                        //navigate to settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HillCipher(),
                          ),
                        );
                      },
                    ),
                  ),
                  //5
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: const Text("Playfair"),
                      leading: const Icon(Icons.aod),
                      onTap: () {
                        //pop the drawer
                        Navigator.pop(context);
                        //navigate to settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PlayfairApp(),
                          ),
                        );
                      },
                    ),
                  ),
                  //6
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: const Text("OTP"),
                      leading: const Icon(Icons.aod),
                      onTap: () {
                        //pop the drawer
                        Navigator.pop(context);
                        //navigate to settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OTPApp(),
                          ),
                        );
                      },
                    ),
                  ),
                  //7
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: const Text("Rail Fence"),
                      leading: const Icon(Icons.aod),
                      onTap: () {
                        //pop the drawer
                        Navigator.pop(context);
                        //navigate to settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RailFenceCipherApp(),
                          ),
                        );
                      },
                    ),
                  ),
                  //8
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: const Text("Columnar"),
                      leading: const Icon(Icons.aod),
                      onTap: () {
                        //pop the drawer
                        Navigator.pop(context);
                        //navigate to settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ColumnarCipherApp(),
                          ),
                        );
                      },
                    ),
                  ),
                  //9
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: const Text("DES"),
                      leading: const Icon(Icons.aod),
                      onTap: () {
                        //pop the drawer
                        Navigator.pop(context);
                        //navigate to settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DESApp(),
                          ),
                        );
                      },
                    ),
                  ),
                  //10
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: const Text("AES"),
                      leading: const Icon(Icons.aod),
                      onTap: () {
                        //pop the drawer
                        Navigator.pop(context);
                        //navigate to settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AesApp(),
                          ),
                        );
                      },
                    ),
                  ),
                  //11
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: const Text("RC4"),
                      leading: const Icon(Icons.aod),
                      onTap: () {
                        //pop the drawer
                        Navigator.pop(context);
                        //navigate to settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Rc4App(),
                          ),
                        );
                      },
                    ),
                  ),
                  //12
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: const Text("RSA"),
                      leading: const Icon(Icons.aod),
                      onTap: () {
                        //pop the drawer
                        Navigator.pop(context);
                        //navigate to settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RsaApp(),
                          ),
                        );
                      },
                    ),
                  ),
                  //13
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: const Text("ECC"),
                      leading: const Icon(Icons.aod),
                      onTap: () {
                        //pop the drawer
                        Navigator.pop(context);
                        //navigate to settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ECCApp(),
                          ),
                        );
                      },
                    ),
                  ),
                  //14
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: const Text("DH For Key Exchange"),
                      leading: const Icon(Icons.aod),
                      onTap: () {
                        //pop the drawer
                        Navigator.pop(context);
                        //navigate to settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DHKeyExchangeApp(),
                          ),
                        );
                      },
                    ),
                  ),
                  //15
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title:
                          const Text("Hashing (SHA-1) For Integrity Checking"),
                      leading: const Icon(Icons.aod),
                      onTap: () {
                        //pop the drawer
                        Navigator.pop(context);
                        //navigate to settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HashingApp(),
                          ),
                        );
                      },
                    ),
                  ),
                  //16
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: const Text("DSA For Signature"),
                      leading: const Icon(Icons.aod),
                      onTap: () {
                        //pop the drawer
                        Navigator.pop(context);
                        //navigate to settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DSASignatureApp(),
                          ),
                        );
                      },
                    ),
                  ),
                  //17
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: const Text("File Encryption/Decryption"),
                      leading: const Icon(Icons.file_present_outlined),
                      onTap: () {
                        //pop the drawer
                        Navigator.pop(context);
                        //navigate to settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FileEncryptDecrypt(),
                          ),
                        );
                      },
                    ),
                  ),
                  //18
                  const Divider(
                    color: Colors.black,
                    thickness: 0.2,
                  ),

                  //settings list title

                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: const Text("S E T T I N G S"),
                      leading: const Icon(Icons.settings),
                      onTap: () {
                        //pop the drawer
                        Navigator.pop(context);
                        //navigate to settings page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              //logo

              //logout list title

              Padding(
                padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
                child: ListTile(
                  title: const Text("L O G O U T"),
                  leading: const Icon(Icons.logout),
                  onTap: logout,
                ),
              ),
            ],
          ),
        )
        //drawer end
        );
  }
}
