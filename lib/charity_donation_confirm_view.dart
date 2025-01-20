import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hold/constants/database.dart';
import 'package:hold/services/hold_fund.dart';
import 'package:hold/services/hold_user.dart';
import 'package:hold/ui/primary_button.dart';
import 'package:hold/ui/themed_tiles.dart';
import 'package:hold/utilities/fetch_payment_intent.dart';
import 'package:hold/utilities/show_snack_bar.dart';
import 'package:intl/intl.dart';

class CharityDonationConfirmView extends StatefulWidget {
  final HoldFund fund;
  final int amount;

  const CharityDonationConfirmView({
    super.key,
    required this.fund,
    required this.amount,
  });

  @override
  State<CharityDonationConfirmView> createState() =>
      _CharityDonationConfirmViewState();
}

class _CharityDonationConfirmViewState
    extends State<CharityDonationConfirmView> {
  int _holdFee = 0;
  int _stripeFee = 0;
  int _total = 0;

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

  Future<void> _initPaymentSheet() async {
    try {
      // test info
      // StripePaymentIntent paymentIntent = const StripePaymentIntent(
      //   clientSecret:
      //       'pi_3NlmtVL9azbin5AL1j2prQ9F_secret_3MMWlgmtfve1FS0iFvamHqBIk',
      //   customerID: 'cus_OYuiIZSNVPlj9R',
      //   customerEphemeralKey:
      //       'ek_live_YWNjdF8xS3BIS3NMOWF6YmluNUFMLFB6c0NCODdKcnpuNjFsU3hYU3RBWlljem5UeG1LOU8_008EZwduUx',
      //   publishableKey:
      //       'pk_live_51KpHKsL9azbin5ALsxzIZ2lvF1lzh6WS8R6pLSdsQbz9hEenn5rc8BtnGTrMStK40UROFgRyTePH9Btr2q0Dabo200bqYCZ8Ql',
      // );

      StripePaymentIntent paymentIntent = await StripePaymentIntent.fetch(
        platformFee: _holdFee / 100,
        stripeFee: _stripeFee / 100,
        total: _total,
        fundName: widget.fund.name.toString(),
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
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, content: Text('Error: $e'));
      }
      rethrow;
    }
  }

  Future<void> _paymentSucceeded() async {
    final user = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(HoldUser.uid);
    final fields = await user.get();
    final totalDonation = fields[UserConsts.totalDonationField];
    final totalMonthlyDonation = fields[UserConsts.totalMonthlyDonationField];

    await user.update({
      UserConsts.totalDonationField: totalDonation + widget.amount,
      UserConsts.totalMonthlyDonationField:
          totalMonthlyDonation + widget.amount,
    });

    if (context.mounted) {
      showSnackBar(
        context,
        content:
            const Text('Payment Succeeded! Thanks for donating with hold :)'),
      );
    }
  }

  Future<void> _displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await _paymentSucceeded();
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

  Future<void> _setup() async {
    _holdFee = await _getHoldFee(widget.amount) ?? 0;
    _stripeFee = _getStripeFee(widget.amount, _holdFee);
    _total = widget.amount + _holdFee + _stripeFee;
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
        child: FutureBuilder(
          future: _setup(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your donation',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    'You are contributing to ${widget.fund.name}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 10.0),
                  const Row(
                    children: [
                      Text('Learn about our fees ',
                          style: TextStyle(color: Colors.green)),
                      Icon(
                        Icons.arrow_forward,
                        size: 10.0,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  InfoTile(
                    title: 'Invoice',
                    content: [
                      [
                        const Text('Donation',
                            style: TextStyle(color: Colors.green)),
                        Text(
                            NumberFormat.currency(symbol: '\$')
                                .format(widget.amount / 100),
                            style: const TextStyle(color: Colors.green)),
                      ],
                      [
                        const Text('Stripe fee'),
                        Text(
                          NumberFormat.currency(symbol: '\$')
                              .format(_stripeFee / 100),
                        ),
                      ],
                      [
                        const Text('Platform fee'),
                        Text(
                          NumberFormat.currency(symbol: '\$')
                              .format(_holdFee / 100),
                        ),
                      ],
                      [
                        const Text('Total'),
                        Text(
                          NumberFormat.currency(symbol: '\$')
                              .format(_total / 100),
                        ),
                      ],
                    ],
                  ),
                  const Spacer(),
                  FutureBuilder(
                    future: _initPaymentSheet(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return PrimaryButton(
                          text: 'Make donation',
                          onPressed: () async {
                            await _displayPaymentSheet();
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
