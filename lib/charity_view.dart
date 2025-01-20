import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hold/charity_donation_confirm_view.dart';
import 'package:hold/services/hold_fund.dart';
import 'package:hold/ui/primary_button.dart';
import 'package:hold/ui/themed_text_field.dart';
import 'package:hold/ui/themed_tiles.dart';
import 'package:intl/intl.dart';

class CharityView extends StatelessWidget {
  const CharityView({super.key});

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
          future: HoldFunds.update(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: <Widget>[
                  Container(
                    color: Theme.of(context).colorScheme.background,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'charity.',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CharityLearnMoreView(),
                              ),
                            );
                          },
                          child: const Row(
                            children: <Widget>[
                              // Text(
                              //   'Learn more ',
                              //   style: Theme.of(context).textTheme.bodySmall,
                              // ),
                              // const Icon(
                              //   Icons.arrow_forward,
                              //   size: 10.0,
                              //   color: Colors.grey,
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        const SizedBox(height: 50.0),
                        ...HoldFunds.funds.map((fund) {
                          Map<String, List<dynamic>> icons = {
                            'Animal Welfare Fund': [
                              Icons.cruelty_free,
                              Colors.brown,
                            ],
                            'Environment Fund': [
                              Icons.electrical_services,
                              Colors.green,
                            ],
                            'Learning Fund': [
                              Icons.book,
                              Colors.lightBlue,
                            ],
                            'Mental Wellbeing Fund': [
                              Icons.favorite,
                              Colors.grey,
                            ],
                            'Wildfire Relief Fund': [
                              Icons.fire_hydrant_alt,
                              Colors.redAccent,
                            ],
                            '🇵🇸 Gaza Relief': [
                              Icons.bolt,
                              Colors.red,
                            ],
                          };
                          return Column(
                            children: [
                              CharityTile(
                                leading: Icon(icons[fund.name]?[0]),
                                iconColor: icons[fund.name]?[1],
                                title: fund.name ?? 'An Error occurred',
                                titleBold: true,
                                subtitle:
                                    '${fund.cause}  ${fund.charities?.length} ${(fund.charities?.length) == 1 ? 'charity' : 'charities'}',
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          CharityFundView(fund: fund)));
                                },
                              ),
                              const SizedBox(height: 20.0),
                            ],
                          );
                        }),
                      ],
                    ),
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

class CharityLearnMoreView extends StatelessWidget {
  const CharityLearnMoreView({super.key});

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
              'how hold chooses its charities.',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            Text(
              'hold believes in maximizing the impact of charitable giving. to achieve this, we employ a rigorous research process that evaluates charities based on four key areas:',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey, fontSize: 16.0),
            ),
            const SizedBox(height: 25.0),
            CharityTile(
              verticalPadding: true,
              title: 'impact.',
              titleBold: true,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CharityLearnMoreInfoView(
                    title: 'How do charities make an impact',
                    description:
                        'We prioritize charities that are making a significant impact in their respective fields. This involves assessing their track record of success, the scope or their programs, and the scale of the problems they aim to address.',
                  ),
                ));
              },
            ),
            const SizedBox(height: 25.0),
            CharityTile(
              verticalPadding: true,
              title: 'accountability.',
              titleBold: true,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CharityLearnMoreInfoView(
                    title: 'Placeholder title',
                    description: 'Placeholder description',
                  ),
                ));
              },
            ),
            const SizedBox(height: 25.0),
            CharityTile(
              verticalPadding: true,
              title: 'innovation.',
              titleBold: true,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CharityLearnMoreInfoView(
                    title: 'Placeholder title',
                    description: 'Placeholder description',
                  ),
                ));
              },
            ),
            const SizedBox(height: 25.0),
            CharityTile(
              verticalPadding: true,
              title: 'collaboration.',
              titleBold: true,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CharityLearnMoreInfoView(
                    title: 'Placeholder title',
                    description: 'Placeholder description',
                  ),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CharityLearnMoreInfoView extends StatelessWidget {
  final String title;
  final String description;

  const CharityLearnMoreInfoView({
    super.key,
    required this.title,
    required this.description,
  });

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
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15.0),
            Text(
              description,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 15.0),
            ),
          ],
        ),
      ),
    );
  }
}

class CharityFundView extends StatelessWidget {
  final HoldFund fund;

  const CharityFundView({super.key, required this.fund});

  @override
  Widget build(BuildContext context) {
    final TextStyle defaultTextStyle =
        Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 15.0,
              color: Colors.grey,
            );

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 30.0,
          right: 30.0,
          bottom: 20.0,
        ),
        child: DefaultTextStyle(
          style: defaultTextStyle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Theme.of(context).colorScheme.background,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fund.name ?? 'An error occurred',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${fund.cause}  ${fund.charities?.length} ${(fund.charities?.length) == 1 ? 'charity' : 'charities'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 40.0),
                    Text(fund.description.toString()),
                    const SizedBox(height: 40.0),
                    Text(
                      'Charities',
                      style: defaultTextStyle.copyWith(
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ...fund.charities!.map((charity) {
                      return Column(
                        children: [
                          CharityTile(
                            title: charity.name ?? 'An error occurred',
                            subtitle: charity.location,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      CharityCharityView(charity: charity)));
                            },
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              Container(
                color: Theme.of(context).colorScheme.background,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 10.0),
                    PrimaryButton(
                        text: 'Donate to this fund',
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                CharityDonationTypeChoiceView(fund: fund),
                          ));
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CharityCharityView extends StatelessWidget {
  final HoldCharity charity;
  const CharityCharityView({super.key, required this.charity});

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
          children: [
            Text(
              charity.name ?? 'An error occurred',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              charity.fund.toString(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 40.0),
            InfoTile(
              title: 'Charity info',
              content: [
                [
                  const Text('Revenue'),
                  Text(NumberFormat.currency(
                          symbol: '\$', locale: 'en_US', decimalDigits: 0)
                      .format(charity.revenue ?? 0)),
                ],
                [
                  const Text('Employees'),
                  Text(NumberFormat.compactLong()
                      .format(charity.employees ?? 0)),
                ],
                [
                  const Text('Category'),
                  Text(charity.cause.toString()),
                ],
              ],
            ),
            const SizedBox(height: 40.0),
            InfoTile(
              title: 'Quick view',
              seperatorHeight: 10.0,
              content: [
                [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CharityCharityInfoView(
                          title: 'Activity',
                          description: charity.description.toString(),
                        ),
                      ));
                    },
                    child: const SizedBox(
                      width: 100.0,
                      child: Text('Activity'),
                    ),
                  ),
                  const Icon(Icons.navigate_next, color: Colors.grey),
                ],
                [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CharityCharityInfoView(
                          title: 'Tax',
                          description:
                              '${charity.name} is registered with the Canada Revenue Agency. Its charitable tax identifier is as follows: ${charity.tax}',
                        ),
                      ));
                    },
                    child: const SizedBox(
                      width: 100.0,
                      child: Text('Tax'),
                    ),
                  ),
                  const Icon(Icons.navigate_next, color: Colors.grey),
                ],
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CharityCharityInfoView extends StatelessWidget {
  final String title;
  final String description;

  const CharityCharityInfoView({
    super.key,
    required this.title,
    required this.description,
  });

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
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class CharityDonationTypeChoiceView extends StatefulWidget {
  final HoldFund fund;

  const CharityDonationTypeChoiceView({super.key, required this.fund});

  @override
  State<CharityDonationTypeChoiceView> createState() =>
      _CharityDonationTypeChoiceViewState();
}

class _CharityDonationTypeChoiceViewState
    extends State<CharityDonationTypeChoiceView> {
  bool oneTimeOn = true;

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
          children: [
            Text(
              'How would you like to donate?',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25.0),
            CharityTile(
              title: 'One-time',
              trailing: oneTimeOn
                  ? const Icon(Icons.radio_button_on)
                  : const Icon(Icons.radio_button_off),
              onTap: () {
                if (!oneTimeOn) {
                  setState(() {
                    oneTimeOn = true;
                  });
                }
              },
            ),
            const SizedBox(height: 30.0),
            InactiveCharityTile(
              title: 'Portfolio',
              trailing: !oneTimeOn
                  ? const Icon(Icons.radio_button_on)
                  : const Icon(Icons.radio_button_off),
            ),
            const Spacer(),
            PrimaryButton(
              text: 'next',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      CharityDonationAmountView(fund: widget.fund),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CharityDonationAmountView extends StatefulWidget {
  final HoldFund fund;

  const CharityDonationAmountView({super.key, required this.fund});

  @override
  State<CharityDonationAmountView> createState() =>
      _CharityDonationAmountViewState();
}

class _CharityDonationAmountViewState extends State<CharityDonationAmountView> {
  late final TextEditingController _amount;

  @override
  void initState() {
    _amount = TextEditingController();
    _amount.text = '10';
    super.initState();
  }

  @override
  void dispose() {
    _amount.dispose;
    super.dispose();
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
          children: [
            Text(
              'How much would you like to give?',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15.0),
            const Text(
              'The average donation is \$10. We suggest you start there.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40.0),
            Center(
              child: Container(
                margin: const EdgeInsets.only(left: 60.0, right: 60.0),
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                width: double.infinity,
                child: Center(
                  child: Text(
                    (_amount.text == '')
                        ? '\$0.00'
                        : NumberFormat.currency(symbol: '\$')
                            .format(double.parse(_amount.text)),
                    style: const TextStyle(fontSize: 30.0),
                  ),
                ),
              ),
            ),
            const Spacer(),
            ThemedTextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                // FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
              ],
              onChanged: (newVal) {
                if (_amount.text == '') {
                  _amount.text = '0';
                } else if (_amount.text.length == 2 && _amount.text[0] == '0') {
                  _amount.text = _amount.text.substring(1);
                } else if (double.parse(_amount.text) > 10000) {
                  _amount.text = '10000';
                }
                setState(() {});
              },
            ),
            const Spacer(),
            PrimaryButton(
              text: 'Proceed to payment',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CharityDonationConfirmView(
                    fund: widget.fund,
                    amount: int.parse(_amount.text) * 100,
                  ),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
