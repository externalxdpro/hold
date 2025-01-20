import 'dart:convert';

import 'package:hold/constants/database.dart';
import 'package:hold/services/hold_user.dart';
import 'package:http/http.dart' as http;

class StripePaymentIntent {
  final String clientSecret;
  final String customerID;
  final String customerEphemeralKey;
  final String publishableKey;

  const StripePaymentIntent({
    required this.clientSecret,
    required this.customerID,
    required this.customerEphemeralKey,
    required this.publishableKey,
  });

  factory StripePaymentIntent.fromJson(String response) {
    Map<String, dynamic> json = jsonDecode(response);

    return StripePaymentIntent(
      clientSecret: json['paymentIntent'],
      customerID: json['customer'],
      customerEphemeralKey: json['ephemeralKey'],
      publishableKey: json['publishableKey'],
    );
  }

  static Future<StripePaymentIntent> fetch(
      {required double? stripeFee,
      required double? platformFee,
      required int? total,
      required String fundName}) async {
    if (stripeFee == null || platformFee == null || total == null) {
      throw Exception('An error occurred fetching payment intent');
    }

    try {
      Map<String, dynamic> data = {
        'Name': '${HoldUser.firstName} ${HoldUser.lastName}',
        'Email': HoldUser.email,
        'StripeCustomerID': HoldUser.stripeCustomerID,
        'Fund': fundName,
        'StripeFee': stripeFee,
        'HoldFee': platformFee,
        'Amount': total,
      };
      String body = jsonEncode(data);

      final response = await http.post(
        Uri.parse('https://gateway.donatehold.com/api/payment-sheet'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final json = jsonDecode(response.body);
      StripePaymentIntent result = StripePaymentIntent(
        clientSecret: json['paymentIntent'],
        customerID: json['customer'],
        customerEphemeralKey: json['ephemeralKey'],
        publishableKey: json['publishableKey'],
      );

      if (HoldUser.stripeCustomerID == '') {
        HoldUser.setField(
          fieldName: UserConsts.stripeCustomerIDField,
          value: result.customerID,
        );
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  String toString() {
    return '{clientSecret: $clientSecret, customerID: $customerID, customerEphemeralKey: $customerEphemeralKey, publishableKey: $publishableKey}';
  }
}
