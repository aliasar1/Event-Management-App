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
    // Timer(
    //   const Duration(seconds: 2),
    //   () => splashController.authController.checkLoginStatus(),
    // );
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

  // @override
  // Widget build(BuildContext context) {
  //   return Obx(
  //     () {
  //       if (splashController.offlineStatus.value == true) {
  //         return const OfflineScreen();
  //       } else {
  //         if (controller.isLogin.value) {
  //           if (controller.userTypeController == 'Participant') {
  //             return ParticipantHomeScreen();
  //           } else {
  //             return OrganizerHomeScreen();
  //           }
  //         } else {
  //           return LoginScreen();
  //         }
  //       }
  //     },
  //   );
  // }
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
