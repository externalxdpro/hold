import 'package:flutter/material.dart';

class BannedView extends StatelessWidget {
  const BannedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 30.0,
          right: 30.0,
          bottom: 20.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('placeholder icon'),
            const SizedBox(height: 20.0),
            Text(
              'banned from hold.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 40.0),
            DefaultTextStyle(
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.grey),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      'in an effort to keep Hold safe and welcoming, we have taken actions against you account.'),
                  Row(
                    children: [
                      const Text('you have violated our '),
                      GestureDetector(
                        onTap: () {
                          // TODO: Create and redirect to Terms of Service view
                        },
                        child: Text(
                          'Terms of Service',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.black),
                        ),
                      ),
                      const Text('.'),
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  const Center(child: Text('bye bye.')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
