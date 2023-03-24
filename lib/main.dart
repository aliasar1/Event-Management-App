import 'package:event_booking_app/views/signup_screen.dart';
import 'package:event_booking_app/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'manager/strings_manager.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'views/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      key: UniqueKey(),
      debugShowCheckedModeBanner: false,
      title: StringsManager.appName,
      smartManagement: SmartManagement.full,
      defaultTransition: Transition.fade,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
