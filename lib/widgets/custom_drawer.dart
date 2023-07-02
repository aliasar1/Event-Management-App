import 'package:event_booking_app/manager/font_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../manager/color_manager.dart';
import '../manager/firebase_constants.dart';
import '../utils/exports/controllers_exports.dart';
import '../utils/exports/views_exports.dart';
import '../utils/exports/widgets_exports.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key, required this.controller});

  final AuthenticateController controller;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    profileController.updateUserId(firebaseAuth.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        if (controller.user.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: ColorManager.blackColor,
            ),
          );
        } else {
          return Drawer(
            backgroundColor: ColorManager.scaffoldBackgroundColor,
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  CircleAvatar(
                    backgroundColor: ColorManager.primaryLightColor,
                    backgroundImage: controller.user['profilePhoto'] == ""
                        ? const NetworkImage(
                            'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png')
                        : NetworkImage(
                            controller.user['profilePhoto'],
                          ),
                    radius: 70,
                  ),
                  const SizedBox(height: 10),
                  Txt(
                    text: controller.user['name'],
                    fontWeight: FontWeightManager.bold,
                    fontSize: FontSize.titleFontSize,
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  buildDrawerTile("Profile", Icons.person, () {
                    Get.offAll(const ProfileView());
                  }),
                  buildDrawerTile(
                    "All Events",
                    Icons.list_alt,
                    () {
                      Get.offAll(const EventScreen());
                    },
                  ),
                  buildDrawerTile(
                    "My Events",
                    Icons.calendar_month,
                    () {
                      Get.offAll(const EventsOrganizedScreen());
                    },
                  ),
                  buildDrawerTile(
                    "Favourites",
                    Icons.favorite,
                    () {
                      Get.offAll(FavouriteEventScreen());
                    },
                  ),
                  buildDrawerTile(
                    "History",
                    Icons.history,
                    () {},
                  ),
                  buildDrawerTile("Logout", Icons.logout, () {
                    buildLogoutDialog(context);
                  }),
                  SizedBox(height: Get.height * 0.135),
                  // const ModeSwitch(),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<dynamic> buildLogoutDialog(BuildContext context) {
    return Get.dialog(
      AlertDialog(
        backgroundColor: ColorManager.scaffoldBackgroundColor,
        title: const Text(
          'Confirm Logout',
          style: TextStyle(
            color: ColorManager.blackColor,
          ),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(
            color: ColorManager.blackColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: ColorManager.blackColor),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(ColorManager.blackColor),
            ),
            onPressed: () async {
              widget.controller.logout();
              Get.offAll(LoginScreen());
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: ColorManager.secondaryColor),
            ),
          ),
        ],
      ),
    );
  }

  ListTile buildDrawerTile(String text, IconData icon, Function onPressed) {
    return ListTile(
      title: Txt(
        text: text,
        fontSize: FontSize.subTitleFontSize,
      ),
      leading: Icon(
        icon,
        color: ColorManager.blackColor,
      ),
      onTap: () => onPressed(),
    );
  }
}
