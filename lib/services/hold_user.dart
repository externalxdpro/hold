import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hold/constants/database.dart';

class HoldUser {
  static String? firstName;
  static String? lastName;
  static DateTime? userAge;
  static List<String>? userBadges;
  static String? uid;
  static DateTime? userCreatedAccount;
  static List<String>? portfolio;
  static String? notificationToken;
  static String? deviceUID;
  static bool? premiumUser;
  static double? portfolioDonation;
  static double? totalMonthlyDonation;
  static double? totalDonation;
  static String? email;
  static String? stripeCustomerID;

  static Future<void> update() async {
    final user = FirebaseAuth.instance.currentUser;
    final Map<String, dynamic>? fields = (await FirebaseFirestore.instance
            .collection(usersCollection)
            .doc(user?.uid)
            .get())
        .data();

    if (fields == null) {
      throw Exception('Failed to update.');
    }

    firstName = fields[UserConsts.firstNameField];
    lastName = fields[UserConsts.lastNameField];
    userAge = fields[UserConsts.userAgeField].toDate();
    userBadges = fields[UserConsts.userBadgesField].cast<String>();
    uid = fields[UserConsts.uidField];
    userCreatedAccount = fields[UserConsts.userCreatedAccountField].toDate();
    portfolio = fields[UserConsts.portfolioField].cast<String>();
    notificationToken = fields[UserConsts.notificationTokenField];
    deviceUID = fields[UserConsts.deviceUIDField];
    premiumUser = fields[UserConsts.premiumUserField];
    portfolioDonation = fields[UserConsts.portfolioDonationField].toDouble();
    totalMonthlyDonation =
        fields[UserConsts.totalMonthlyDonationField]?.toDouble();
    totalDonation = fields[UserConsts.totalDonationField].toDouble();
    email = fields[UserConsts.emailField];
    stripeCustomerID = fields[UserConsts.stripeCustomerIDField];
  }

  static Future<void> setField(
      {required String fieldName, required dynamic value}) async {
    final user = FirebaseAuth.instance.currentUser;
    final userDoc =
        FirebaseFirestore.instance.collection(usersCollection).doc(user?.uid);

    await userDoc.update(<String, dynamic>{fieldName: value});
    await HoldUser.update();
  }

  static String customToString() {
    return '{firstName: $firstName, lastName: $lastName, userAge: $userAge, userBadges: $userBadges, uid: $uid, userCreatedAccount: $userCreatedAccount, portfolio: $portfolio, notificationToken: $notificationToken, deviceUID: $deviceUID, premiumUser: $premiumUser, portfolioDonation: $portfolioDonation, totalMonthlyDonation: $totalMonthlyDonation, totalDonation: $totalDonation, email: $email, stripeCustomerID: $stripeCustomerID}';
  }
}
