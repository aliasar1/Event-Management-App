import 'package:event_booking_app/manager/strings_manager.dart';
import 'package:event_booking_app/views/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../manager/color_manager.dart';
import '../manager/font_manager.dart';
import '../manager/values_manager.dart';
import '../utils/size_config.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/cutom_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  static const String routeName = '/loginScreen';
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
                key: controller.loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/images/login.svg',
                      height: SizeManager.svgImageSize,
                      width: SizeManager.svgImageSize,
                      fit: BoxFit.scaleDown,
                    ),
                    const SizedBox(
                      height: SizeManager.sizeXL,
                    ),
                    const Txt(
                      textAlign: TextAlign.start,
                      text: StringsManager.loginTxt,
                      fontWeight: FontWeightManager.bold,
                      fontSize: FontSize.headerFontSize,
                      fontFamily: FontsManager.fontFamilyPoppins,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Txt(
                        text: "Welcome Back",
                        textAlign: TextAlign.left,
                        fontFamily: FontsManager.fontFamilyPoppins,
                        color: ColorManager.primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: FontSize.titleFontSize,
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeXL,
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
                      height: SizeManager.sizeL,
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
                        onFieldSubmit: (v) => controller.loginUser(
                          controller.emailController.text.trim(),
                          controller.passwordController.text.trim(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ErrorManager.kPasswordNullError;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeM,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.bottomRight,
                        child: const Txt(
                          text: StringsManager.forgotPassTxt,
                          color: ColorManager.primaryColor,
                          fontSize: FontSize.textFontSize,
                          fontWeight: FontWeightManager.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeXL,
                    ),
                    Obx(
                      () => CustomButton(
                        color: ColorManager.blackColor,
                        hasInfiniteWidth: true,
                        buttonType: ButtonType.loading,
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
                          controller.loginUser(
                            controller.emailController.text.trim(),
                            controller.passwordController.text.trim(),
                          );
                        },
                        text: StringsManager.loginTxt,
                        textColor: ColorManager.backgroundColor,
                      ),
                    ),
                    const SizedBox(
                      height: SizeManager.sizeL,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          StringsManager.noAccTxt,
                          style: TextStyle(
                              fontSize: FontSize.textFontSize,
                              color: ColorManager.primaryColor),
                        ),
                        InkWell(
                          onTap: () => Get.offAllNamed(SignupScreen.routeName),
                          child: const Text(
                            StringsManager.registerTxt,
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
