// ignore: must_be_immutable
import 'package:event_booking_app/views/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../utils/exports/manager_exports.dart';
import '../utils/exports/widgets_exports.dart';
import '../utils/size_config.dart';

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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Center(
                      child: Icon(
                        Icons.calendar_month,
                        size: SizeManager.splashIconSize,
                        color: ColorManager.blackColor,
                      ),
                    ),
                    const Txt(
                      text: StringsManager.appName,
                      color: ColorManager.blackColor,
                      fontFamily: FontsManager.fontFamilyPoppins,
                      fontSize: FontSize.headerFontSize * 1.2,
                      fontWeight: FontWeightManager.bold,
                    ),
                    const SizedBox(
                      height: SizeManager.sizeXL,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Txt(
                        textAlign: TextAlign.start,
                        text: StringsManager.loginTxt,
                        fontWeight: FontWeightManager.bold,
                        fontSize: FontSize.headerFontSize,
                        fontFamily: FontsManager.fontFamilyPoppins,
                      ),
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
                        onFieldSubmit: (_) async {
                          bool isValid = await controller.login(
                              controller.emailController.text,
                              controller.passwordController.text);
                          if (isValid) {
                            if (!firebaseAuth.currentUser!.emailVerified) {
                              await controller.removeToken();
                              verifyDialog(controller);
                            }
                          }
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
                        onPressed: () async {
                          bool isValid = await controller.login(
                              controller.emailController.text,
                              controller.passwordController.text);
                          if (isValid) {
                            if (!firebaseAuth.currentUser!.emailVerified) {
                              await controller.removeToken();
                              verifyDialog(controller);
                            }
                          }
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

  Future<dynamic> verifyDialog(AuthenticateController controller) {
    return Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Txt(
            text: "Verify your email",
            color: ColorManager.blackColor,
            fontFamily: FontsManager.fontFamilyPoppins,
            fontSize: FontSize.textFontSize,
            fontWeight: FontWeightManager.bold,
          ),
          content: const Txt(
            text: "An email is sent to you, please verify your account.",
            color: ColorManager.blackColor,
            fontFamily: FontsManager.fontFamilyPoppins,
            fontSize: FontSize.subTitleFontSize,
            fontWeight: FontWeightManager.regular,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await firebaseAuth.currentUser!.sendEmailVerification();
                  controller.logout();
                  Get.offAll(LoginScreen());
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'Failed to send email verification: $e',
                  );
                }
              },
              child: const Txt(
                text: "Resend Email",
                color: ColorManager.blackColor,
                fontFamily: FontsManager.fontFamilyPoppins,
                fontSize: FontSize.subTitleFontSize,
                fontWeight: FontWeightManager.regular,
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(ColorManager.blackColor)),
              onPressed: () {
                controller.logout();
                Get.offAll(LoginScreen());
              },
              child: const Txt(
                text: "Login",
                color: ColorManager.backgroundColor,
                fontFamily: FontsManager.fontFamilyPoppins,
                fontSize: FontSize.subTitleFontSize,
                fontWeight: FontWeightManager.regular,
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}
