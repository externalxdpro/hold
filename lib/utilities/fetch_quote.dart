import 'dart:convert';

import 'package:http/http.dart' as http;

class Quote {
  final String id;
  final String quote;
  final String author;
  final String cite;

  const Quote({
    required this.id,
    required this.quote,
    required this.author,
    required this.cite,
  });

  factory Quote.fromJson(String response) {
    Map<String, dynamic> json = jsonDecode(response);

    return Quote(
      id: json['id'],
      quote: json['quote'],
      author: json['author'],
      cite: json['cite'],
    );
  }

  static Future<Quote> fetch() async {
    final response = await http
        .get(Uri.parse('https://gateway.donatehold.com/api/random-quote'));

    if (response.statusCode == 200) {
      return Quote.fromJson(response.body);
    } else {
      throw Exception('Failed to fetch quote');
    }
  }
}
