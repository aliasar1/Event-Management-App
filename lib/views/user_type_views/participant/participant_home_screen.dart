import 'package:event_booking_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../manager/color_manager.dart';

class ParticipantHomeScreen extends StatelessWidget {
  ParticipantHomeScreen({super.key});

  static const String routeName = '/participantHomeScreen';

  AuthenticateController controller = Get.put(AuthenticateController());

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
        body: Center(
          child: Text("parti"),
        ),
      ),
    );
  }
}
