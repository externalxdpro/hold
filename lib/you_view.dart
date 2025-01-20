import 'package:flutter/material.dart';
import 'package:hold/quotes_view.dart';
import 'package:hold/services/hold_user.dart';
import 'package:hold/settings_view.dart';
import 'package:hold/ui/themed_tiles.dart';

class YouView extends StatelessWidget {
  const YouView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SettingsView(),
              ));
            },
            icon: Image.asset(
              'images/starfish.png',
              width: 25.0,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 40.0,
          right: 40.0,
          bottom: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'good evening',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text('${HoldUser.firstName}, take care of yourself.'),
            const Spacer(),
            Row(
              children: [
                YouTile(
                  title: 'quotes.',
                  iconData: Icons.chat_bubble_outline,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const QuotesView(),
                    ));
                  },
                ),
                const SizedBox(width: 15.0),
                const InactiveYouTile(
                  title: 'journal.',
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            const Row(
              children: [
                InactiveYouTile(
                  title: 'talk.',
                ),
                SizedBox(width: 15.0),
                InactiveYouTile(
                  title: 'hello.',
                ),
              ],
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
