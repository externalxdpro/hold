import 'package:flutter/material.dart';

class AnnouncementView extends StatelessWidget {
  final String title;
  final String body1;
  final String body2;

  const AnnouncementView({
    super.key,
    required this.title,
    required this.body1,
    required this.body2,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30.0),
            Text(
              body1,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 40.0),
            Text(
              body2,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
