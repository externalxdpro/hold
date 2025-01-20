import 'package:flutter/material.dart';
import 'package:hold/ui/announcement_view.dart';

class MaintenanceView extends StatelessWidget {
  const MaintenanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnnouncementView(
      title: 'we\'re doing maintenance.',
      body1:
          'sorry for an inconvenience, hold will be back up and running as soon as possible.',
      body2: 'learn more @holdsupport on instagram.',
    );
  }
}
