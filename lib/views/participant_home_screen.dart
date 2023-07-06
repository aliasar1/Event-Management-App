import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../utils/exports/manager_exports.dart';
import '../utils/exports/views_exports.dart';

class ParticipantHomeScreen extends StatefulWidget {
  const ParticipantHomeScreen({super.key});

  static const String routeName = '/participantHomeScreen';

  @override
  State<ParticipantHomeScreen> createState() => _ParticipantHomeScreenState();
}

class _ParticipantHomeScreenState extends State<ParticipantHomeScreen> {
  AuthenticateController controller = Get.put(AuthenticateController());

  var pageIndex = 2;

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationParticipantKey =
      GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorManager.scaffoldBackgroundColor,
          actions: [
            GestureDetector(
              onTap: () {
                controller.logout();
              },
              child: const Icon(
                Icons.logout,
                color: ColorManager.blackColor,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
        body: Center(child: participantPages[pageIndex]),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationParticipantKey,
          backgroundColor: ColorManager.scaffoldBackgroundColor,
          height: 55,
          index: 2,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 500),
          items: const <Widget>[
            Icon(Icons.history, size: 30, color: ColorManager.blackColor),
            Icon(Icons.search_sharp, size: 30, color: ColorManager.blackColor),
            Icon(Icons.home_rounded, size: 30, color: ColorManager.blackColor),
            Icon(Icons.favorite_border,
                size: 30, color: ColorManager.blackColor),
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
      ),
    );
  }
}

var participantPages = [
  EventsAttendedScreen(),
  const SearchScreen(),
  const EventScreen(),
  FavouriteEventScreen(),
  // ProfileScreen(),
];
