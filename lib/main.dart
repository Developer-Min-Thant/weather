import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:weather/utils/notification_service.dart';

import 'app/my_app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  
  await NotificationService().initialize();
  runApp(const MyApp());
}
