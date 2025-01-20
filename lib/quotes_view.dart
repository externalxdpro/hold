import 'package:flutter/material.dart';
import 'package:hold/ui/small_button.dart';
import 'package:hold/utilities/fetch_quote.dart';

class QuotesView extends StatefulWidget {
  const QuotesView({super.key});

  @override
  QuotesViewState createState() => QuotesViewState();
}

class QuotesViewState extends State<QuotesView> {
  late String _quote;
  late String _author;
  late String _cite;

  Future<void> _fetchQuote() async {
    final quote = await Quote.fetch();

    _quote = quote.quote;
    _author = quote.author;
    _cite = quote.cite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: _fetchQuote(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Stack(
                children: <Widget>[
                  DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _quote,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 30.0),
                        Text('- $_author'),
                        const SizedBox(height: 15.0),
                        Text(_cite),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SmallButton(
                      text: 'Next',
                      onPressed: () async {
                        await _fetchQuote();
                        setState(() {});
                      },
                    ),
                  )
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
