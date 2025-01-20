import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hold/colors.dart';
import 'package:hold/constants/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utilities/show_snack_bar.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes.welcomeTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verify your email'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 25.0,
            right: 25.0,
            bottom: 30.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                  'Almost there! Verify your Hold email so we can create your account.'),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  textStyle: MaterialStateProperty.all(
                      const TextStyle(fontWeight: FontWeight.bold)),
                ),
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.currentUser
                        ?.sendEmailVerification();
                    if (context.mounted) {
                      showSnackBar(
                        context,
                        content: const Text('Sent email verification'),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showSnackBar(
                        context,
                        content: const Text('An error occured'),
                      );
                    }
                  }
                },
                child: const Text('Didn\'t receive verification?'),
              ),
              const SizedBox(
                height: 270.0,
              ),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  textStyle: MaterialStateProperty.all(
                      const TextStyle(fontWeight: FontWeight.bold)),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();

                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        welcomeRoute, (route) => false);
                  }
                },
                child: const Text('Or you can log out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
