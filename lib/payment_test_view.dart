import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hold/constants/database.dart';
import 'package:hold/ui/themed_text_field.dart';
import 'package:hold/utilities/fetch_payment_intent.dart';
import 'package:hold/utilities/show_snack_bar.dart';

class PaymentTestView extends StatefulWidget {
  const PaymentTestView({super.key});

  @override
  State<PaymentTestView> createState() => _PaymentTestViewState();
}

class _PaymentTestViewState extends State<PaymentTestView> {
  late final TextEditingController _amount;

  @override
  void initState() {
    _amount = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<int?> _getHoldFee(int amount) async {
    final Map<String, dynamic>? doc = (await FirebaseFirestore.instance
            .collection(serverCollection)
            .doc(ServerConsts.feesConfigDoc)
            .get())
        .data();

    if (doc == null) {
      return -1;
    }

    if (amount <= 2000) {
      return doc[ServerConsts.smallFeeField] * 100;
    }
    return doc[ServerConsts.largeFeeField] * 100;
  }

  int _getStripeFee(int amount, int holdFee) {
    const double percentage = 0.022;
    const double constant = 30;
    return ((amount + holdFee) * percentage + constant).toInt();
  }

  // Future<Map<String, dynamic>> _createPaymentIntent(
  //     {required int amount}) async {
  //   debugPrint('$amount');
  //   final int? platformFee = await _getHoldFee(amount);
  //   debugPrint('$platformFee');
  //   final int stripeFee = _getStripeFee(amount, (platformFee ?? 0));
  //   debugPrint('$stripeFee');
  //   final int total = amount + (platformFee ?? 0) + stripeFee;
  //   debugPrint('$total');

  //   try {
  //     Map<String, dynamic> data = {
  //       'Name': '${HoldUser.firstName} ${HoldUser.lastName}',
  //       'Email': HoldUser.email,
  //       'StripeCustomerID': '',
  //       'Fund': 'Animal Welfare Fund',
  //       'StripeFee': stripeFee,
  //       'HoldFee': platformFee,
  //       'Amount': total,
  //     };
  //     String body = json.encode(data);
  //     debugPrint(body);

  //     final response = await http.post(
  //       Uri.parse('https://gateway.donatehold.com/api/payment-sheet'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: body,
  //     );

  //     return json.decode(response.body);
  //   } catch (e) {
  //     if (context.mounted) {
  //       showSnackBar(context, content: Text('Error: $e'));
  //     }
  //     rethrow;
  //   }
  // }

  Future<void> _displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (e) {
      switch (e.error.code) {
        case FailureCode.Canceled:
          if (context.mounted) {
            showSnackBar(context, content: const Text('Payment cancelled'));
          }
        case FailureCode.Failed:
          if (context.mounted) {
            showSnackBar(context, content: const Text('Payment failed'));
          }
        case FailureCode.Timeout:
          if (context.mounted) {
            showSnackBar(context, content: const Text('Payment timed out'));
          }
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, content: Text('Error: $e'));
      }
    }
  }

  Future<void> _makePayment() async {
    try {
      final int amount = (double.parse(_amount.text) * 100).toInt();
      final int? platformFee = await _getHoldFee(amount);
      final int stripeFee = _getStripeFee(amount, (platformFee ?? 0));
      final int total = amount + (platformFee ?? 0) + stripeFee;

      StripePaymentIntent paymentIntent = await StripePaymentIntent.fetch(
        platformFee: platformFee! / 100,
        stripeFee: stripeFee / 100,
        total: total,
        fundName: 'null',
      );

      Stripe.publishableKey = paymentIntent.publishableKey;
      await Stripe.instance.applySettings();

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'hold.',
          paymentIntentClientSecret: paymentIntent.clientSecret,
          customerId: paymentIntent.customerID,
          customerEphemeralKeySecret: paymentIntent.customerEphemeralKey,
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'CA',
            currencyCode: 'CAD',
          ),
        ),
      );

      _displayPaymentSheet();
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, content: Text('Error: $e'));
      }
      rethrow;
    }
  }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'testing.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            ThemedTextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              onChanged: (context) => setState(() {}),
            ),
            ElevatedButton(
              onPressed: () async => await _makePayment(),
              child: Text('Pay \$${_amount.text}'),
            ),
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> paymentIntent = {
                  "paymentIntent":
                      "pi_3NlfxlL9azbin5AL1HmPRrHd_secret_KoPFIG2g3DY6Yz8aHhCf2aAJr",
                  "ephemeralKey":
                      "ek_live_YWNjdF8xS3BIS3NMOWF6YmluNUFMLHYwajgyQ1ZlbUVGTEE4VUNmWHRGdXdPT1VRQXJ2WlY_00i7macA5s",
                  "customer": "cus_OYnYRJU74BPv5y",
                  "publishableKey":
                      "pk_live_51KpHKsL9azbin5ALsxzIZ2lvF1lzh6WS8R6pLSdsQbz9hEenn5rc8BtnGTrMStK40UROFgRyTePH9Btr2q0Dabo200bqYCZ8Ql"
                };

                Stripe.publishableKey = paymentIntent['publishableKey'];
                await Stripe.instance.applySettings();

                await Stripe.instance.initPaymentSheet(
                  paymentSheetParameters: SetupPaymentSheetParameters(
                    merchantDisplayName: 'hold.',
                    paymentIntentClientSecret: paymentIntent['paymentIntent'],
                    customerId: paymentIntent['customer'],
                    customerEphemeralKeySecret: paymentIntent['ephemeralKey'],
                    googlePay: const PaymentSheetGooglePay(
                      testEnv: true,
                      merchantCountryCode: 'CA',
                      currencyCode: 'CAD',
                    ),
                  ),
                );

                _displayPaymentSheet();
              },
              child: const Text('test'),
            ),
          ],
        ),
      ),
    );
  }
}
