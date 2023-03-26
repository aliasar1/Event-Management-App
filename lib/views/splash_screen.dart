import 'dart:async';

import 'package:event_booking_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../manager/color_manager.dart';
import '../manager/font_manager.dart';
import '../manager/strings_manager.dart';
import '../manager/values_manager.dart';
import '../widgets/custom_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/splashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthenticateController controller = Get.find();

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => controller.checkLoginStatus(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.calendar_month,
                size: SizeManager.splashIconSize,
                color: ColorManager.blackColor,
              ),
              SizedBox(
                height: SizeManager.sizeS,
              ),
              Txt(
                text: StringsManager.appName,
                fontFamily: FontsManager.fontFamilyPoppins,
                fontSize: FontSize.headerFontSize,
                letterSpacing: SpacingManager.spaceS,
                fontWeight: FontWeight.w900,
                color: ColorManager.blackColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
