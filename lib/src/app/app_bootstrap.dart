import 'package:boilerplate/src/app/app_service_locator.dart' as sl;
import 'package:flutter/material.dart';

/// This is where you can define your app's bootstrap function.
/// The bootstrap function is called before the app is run.
/// You can use this function to initialize services, set up dependencies, etc.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dependency Injection
  await sl.init();
}
