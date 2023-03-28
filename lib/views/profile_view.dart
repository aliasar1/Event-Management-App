import 'dart:io';

import 'package:event_booking_app/manager/firebase_constants.dart';
import 'package:event_booking_app/manager/values_manager.dart';
import 'package:event_booking_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../manager/color_manager.dart';
import '../manager/font_manager.dart';
import '../manager/strings_manager.dart';
import '../widgets/custom_button.dart';
import '../widgets/cutom_text_form_field.dart';

class ProfileView extends StatefulWidget {
  ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileController profileController = Get.put(ProfileController());
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
        }
        return Scaffold(
          backgroundColor: ColorManager.scaffoldBackgroundColor,
          body: SingleChildScrollView(
            child: Container(
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
                          backgroundImage: controller.user['profilePhoto'] == ""
                              ? const NetworkImage(
                                  'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png')
                              : Image.network(controller.user['profilePhoto'])
                                  .image,
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
                      Expanded(
                        child: Txt(
                          textAlign: TextAlign.center,
                          text: controller.user['name'],
                          color: ColorManager.blackColor,
                          fontSize: FontSize.headerFontSize,
                          fontFamily: FontsManager.fontFamilyPoppins,
                          fontWeight: FontWeightManager.bold,
                        ),
                      ),
                    ],
                  ),
                  Txt(
                    text: controller.user['email'],
                    color: ColorManager.blackColor,
                    fontSize: FontSize.textFontSize,
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
                    height: SizeManager.sizeXL * 3,
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.all(MarginManager.marginXL * 2),
                    child: Column(
                      children: [
                        updatePassword(controller),
                        const SizedBox(
                          height: SizeManager.sizeL,
                        ),
                        updateProfile(controller),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  CustomButton updatePassword(ProfileController controller) {
    return CustomButton(
      color: ColorManager.blackColor,
      hasInfiniteWidth: false,
      onPressed: () async {
        Get.defaultDialog(
          title: "Change passowrd",
          titleStyle: const TextStyle(
              color: ColorManager.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: FontSize.titleFontSize),
          titlePadding:
              const EdgeInsets.symmetric(vertical: PaddingManager.paddingM),
          radius: 5,
          content: Form(
            key: controller.editPassFormKey,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: controller.oldPassController,
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
                const SizedBox(
                  height: 12,
                ),
                CustomTextFormField(
                  controller: controller.newPassController,
                  labelText: StringsManager.newPasswordTxt,
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
                const SizedBox(
                  height: 12,
                ),
                CustomTextFormField(
                  controller: controller.newRePassController,
                  labelText: StringsManager.newRePasswordTxt,
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
                const SizedBox(
                  height: 12,
                ),
                CustomButton(
                  color: ColorManager.blackColor,
                  loadingWidget: controller.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            backgroundColor:
                                ColorManager.scaffoldBackgroundColor,
                          ),
                        )
                      : null,
                  onPressed: () {
                    controller.changePassword(
                        controller.oldPassController.text.trim(),
                        controller.newPassController.text.trim(),
                        controller.newRePassController.text.trim());
                  },
                  text: "Change",
                  hasInfiniteWidth: true,
                  textColor: ColorManager.backgroundColor,
                ),
              ],
            ),
          ),
        );
      },
      text: StringsManager.changePasswordTxt,
      textColor: ColorManager.backgroundColor,
      buttonType: ButtonType.loading,
    );
  }

  CustomButton updateProfile(ProfileController controller) {
    return CustomButton(
      color: ColorManager.blackColor,
      hasInfiniteWidth: false,
      onPressed: () async {
        controller.nameController.text = controller.user['name'];
        controller.phoneController.text = controller.user['phone'];
        await Get.defaultDialog(
          title: "Edit User Details",
          titleStyle: const TextStyle(
              color: ColorManager.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: FontSize.titleFontSize),
          titlePadding:
              const EdgeInsets.symmetric(vertical: PaddingManager.paddingM),
          radius: 5,
          content: Form(
            key: controller.editFormKey,
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
                const SizedBox(
                  height: 12,
                ),
                CustomTextFormField(
                  controller: controller.phoneController,
                  labelText: StringsManager.phoneTxt,
                  maxLines: 1,
                  prefixIconData: Icons.phone,
                  textInputAction: TextInputAction.done,
                  autofocus: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ErrorManager.kPhoneNullError;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                CustomButton(
                  color: ColorManager.blackColor,
                  loadingWidget: controller.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            backgroundColor:
                                ColorManager.scaffoldBackgroundColor,
                          ),
                        )
                      : null,
                  onPressed: () {
                    controller.updateUser(controller.nameController.text.trim(),
                        controller.phoneController.text.trim());
                  },
                  text: "Edit",
                  hasInfiniteWidth: true,
                  textColor: ColorManager.backgroundColor,
                ),
              ],
            ),
          ),
        );
      },
      text: StringsManager.updateProfileTxt,
      textColor: ColorManager.backgroundColor,
      buttonType: ButtonType.loading,
    );
  }
}
