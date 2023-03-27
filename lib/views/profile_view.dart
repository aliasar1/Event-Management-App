import 'package:event_booking_app/manager/values_manager.dart';
import 'package:event_booking_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../manager/color_manager.dart';
import '../manager/font_manager.dart';
import '../manager/strings_manager.dart';
import '../widgets/custom_button.dart';

class ProfileView extends StatefulWidget {
  ProfileView({super.key, required this.userId});

  final String userId;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileController profileController = Get.put(ProfileController());
  @override
  void initState() {
    super.initState();
    profileController.updateUserId(widget.userId);
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
        }
        return Scaffold(
          backgroundColor: ColorManager.scaffoldBackgroundColor,
          body: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: MarginManager.marginL),
            alignment: Alignment.center,
            child: Column(
              children: [
                Obx(
                  () => Stack(
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundImage: controller.profilePhoto == null
                            ? const NetworkImage(
                                'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png')
                            : Image.file(profileController.profilePhoto!).image,
                        backgroundColor: ColorManager.backgroundColor,
                      ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: () => controller.pickImage(),
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: ColorManager.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: SizeManager.sizeXL,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Txt(
                      text: controller.user['name'],
                      color: ColorManager.blackColor,
                      fontSize: FontSize.headerFontSize,
                      fontFamily: FontsManager.fontFamilyPoppins,
                      fontWeight: FontWeightManager.bold,
                    ),
                    const SizedBox(
                      width: SizeManager.sizeM,
                    ),
                    const Icon(
                      Icons.edit,
                      color: ColorManager.primaryColor,
                      size: SizeManager.sizeXL * 1.6,
                    ),
                  ],
                ),
                Txt(
                  text: controller.user['email'],
                  color: ColorManager.blackColor,
                  fontSize: FontSize.subTitleFontSize,
                  fontFamily: FontsManager.fontFamilyPoppins,
                ),
                const SizedBox(
                  height: SizeManager.sizeXL,
                ),
                const Divider(
                  height: 2,
                  thickness: 2,
                ),
                const SizedBox(
                  height: SizeManager.sizeXL,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.all(MarginManager.marginXL * 2),
                  child: Column(
                    children: [
                      CustomButton(
                        color: ColorManager.blackColor,
                        hasInfiniteWidth: false,
                        onPressed: () {},
                        text: StringsManager.changePasswordTxt,
                        textColor: ColorManager.backgroundColor,
                        buttonType: ButtonType.loading,
                      ),
                      const SizedBox(
                        height: SizeManager.sizeL,
                      ),
                      CustomButton(
                        color: ColorManager.blackColor,
                        hasInfiniteWidth: false,
                        onPressed: () {},
                        text: StringsManager.privacyPolicyTxt,
                        textColor: ColorManager.backgroundColor,
                        buttonType: ButtonType.loading,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
