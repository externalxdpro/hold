import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hold/constants/routes.dart';
import 'package:hold/services/hold_user.dart';
import 'package:hold/settings_view.dart';
import 'package:hold/ui/themed_tiles.dart';
import 'package:hold/utilities/show_snack_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool secret1 = false;

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      secret1 = false;
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 120.0,
          left: 30.0,
          right: 30.0,
          bottom: 20.0,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsView(),
                    ),
                  );
                },
                icon: const Icon(Icons.person),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onDoubleTap: () {
                    if (secret1) {
                      showSnackBar(context,
                          content: const Text('App developed by: Sakib Ahmed'));
                    }
                  },
                  child: Text(
                    'hello ${HoldUser.firstName?.toLowerCase()}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'you are giving ',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12.0,
                        ),
                    children: [
                      TextSpan(
                          text: '\$${HoldUser.totalMonthlyDonation?.floor()}',
                          style: const TextStyle(color: Colors.green)),
                      const TextSpan(text: ' this month with hold.'),
                    ],
                  ),
                ),
                const SizedBox(height: 25.0),
                HomeTile(
                  title: 'charity.',
                  subtitle: 'discover & give',
                  onTap: () async {
                    if (context.mounted) {
                      Navigator.of(context).pushNamed(charityRoute);
                    }
                  },
                ),
                const Spacer(),
                Center(
                  child: GestureDetector(
                    onLongPress: () {
                      secret1 = true;
                    },
                    child: Text(
                      'hold. charity & care',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     HomeTile(
            //       title: 'you.',
            //       subtitle: 'information & care',
            //       onTap: () {
            //         Navigator.of(context).pushNamed(youRoute);
            //       },
            //     ),
            //     const SizedBox(height: 25.0),
            //     HomeTile(
            //       title: 'charity.',
            //       subtitle: 'discover & give',
            //       onTap: () async {
            //         if (context.mounted) {
            //           Navigator.of(context).pushNamed(charityRoute);
            //         }
            //       },
            //     ),
            //     const SizedBox(height: 25.0),
            //     const InactiveHomeTile(
            //       title: 'portfolio.',
            //       subtitle: 'your basket.',
            //     ),
            //     const SizedBox(height: 20.0),
            //     Text(
            //       'hold. charity & care',
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodyMedium
            //           ?.copyWith(color: Colors.grey),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
