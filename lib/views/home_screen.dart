import 'package:event_booking_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../manager/color_manager.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  static const String routeName = '/homeScreen';

  AuthenticateController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: ColorManager.primaryColor,
          actions: [
            GestureDetector(
              onTap: () => controller.logout(),
              child: const Icon(Icons.logout),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
      ),
    );
  }
}
