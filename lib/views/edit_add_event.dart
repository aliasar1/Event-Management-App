import 'package:event_booking_app/controllers/events_controller.dart';
import 'package:event_booking_app/widgets/underline_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../manager/color_manager.dart';
import '../manager/font_manager.dart';
import '../manager/strings_manager.dart';
import '../manager/values_manager.dart';
import '../utils/exports/widgets_exports.dart';

class AddEventScreen extends StatelessWidget {
  const AddEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventController = Get.put(EventController());

    List<String> category = [
      'Music',
      'Business',
      'Food and Drink',
      'Arts',
      'Film and Media',
      'Health',
      'Science and Tech',
      'Education',
      'Others'
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: ColorManager.scaffoldBackgroundColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: ColorManager.blackColor),
          title: const Txt(
            text: "Add Event",
            color: ColorManager.blackColor,
            fontFamily: FontsManager.fontFamilyPoppins,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: MarginManager.marginL),
            child: Form(
              key: eventController.addFormKey,
              child: Column(
                children: [
                  UnderlineTextFormField(
                    label: "Event Name",
                    controller: eventController.nameController,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter event name.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: SizeManager.sizeL,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Txt(
                      text: "Add Event Poster",
                      textAlign: TextAlign.start,
                      color: ColorManager.blackColor,
                      fontFamily: FontsManager.fontFamilyPoppins,
                      fontSize: FontSize.subTitleFontSize * 1.2,
                    ),
                  ),
                  const SizedBox(
                    height: SizeManager.sizeM,
                  ),
                  Obx(
                    () {
                      return GestureDetector(
                        onTap: () => eventController.pickImage(),
                        child: eventController.posterPhoto != null
                            ? Image.file(
                                eventController.posterPhoto!,
                                fit: BoxFit.fill,
                              )
                            : Container(
                                width: double.infinity,
                                height: SizeManager.sizeXL * 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: ColorManager.blackColor,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.image,
                                  color: ColorManager.blackColor,
                                ),
                              ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: SizeManager.sizeS,
                  ),
                  UnderlineTextFormField(
                    label: StringsManager.descriptionTxt,
                    controller: eventController.descriptionController,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 300,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ErrorManager.kDescriptionNullError;
                      }
                      return null;
                    },
                  ),
                  UnderlineTextFormField(
                    label: "Event Fees",
                    controller: eventController.priceController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter event fees.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: SizeManager.sizeL,
                  ),
                  TextDropdownFormField(
                    options: category,
                    dropdownHeight: 230,
                    controller: eventController.categoryController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      labelStyle: const TextStyle(
                        color: ColorManager.blackColor,
                        fontSize: FontSize.textFontSize,
                        fontWeight: FontWeight.w400,
                      ),
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: FontSize.textFontSize,
                      ),
                      prefixIcon: const Icon(
                        Icons.category,
                        size: 20,
                        color: ColorManager.blackColor,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          RadiusManager.fieldRadius,
                        ),
                        borderSide: const BorderSide(
                          color: ColorManager.blackColor,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(RadiusManager.fieldRadius),
                        borderSide: const BorderSide(
                          color: ColorManager.blackColor,
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(RadiusManager.fieldRadius),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(RadiusManager.fieldRadius),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      suffixIcon: const Icon(
                        Icons.arrow_drop_down,
                        color: ColorManager.blackColor,
                      ),
                      labelText: "Event Category",
                      alignLabelWithHint: true,
                      errorStyle: const TextStyle(
                        fontFamily: FontsManager.fontFamilyPoppins,
                        color: Colors.red,
                        fontSize: FontSize.textFontSize,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: SizeManager.sizeL,
                  ),
                  DateTimeField(
                    format: DateFormat("dd-MM-yyyy"),
                    onShowPicker: ((context, currentValue) async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: currentValue ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(DateTime.now().year + 1),
                      );

                      return date;
                    }),
                    controller: eventController.startDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: 'Event Start Date',
                        hintText: 'Select Event Start Date',
                        contentPadding: const EdgeInsets.all(0.0),
                        labelStyle: const TextStyle(
                          color: ColorManager.blackColor,
                          fontSize: FontSize.textFontSize,
                          fontWeight: FontWeight.w400,
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: FontSize.textFontSize,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorManager.blackColor,
                            width: 2,
                          ),
                          borderRadius:
                              BorderRadius.circular(RadiusManager.fieldRadius),
                        ),
                        prefixIcon: const Icon(
                          Icons.event_rounded,
                          color: ColorManager.blackColor,
                        )),
                    style: const TextStyle(color: ColorManager.blackColor),
                  ),
                  const SizedBox(
                    height: SizeManager.sizeM,
                  ),
                  DateTimeField(
                    format: DateFormat("h:mm a"),
                    onShowPicker: ((context, currentValue) async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now(),
                        ),
                      );
                      return DateTimeField.convert(time);
                    }),
                    controller: eventController.startTimeController,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: 'Event Start Time',
                        hintText: 'Select Start Time',
                        contentPadding: const EdgeInsets.all(0.0),
                        labelStyle: const TextStyle(
                          color: ColorManager.blackColor,
                          fontSize: FontSize.textFontSize,
                          fontWeight: FontWeight.w400,
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: FontSize.textFontSize,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorManager.blackColor,
                            width: 2,
                          ),
                          borderRadius:
                              BorderRadius.circular(RadiusManager.fieldRadius),
                        ),
                        prefixIcon: const Icon(
                          Icons.timer_rounded,
                          color: ColorManager.blackColor,
                        )),
                    style: const TextStyle(color: ColorManager.blackColor),
                  ),
                  const SizedBox(
                    height: SizeManager.sizeM,
                  ),
                  DateTimeField(
                    format: DateFormat("dd-MM-yyyy"),
                    onShowPicker: ((context, currentValue) async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: currentValue ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(DateTime.now().year + 1),
                      );

                      return date;
                    }),
                    controller: eventController.endDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: 'Event End Date',
                        hintText: 'Select Event End Date',
                        contentPadding: const EdgeInsets.all(0.0),
                        labelStyle: const TextStyle(
                          color: ColorManager.blackColor,
                          fontSize: FontSize.textFontSize,
                          fontWeight: FontWeight.w400,
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: FontSize.textFontSize,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorManager.blackColor,
                            width: 2,
                          ),
                          borderRadius:
                              BorderRadius.circular(RadiusManager.fieldRadius),
                        ),
                        prefixIcon: const Icon(
                          Icons.event_rounded,
                          color: ColorManager.blackColor,
                        )),
                    style: const TextStyle(color: ColorManager.blackColor),
                  ),
                  const SizedBox(
                    height: SizeManager.sizeM,
                  ),
                  DateTimeField(
                    format: DateFormat("h:mm a"),
                    onShowPicker: ((context, currentValue) async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now(),
                        ),
                      );
                      return DateTimeField.convert(time);
                    }),
                    controller: eventController.endTimeController,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: 'Event End Time',
                        hintText: 'Select End Time',
                        contentPadding: const EdgeInsets.all(0.0),
                        labelStyle: const TextStyle(
                          color: ColorManager.blackColor,
                          fontSize: FontSize.textFontSize,
                          fontWeight: FontWeight.w400,
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: FontSize.textFontSize,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorManager.blackColor,
                            width: 2,
                          ),
                          borderRadius:
                              BorderRadius.circular(RadiusManager.fieldRadius),
                        ),
                        prefixIcon: const Icon(
                          Icons.timer_rounded,
                          color: ColorManager.blackColor,
                        )),
                    style: const TextStyle(color: ColorManager.blackColor),
                  ),
                  const SizedBox(
                    height: SizeManager.sizeM,
                  ),
                  Obx(
                    () => CustomButton(
                      color: ColorManager.blackColor,
                      hasInfiniteWidth: true,
                      loadingWidget: eventController.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: ColorManager.scaffoldBackgroundColor,
                                backgroundColor:
                                    ColorManager.scaffoldBackgroundColor,
                              ),
                            )
                          : null,
                      onPressed: () async {
                        await eventController.addEvent(
                            eventController.nameController.text.trim(),
                            eventController.startDateController.text,
                            eventController.endDateController.text,
                            eventController.startTimeController.text,
                            eventController.endTimeController.text,
                            eventController.priceController.text.trim(),
                            eventController.categoryController.value!,
                            eventController.descriptionController.text.trim());
                      },
                      text: "Add Event",
                      textColor: ColorManager.backgroundColor,
                      buttonType: ButtonType.loading,
                    ),
                  ),
                  const SizedBox(
                    height: SizeManager.sizeL,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
