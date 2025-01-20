import 'package:flutter/material.dart';
import 'package:hold/ui/announcement_view.dart';

class OutOfDateView extends StatelessWidget {
  const OutOfDateView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnnouncementView(
      title: 'time to update.',
      body1: 'sorry for this inconvenience, we have something new for you.',
      body2: 'update from the play store.',
    );
  }
}
