import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'manager/strings_manager.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
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
