import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hold/bad_connection_view.dart';
import 'package:hold/charity_view.dart';
import 'package:hold/colors.dart';
import 'package:hold/constants/database.dart';
import 'package:hold/constants/keystore_keys.dart';
import 'package:hold/constants/routes.dart';
import 'package:hold/firebase_options.dart';
import 'package:hold/home_view.dart';
import 'package:hold/login_view.dart';
import 'package:hold/maintenance_view.dart';
import 'package:hold/out_of_date_view.dart';
import 'package:hold/register_view.dart';
import 'package:hold/services/hold_user.dart';
import 'package:hold/verify_email_view.dart';
import 'package:hold/welcome_view.dart';
import 'package:hold/you_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Themes.mainTheme,
      routes: {
        badConnectionRoute: (context) => const BadConnectionView(),
        maintenanceRoute: (context) => const MaintenanceView(),
        welcomeRoute: (context) => const WelcomeView(),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        homeRoute: (context) => const HomeView(),
        youRoute: (context) => const YouView(),
        charityRoute: (context) => const CharityView(),
      },
      home: const Redirector(),
    );
  }
}

class Redirector extends StatefulWidget {
  const Redirector({super.key});

  @override
  State<Redirector> createState() => _RedirectorState();
}

class _RedirectorState extends State<Redirector> {
  late final ConnectivityResult? _connectivityStatus;
  String? _firstName;
  String? _age;
  List<int> _appVersion = [-1, -1, -1];
  List<int> _currentVersion = [-1, -1, -1];
  bool _maintenance = false;

  Future<void> setup() async {
    _connectivityStatus = await Connectivity().checkConnectivity();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await HoldUser.update();

    FirebaseFirestore db = FirebaseFirestore.instance;

    final appVersionStr = (await PackageInfo.fromPlatform()).version;
    final currentVersionStr = (await db
            .collection(serverCollection)
            .doc(ServerConsts.serverConfigDoc)
            .get())
        .data()?[ServerConsts.appVersionField];
    _appVersion = appVersionStr.split('.').map(int.parse).toList();
    _currentVersion = currentVersionStr.split('.').map(int.parse).toList();

    _maintenance = (await db
                .collection(serverCollection)
                .doc(ServerConsts.serverConfigDoc)
                .get())
            .data()?[ServerConsts.maintenanceField] ??
        true;

    final prefs = await SharedPreferences.getInstance();
    _firstName = prefs.getString(firstNameKey);
    _age = prefs.getString(userAgeKey);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setup(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final user = FirebaseAuth.instance.currentUser;
          if (_connectivityStatus == ConnectivityResult.none) {
            return const BadConnectionView();
          } else if (_appVersion[0] < _currentVersion[0] ||
              _appVersion[1] < _currentVersion[1] ||
              _appVersion[2] < _currentVersion[2]) {
            return const OutOfDateView();
          } else if (_maintenance) {
            return const MaintenanceView();
          } else if (user != null) {
            if (user.emailVerified) {
              return const HomeView();
            } else if (_firstName == null) {
              return const RegisterNameView();
            } else if (_age == null) {
              return const RegisterAgeView();
            } else {
              return const VerifyEmailView();
            }
          } else {
            return const WelcomeView();
          }
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
