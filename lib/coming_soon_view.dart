import 'package:flutter/material.dart';

class ComingSoonView extends StatelessWidget {
  const ComingSoonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/hold-starfish.png', width: 75.0),
              const SizedBox(width: 10.0),
              const Icon(Icons.add),
              const SizedBox(width: 20.0),
              const Icon(
                Icons.android,
                size: 50.0,
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          const Text('coming soon to play store.'),
        ],
      ),
    );
  }
}
