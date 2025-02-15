import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class RegisterPage extends StatelessWidget {
  //email and password controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmpwController = TextEditingController();
  //TAP Function
  final void Function()? onTap;

  RegisterPage({
    super.key,
    required this.onTap,
  });

  void register(BuildContext context) {
    //Register method
    //get auth service
    final _auth = AuthService();

//password match create user
    if (_pwController.text == _confirmpwController.text) {
      try {
        _auth.signUpWithEmailPassword(
          _emailController.text,
          _pwController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
    //password donot match => tell user to fix
    else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Password don't match!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/reg1.json',
                  height: MediaQuery.of(context).size.height * 0.3,
                  animate: true,
                ),
                //logo
                // Icon(
                //   Icons.message,
                //   size: 60,
                //   color: Theme.of(context).colorScheme.primary,
                // ),

                const SizedBox(
                  height: 30,
                ),

                //welcome message
                Text(
                  "Let's create an account for you!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),

                //email textfeild
                MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: _emailController,
                ),
                const SizedBox(
                  height: 10,
                ),

                //pw textfield
                MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: _pwController,
                ),
                const SizedBox(
                  height: 10,
                ),

                //pw textfield
                MyTextField(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: _confirmpwController,
                ),
                const SizedBox(
                  height: 25,
                ),

                //login button
                MyButton(
                  text: "Register",
                  onTap: () => register(context),
                ),
                const SizedBox(
                  height: 25,
                ),

                //register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: Text(
                        "Login now",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
