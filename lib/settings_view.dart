import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hold/constants/database.dart';
import 'package:hold/constants/routes.dart';
import 'package:hold/services/hold_user.dart';
import 'package:hold/ui/themed_tiles.dart';
import 'package:hold/utilities/show_snack_bar.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 30.0,
          right: 30.0,
          bottom: 20.0,
        ),
        child: ListView(
          children: [
            Text(
              'settings.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20.0),
            InfoTile(
              title: 'Account info',
              content: [
                [
                  const Text('First name'),
                  Text(HoldUser.firstName.toString()),
                ],
                [
                  const Text('Last name'),
                  Text(HoldUser.lastName.toString()),
                ],
                [
                  const Text('Joined'),
                  Text(DateFormat('MMM dd, yyyy').format(
                      HoldUser.userCreatedAccount ??
                          DateTime.fromMillisecondsSinceEpoch(0))),
                ],
                const [Text('Platform'), Text('Android')],
              ],
            ),
            const SizedBox(height: 40.0),
            InfoTile(
              title: 'Hold',
              seperatorHeight: 10.0,
              onPressed: [
                () async {
                  if (!await launchUrl(
                      Uri.parse('https://donatehold.com/privacy'))) {
                    if (context.mounted) {
                      showSnackBar(context,
                          content: const Text('Couldn\'t open link'));
                    }
                  }
                },
                () async {
                  if (!await launchUrl(
                      Uri.parse('https://donatehold.com/terms'))) {
                    if (context.mounted) {
                      showSnackBar(context,
                          content: const Text('Couldn\'t open link'));
                    }
                  }
                },
              ],
              content: const [
                // [
                //   Text('Agreements'),
                //   Icon(Icons.navigate_next, color: Colors.grey),
                // ],
                // [
                //   Text('Foundation'),
                //   Icon(Icons.navigate_next, color: Colors.grey),
                // ],
                // [
                //   Text('Support'),
                //   Icon(Icons.navigate_next, color: Colors.grey),
                // ],
                // [
                //   Text('Merits'),
                //   Icon(Icons.navigate_next, color: Colors.grey),
                // ],
                [
                  Text('Privacy Policy'),
                  Icon(Icons.navigate_next, color: Colors.grey),
                ],
                [
                  Text('Terms of Service'),
                  Icon(Icons.navigate_next, color: Colors.grey),
                ],
              ],
            ),
            const SizedBox(height: 40.0),
            IconWithButtonTile(
              title: 'Log out',
              content: const [
                [Text('From you account'), null],
              ],
              buttonText: 'Log out',
              onTap: () async {
                const storage = FlutterSecureStorage();
                storage.deleteAll();
                await FirebaseAuth.instance.signOut();

                if (context.mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(welcomeRoute, (route) => false);
                }
              },
            ),
            const SizedBox(height: 40.0),
            Center(
                child: Text(
              'funny how sometimes you just, find things.',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.grey),
            )),
            const SizedBox(height: 40.0),
            IconWithButtonTile(
              title: 'Delete account',
              content: const [
                [Text('Cannot be restored'), null],
              ],
              buttonText: 'Delete forever',
              buttonColor: Colors.red,
              onTap: () async {
                const storage = FlutterSecureStorage();
                storage.deleteAll();

                final user = FirebaseAuth.instance.currentUser;
                FirebaseFirestore.instance
                    .collection(usersCollection)
                    .doc(user?.uid)
                    .delete();
                user?.delete();

                if (context.mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(welcomeRoute, (route) => false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
