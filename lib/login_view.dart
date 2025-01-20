import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hold/colors.dart';
import 'package:hold/firebase_options.dart';
import 'package:hold/main.dart';
import 'package:hold/ui/primary_button.dart';
import 'package:hold/ui/themed_text_field.dart';
import 'package:hold/utilities/show_snack_bar.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes.welcomeTheme,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 25.0,
            right: 25.0,
            bottom: 50.0,
          ),
          child: Column(
            children: [
              const Spacer(),
              Text(
                'blaze your care.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              ThemedTextField(
                controller: _email,
                hintText: 'Email',
              ),
              const SizedBox(
                height: 15.0,
              ),
              ThemedTextField(
                controller: _password,
                hintText: 'Password',
                obscureText: true,
              ),
              const Spacer(),
              FutureBuilder(
                future: Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                ),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return PrimaryButton(
                        text: 'Sign in',
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;

                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const Redirector()),
                                  (route) => false);
                            }
                          } on FirebaseAuthException catch (e) {
                            if (context.mounted) {
                              showSnackBar(context,
                                  content: Text(
                                      'Error: ${e.code.replaceAll('-', ' ')}'));
                            }
                          }
                        },
                      );
                    default:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
