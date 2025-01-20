import 'package:uuid/uuid.dart';

String generateUUID() {
  return const Uuid().v4().toUpperCase();
}
