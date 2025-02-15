import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatelessWidget {
//email and password controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  //TAP Function
  final void Function()? onTap;

  LoginPage({
    super.key,
    required this.onTap,
  });

  //login method
  void login(BuildContext context) async {
    //auth service
    final authService = AuthService();
    //try login
    try {
      await authService.signInWithEmailPassword(
        _emailController.text,
        _pwController.text,
      );
    }
    //catch any error
    catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
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
                const SizedBox(
                  height: 30,
                ),
                Lottie.asset(
                  'assets/log1.json',
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
                  height: 20,
                ),

                //welcome message
                Text(
                  "Welcome back, you've been missed",
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
                  height: 5,
                ),

                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 23),
                    child: GestureDetector(
                      // onTap: onTap,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                ]),

                const SizedBox(
                  height: 20,
                ),

                //login button
                MyButton(
                  text: "Login",
                  onTap: () => login(context),
                ),

                const SizedBox(
                  height: 25,
                ),

                //register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member? ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: Text(
                        "Register now",
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
