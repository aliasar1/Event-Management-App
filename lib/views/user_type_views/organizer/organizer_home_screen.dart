import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:event_booking_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../manager/color_manager.dart';
import '../../../manager/firebase_constants.dart';
import '../../events_crud_screen.dart';
import '../../events_screen.dart';
import '../../profile_view.dart';

class OrganizerHomeScreen extends StatefulWidget {
  OrganizerHomeScreen({super.key});

  static const String routeName = '/organizerHomeScreen';

  @override
  State<OrganizerHomeScreen> createState() => _OrganizerHomeScreenState();
}

class _OrganizerHomeScreenState extends State<OrganizerHomeScreen> {
  AuthenticateController controller = Get.put(AuthenticateController());

  var pageIndex = 2;

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: ColorManager.scaffoldBackgroundColor,
          elevation: 0,
          actions: [
            GestureDetector(
              onTap: () => controller.logout(),
              child: const Icon(
                Icons.logout,
                color: ColorManager.blackColor,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          backgroundColor: ColorManager.scaffoldBackgroundColor,
          height: 55,
          index: 2,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 500),
          items: const <Widget>[
            Icon(Icons.confirmation_num,
                size: 30, color: ColorManager.blackColor),
            Icon(Icons.history, size: 30, color: ColorManager.blackColor),
            Icon(Icons.home_rounded, size: 30, color: ColorManager.blackColor),
            Icon(Icons.qr_code, size: 30, color: ColorManager.blackColor),
            Icon(Icons.account_circle,
                size: 30, color: ColorManager.blackColor),
          ],
          onTap: (index) {
            setState(() {
              pageIndex = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body: Center(child: pages[pageIndex]),
      ),
    );
  }
}

var pages = [
  Text('abc'),
  EventScreen(),
  AddEventScreen(),
  Text('abc'),
  ProfileView(),
];
