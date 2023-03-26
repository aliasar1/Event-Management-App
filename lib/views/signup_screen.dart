import 'package:event_booking_app/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../manager/color_manager.dart';
import '../manager/font_manager.dart';
import '../manager/strings_manager.dart';
import '../manager/values_manager.dart';
import '../utils/size_config.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/cutom_text_form_field.dart';
import '../widgets/packages/group_radio_buttons/src/radio_button_field.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  static const String routeName = '/signupScreen';

  AuthenticateController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.scaffoldBackgroundColor,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(
                  vertical: MarginManager.marginXL,
                  horizontal: MarginManager.marginXL),
              child: Form(
                key: controller.signupFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/signup.svg',
                        height: SizeManager.svgImageSize,
                        width: SizeManager.svgImageSize,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeXL,
                    ),
                    const Txt(
                      textAlign: TextAlign.start,
                      text: StringsManager.registerTxt,
                      fontWeight: FontWeightManager.bold,
                      fontSize: FontSize.headerFontSize,
                      fontFamily: FontsManager.fontFamilyPoppins,
                    ),
                    const SizedBox(
                      height: SizeManager.sizeSemiM,
                    ),
                    CustomTextFormField(
                      controller: controller.nameController,
                      labelText: StringsManager.nameTxt,
                      autofocus: false,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      prefixIconData: Icons.person,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ErrorManager.kUserNameNullError;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: SizeManager.sizeSemiM,
                    ),
                    CustomTextFormField(
                      controller: controller.phoneController,
                      labelText: StringsManager.phoneTxt,
                      autofocus: false,
                      hintText: StringsManager.phoneHintTxt,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      prefixIconData: Icons.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ErrorManager.kPasswordNullError;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: SizeManager.sizeSemiM,
                    ),
                    CustomTextFormField(
                      controller: controller.emailController,
                      labelText: StringsManager.emailTxt,
                      autofocus: false,
                      hintText: StringsManager.emailHintTxt,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIconData: Icons.email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ErrorManager.kEmailNullError;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: SizeManager.sizeSemiM,
                    ),
                    Obx(
                      () => CustomTextFormField(
                        controller: controller.passwordController,
                        autofocus: false,
                        labelText: StringsManager.passwordTxt,
                        obscureText: controller.isObscure.value,
                        prefixIconData: Icons.vpn_key_rounded,
                        suffixIconData: controller.isObscure.value
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        onSuffixTap: controller.toggleVisibility,
                        textInputAction: TextInputAction.done,
                        onFieldSubmit: (v) {
                          controller.registerUser(
                            controller.emailController.text.trim(),
                            controller.passwordController.text.trim(),
                            controller.nameController.text.trim(),
                            controller.phoneController.text.trim(),
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ErrorManager.kPasswordNullError;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeXL,
                    ),
                    Obx(
                      () => CustomButton(
                        color: ColorManager.blackColor,
                        hasInfiniteWidth: true,
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
                          controller.registerUser(
                            controller.emailController.text.trim(),
                            controller.passwordController.text.trim(),
                            controller.nameController.text.trim(),
                            controller.phoneController.text.trim(),
                          );
                        },
                        text: StringsManager.registerTxt,
                        textColor: ColorManager.backgroundColor,
                        buttonType: ButtonType.loading,
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeL,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          StringsManager.alreadyHaveAccTxt,
                          style: TextStyle(
                              fontSize: FontSize.textFontSize,
                              color: ColorManager.primaryColor),
                        ),
                        InkWell(
                          onTap: () {
                            Get.offAllNamed(LoginScreen.routeName);
                          },
                          child: const Text(
                            StringsManager.loginTxt,
                            style: TextStyle(
                              fontSize: FontSize.textFontSize,
                              color: ColorManager.blackColor,
                              fontWeight: FontWeightManager.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
