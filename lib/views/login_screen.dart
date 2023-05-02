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
import '../widgets/packages/group_radio_buttons/src/radio_button_field.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  static const String routeName = '/loginScreen';
  AuthenticateController controller = Get.put(AuthenticateController());

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
                        text: StringsManager.welcomTxt,
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
                      height: SizeManager.sizeSemiM,
                    ),
                    RadioButtonFormField(
                      labels: const ['Participant', 'Organizer'],
                      icons: const [Icons.account_circle, Icons.groups],
                      onChange: (String label, int index) =>
                          controller.userTypeController = label,
                      onSelected: (String label) =>
                          controller.userTypeController = label,
                      decoration: InputDecoration(
                        labelText: 'User Type',
                        contentPadding: const EdgeInsets.all(0.0),
                        labelStyle: const TextStyle(
                          color: ColorManager.primaryColor,
                          fontSize: FontSize.textFontSize,
                          fontWeight: FontWeight.w400,
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: FontSize.textFontSize,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorManager.primaryColor,
                            width: 2,
                          ),
                          borderRadius:
                              BorderRadius.circular(RadiusManager.fieldRadius),
                        ),
                      ),
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
                          controller.userTypeController,
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
                            controller.userTypeController,
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
