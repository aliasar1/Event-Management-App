import 'dart:async';

import 'package:event_booking_app/views/organizer_home_screen.dart';
import 'package:event_booking_app/views/participant_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';
import '../manager/color_manager.dart';
import '../manager/font_manager.dart';
import '../manager/strings_manager.dart';
import '../manager/values_manager.dart';
import '../utils/size_config.dart';
import '../widgets/custom_text.dart';
import 'login_screen.dart';
import 'offline_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = '/splashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashController = Get.put(SplashController());

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => splashController.authController.checkLoginStatus(),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SplashView();
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
