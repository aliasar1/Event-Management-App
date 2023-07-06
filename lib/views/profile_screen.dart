import 'package:event_booking_app/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../manager/color_manager.dart';
import '../manager/font_manager.dart';
import '../manager/strings_manager.dart';
import '../manager/values_manager.dart';
import '../models/user.dart';
import '../utils/exports/controllers_exports.dart';
import '../utils/exports/widgets_exports.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({
    super.key,
    required this.user,
    required this.controller,
  });

  static const String routeName = '/profileScreen';

  final User user;
  final AuthenticateController controller;

  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.scaffoldBackgroundColor,
        drawer: CustomDrawer(controller: controller),
        appBar: AppBar(
          backgroundColor: ColorManager.scaffoldBackgroundColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: ColorManager.blackColor),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: MarginManager.marginL),
            alignment: Alignment.center,
            child: Column(
              children: [
                Stack(
                  children: [
                    Obx(
                      () => CircleAvatar(
                        radius: 64,
                        backgroundImage: profileController.profilePhoto != null
                            ? Image.file(profileController.profilePhoto!).image
                            : user.profilePhoto != ""
                                ? Image.network(user.profilePhoto).image
                                : const NetworkImage(
                                    'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'),
                        backgroundColor: ColorManager.backgroundColor,
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: () => profileController.pickImage(),
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: ColorManager.blackColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: SizeManager.sizeXL,
                ),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Txt(
                          textAlign: TextAlign.center,
                          text: profileController.userName == ""
                              ? user.name
                              : profileController.userName,
                          color: ColorManager.blackColor,
                          fontSize: FontSize.textFontSize,
                          fontFamily: FontsManager.fontFamilyPoppins,
                          fontWeight: FontWeightManager.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Txt(
                  text: user.email,
                  color: ColorManager.primaryColor,
                  fontSize: FontSize.subTitleFontSize,
                  fontFamily: FontsManager.fontFamilyPoppins,
                ),
                Obx(
                  () => Txt(
                    text: profileController.userPhone == ""
                        ? user.phone
                        : profileController.userPhone,
                    color: ColorManager.blackColor,
                    fontSize: FontSize.subTitleFontSize,
                    fontFamily: FontsManager.fontFamilyPoppins,
                  ),
                ),
                const SizedBox(
                  height: SizeManager.sizeXL,
                ),
                const Divider(
                  height: 2,
                  thickness: 2,
                ),
                const SizedBox(
                  height: SizeManager.sizeXL * 3,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        buildUpdatePassDialog(profileController, context);
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.lock,
                          color: ColorManager.primaryColor,
                        ),
                        title: Txt(
                          text: "Update Password",
                          color: ColorManager.blackColor,
                          fontSize: FontSize.subTitleFontSize * 1.1,
                          fontWeight: FontWeightManager.medium,
                          fontFamily: FontsManager.fontFamilyPoppins,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeS,
                    ),
                    InkWell(
                      onTap: () async {
                        profileController.nameController.text = user.name;
                        profileController.phoneController.text = user.phone;
                        await buildUpdateProfileDialog(
                            profileController, context);
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.person,
                          color: ColorManager.primaryColor,
                        ),
                        title: Txt(
                          text: "Update Personal Information",
                          color: ColorManager.blackColor,
                          fontSize: FontSize.subTitleFontSize * 1.1,
                          fontWeight: FontWeightManager.medium,
                          fontFamily: FontsManager.fontFamilyPoppins,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: Get.height * 0.28,
                  margin:
                      const EdgeInsets.only(bottom: PaddingManager.paddingXS),
                  alignment: Alignment.bottomCenter,
                  child: const Txt(
                    text: "Powered By EvenTick ©",
                    color: ColorManager.blackColor,
                    fontSize: FontSize.subTitleFontSize * 1.1,
                    fontWeight: FontWeightManager.medium,
                    fontFamily: FontsManager.fontFamilyPoppins,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> buildUpdatePassDialog(
      ProfileController controller, BuildContext context) {
    return Get.defaultDialog(
      title: StringsManager.changePasswordTxt,
      titleStyle: const TextStyle(
          color: ColorManager.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: FontSize.titleFontSize),
      titlePadding:
          const EdgeInsets.symmetric(vertical: PaddingManager.paddingM),
      radius: 5,
      content: Form(
        key: profileController.editPassFormKey,
        child: Column(
          children: [
            Obx(
              () => CustomTextFormField(
                controller: profileController.oldPasswordController,
                suffixIconData: controller.isObscure1.value
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                onSuffixTap: controller.toggleVisibility1,
                labelText: StringsManager.oldPasswordTxt,
                obscureText: controller.isObscure1.value,
                prefixIconData: Icons.lock,
                textInputAction: TextInputAction.next,
                autofocus: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ErrorManager.kPasswordNullError;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Obx(
              () => CustomTextFormField(
                controller: controller.newPasswordController,
                labelText: StringsManager.newPasswordTxt,
                suffixIconData: controller.isObscure2.value
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                onSuffixTap: controller.toggleVisibility2,
                obscureText: controller.isObscure2.value,
                prefixIconData: Icons.key,
                textInputAction: TextInputAction.next,
                autofocus: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ErrorManager.kPasswordNullError;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Obx(
              () => CustomTextFormField(
                controller: controller.newRePasswordController,
                labelText: StringsManager.newRePasswordTxt,
                suffixIconData: controller.isObscure3.value
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                onSuffixTap: controller.toggleVisibility3,
                obscureText: controller.isObscure3.value,
                prefixIconData: Icons.key,
                textInputAction: TextInputAction.done,
                autofocus: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ErrorManager.kPasswordNullError;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Obx(
              () => CustomButton(
                color: ColorManager.primaryColor,
                loadingWidget: controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          backgroundColor: ColorManager.scaffoldBackgroundColor,
                        ),
                      )
                    : null,
                onPressed: () {
                  controller.changePassword(
                      controller.oldPasswordController.text.trim(),
                      controller.newPasswordController.text.trim(),
                      controller.newRePasswordController.text.trim());
                },
                text: "Change",
                hasInfiniteWidth: true,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> buildUpdateProfileDialog(
      ProfileController controller, BuildContext context) {
    return Get.defaultDialog(
      title: "Edit Personal Details",
      titleStyle: const TextStyle(
          color: ColorManager.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: FontSize.titleFontSize),
      titlePadding:
          const EdgeInsets.symmetric(vertical: PaddingManager.paddingM),
      radius: 5,
      content: Form(
        key: controller.editInfoFormKey,
        child: Column(
          children: [
            CustomTextFormField(
              controller: controller.nameController,
              labelText: StringsManager.nameTxt,
              prefixIconData: Icons.person,
              textInputAction: TextInputAction.next,
              autofocus: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return ErrorManager.kUserNameNullError;
                }
                return null;
              },
            ),
            const SizedBox(height: SizeManager.sizeM),
            CustomTextFormField(
              controller: controller.phoneController,
              labelText: StringsManager.phoneTxt,
              maxLines: 1,
              prefixIconData: Icons.phone,
              textInputAction: TextInputAction.next,
              autofocus: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return ErrorManager.kPhoneNullError;
                }
                return null;
              },
            ),
            const SizedBox(height: SizeManager.sizeM),
            CustomButton(
              color: ColorManager.primaryColor,
              loadingWidget: controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        backgroundColor: ColorManager.scaffoldBackgroundColor,
                      ),
                    )
                  : null,
              onPressed: () {
                profileController.updateUser(
                  profileController.nameController.text.trim(),
                  profileController.phoneController.text.trim(),
                );
              },
              text: "Edit",
              hasInfiniteWidth: true,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
