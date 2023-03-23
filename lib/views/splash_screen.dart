import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../manager/color_manager.dart';
import '../manager/strings_manager.dart';
import '../widgets/custom_text.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryLightColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
                'https://assets1.lottiefiles.com/temporary_files/n1DHEu.json'),
            const SizedBox(
              height: 12,
            ),
            Txt(
              text: StringsManager.appName,
              fontFamily: 'Nunito',
              fontSize: 34,
              letterSpacing: 2,
              fontWeight: FontWeight.w900,
              color: ColorManager.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
