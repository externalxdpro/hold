import 'package:flutter/material.dart';
import 'package:hold/ui/announcement_view.dart';

class BadConnectionView extends StatelessWidget {
  const BadConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnnouncementView(
      title: 'can\'t reach servers.',
      body1:
          'check your internet connection. You may have toggled WiFi off or are switching cellular connections too quickly.',
      body2: 'don\'t give up on us.',
    );
  }
}
