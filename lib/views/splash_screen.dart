import 'dart:async';

import 'package:event_booking_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/exports/manager_exports.dart';
import '../utils/exports/widgets_exports.dart';
import '../utils/size_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = '/splashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final authController = Get.put(AuthenticateController());

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => authController.checkLoginStatus(),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const SplashView();
  }
}

class SplashView extends StatelessWidget {
  const SplashView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                color: ColorManager.blackColor,
                fontFamily: FontsManager.fontFamilyPoppins,
                fontSize: FontSize.headerFontSize * 1.2,
                fontWeight: FontWeightManager.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
