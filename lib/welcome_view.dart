import 'package:flutter/material.dart';
import 'package:hold/colors.dart';
import 'package:hold/constants/routes.dart';
import 'package:hold/ui/primary_button.dart';
import 'package:hold/ui/secondary_button.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes.welcomeTheme,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              children: [
                const Spacer(),
                Text(
                  'hold. charity & care',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Text(
                  'By signing up to Hold, you agree to our Terms of Service. Learn how we process your data in our Privacy Policy',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 40.0,
                ),
                PrimaryButton(
                  text: 'Start giving now',
                  onPressed: () {
                    Navigator.of(context).pushNamed(registerRoute);
                  },
                ),
                SecondaryButton(
                  text: 'Sign in',
                  onTap: () {
                    Navigator.of(context).pushNamed(loginRoute);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
