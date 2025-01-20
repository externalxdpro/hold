import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hold/colors.dart';
import 'package:hold/constants/database.dart';
import 'package:hold/constants/keystore_keys.dart';
import 'package:hold/firebase_options.dart';
import 'package:hold/ui/primary_button.dart';
import 'package:hold/ui/small_button.dart';
import 'package:hold/ui/themed_text_field.dart';
import 'package:hold/utilities/generate_uuid.dart';
import 'package:hold/utilities/show_snack_bar.dart';
import 'package:hold/verify_email_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

final db = FirebaseFirestore.instance;
const storage = FlutterSecureStorage();

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  RegisterViewState createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {
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
                'Smarter giving',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Text('Your causes, no confusing taxes'),
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
                        text: 'Register',
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: _email.text,
                              password: _password.text,
                            );

                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString(emailKey, _email.text);

                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                builder: (context) {
                                  return const RegisterNameView();
                                },
                              ), (route) => false);
                            }
                          } on FirebaseAuthException catch (e) {
                            if (context.mounted) {
                              showSnackBar(
                                context,
                                content: Text(
                                    'Error: ${e.code.replaceAll('-', ' ')}'),
                              );
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

class RegisterNameView extends StatefulWidget {
  const RegisterNameView({super.key});

  @override
  RegisterNameViewState createState() => RegisterNameViewState();
}

class RegisterNameViewState extends State<RegisterNameView> {
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;

  @override
  void initState() {
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes.welcomeTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your legal name'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 25.0,
            right: 25.0,
            bottom: 30.0,
          ),
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ThemedTextField(
                    controller: _firstName,
                    hintText: 'First name',
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  ThemedTextField(
                    controller: _lastName,
                    hintText: 'Last name',
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  const Text(
                    'Spell it as it appears on your ID',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: SmallButton(
                  text: 'Next',
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString(firstNameKey, _firstName.text);
                    await prefs.setString(lastNameKey, _lastName.text);

                    if (context.mounted) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return const RegisterAgeView();
                        },
                      ));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterAgeView extends StatefulWidget {
  const RegisterAgeView({super.key});

  @override
  RegisterAgeViewState createState() => RegisterAgeViewState();
}

class RegisterAgeViewState extends State<RegisterAgeView> {
  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes.welcomeTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your age'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 25.0,
            right: 25.0,
            bottom: 30.0,
          ),
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 150.0,
                    child: CupertinoDatePicker(
                        backgroundColor:
                            Themes.welcomeTheme.colorScheme.background,
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (newDate) {
                          setState(() => _date = newDate);
                        }),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Text(
                      '${DateTime.now().difference(_date).inDays ~/ 365} years old'),
                  const SizedBox(
                    height: 50.0,
                  ),
                  const Text(
                    'Your legal date of birth',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: SmallButton(
                  text: 'Next',
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString(userAgeKey, _date.toString());

                    if (context.mounted) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const RegisterLegalView(),
                      ));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterLegalView extends StatelessWidget {
  const RegisterLegalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Legal agreements'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 25.0,
          right: 25.0,
          bottom: 30.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Make sure you read and accept the following:'),
            const SizedBox(height: 10.0),
            GestureDetector(
              onTap: () async {
                if (!await launchUrl(
                    Uri.parse('https://donatehold.com/privacy'))) {
                  if (context.mounted) {
                    showSnackBar(context,
                        content: const Text('Couldn\'t open link'));
                  }
                }
              },
              child: const Row(
                children: [
                  SizedBox(width: 20.0),
                  Text(
                    'Privacy Policy',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (!await launchUrl(
                    Uri.parse('https://donatehold.com/terms'))) {
                  if (context.mounted) {
                    showSnackBar(context,
                        content: const Text('Couldn\'t open link'));
                  }
                }
              },
              child: const Row(
                children: [
                  SizedBox(width: 20.0),
                  Text(
                    'Terms of Use',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(
              text: 'Accept',
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();

                final users = db.collection(usersCollection);
                final user = FirebaseAuth.instance.currentUser;

                final email = prefs.getString(emailKey);
                final firstName = prefs.getString(firstNameKey);
                final lastName = prefs.getString(lastNameKey);
                final DateTime userAge =
                    DateTime.parse(prefs.getString(userAgeKey)!);

                final notificationToken =
                    await FirebaseMessaging.instance.getToken();
                if (await storage.read(key: deviceUIDKey) == null) {
                  await storage.write(
                    key: deviceUIDKey,
                    value: generateUUID(),
                  );
                }
                final deviceUID = await storage.read(key: deviceUIDKey);

                users.doc(user?.uid).set(<String, dynamic>{
                  UserConsts.firstNameField: firstName,
                  UserConsts.lastNameField: lastName,
                  UserConsts.userAgeField: userAge,
                  UserConsts.userBadgesField: [],
                  UserConsts.uidField: user?.uid,
                  UserConsts.userCreatedAccountField: DateTime.now(),
                  UserConsts.portfolioField: [],
                  UserConsts.notificationTokenField: notificationToken,
                  UserConsts.deviceUIDField: deviceUID,
                  UserConsts.premiumUserField: false,
                  UserConsts.portfolioDonationField: 0.0,
                  UserConsts.totalMonthlyDonationField: 0.0,
                  UserConsts.totalDonationField: 0.0,
                  UserConsts.emailField: email,
                  UserConsts.stripeCustomerIDField: '',
                });

                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) {
                        return const VerifyEmailView();
                      },
                    ),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
