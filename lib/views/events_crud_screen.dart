import 'package:event_booking_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/events_controller.dart';
import '../manager/color_manager.dart';
import '../manager/font_manager.dart';
import '../manager/strings_manager.dart';
import '../manager/values_manager.dart';
import '../widgets/cutom_text_form_field.dart';

class AddEventScreen extends StatelessWidget {
  AddEventScreen({super.key});

  final eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.scaffoldBackgroundColor,
      body: Center(
        child: Container(
          margin:
              const EdgeInsets.symmetric(horizontal: MarginManager.marginXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/eventadd.svg',
                height: SizeManager.svgImageSize,
                width: SizeManager.svgImageSize,
                fit: BoxFit.scaleDown,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                color: ColorManager.primaryColor,
                textColor: ColorManager.scaffoldBackgroundColor,
                text: "Add Events Now!",
                onPressed: () async {
                  Get.defaultDialog(
                    title: "Add Event",
                    titleStyle: const TextStyle(
                        color: ColorManager.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.titleFontSize),
                    titlePadding: const EdgeInsets.symmetric(
                        vertical: PaddingManager.paddingM),
                    radius: 5,
                    content: Form(
                      key: eventController.addFormKey,
                      child: Column(
                        children: [
                          Obx(
                            () => CustomTextFormField(
                              controller: eventController.nameController,
                              labelText: StringsManager.eventNameTxt,
                              prefixIconData: Icons.event,
                              textInputAction: TextInputAction.next,
                              autofocus: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ErrorManager.kEventNameNullError;
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
                              color: ColorManager.blackColor,
                              loadingWidget: eventController.isLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        backgroundColor: ColorManager
                                            .scaffoldBackgroundColor,
                                      ),
                                    )
                                  : null,
                              onPressed: () {},
                              text: "Add",
                              hasInfiniteWidth: true,
                              textColor: ColorManager.backgroundColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                hasInfiniteWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
