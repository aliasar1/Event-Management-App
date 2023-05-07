import 'package:event_booking_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/events_controller.dart';
import '../manager/color_manager.dart';
import '../manager/font_manager.dart';
import '../manager/strings_manager.dart';
import '../manager/values_manager.dart';
import '../widgets/custom_date_time.dart';
import '../widgets/custom_text.dart';
import '../widgets/cutom_text_form_field.dart';
import '../widgets/packages/dropdown_plus/src/text_dropdown.dart';

// ignore: must_be_immutable
class AddEventScreen extends StatelessWidget {
  AddEventScreen({super.key});

  static const String routeName = '/addEventScreen';

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
                  Get.dialog(
                    AlertDialog(
                      title: const Text(
                        'Add Event',
                        style: TextStyle(
                          color: ColorManager.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize.titleFontSize,
                        ),
                      ),
                      content: buildAddEventForn(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
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

  SingleChildScrollView buildAddEventForn() {
    return SingleChildScrollView(
      child: Form(
        key: eventController.addFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Txt(
              text: 'Add Event Poster',
              textAlign: TextAlign.start,
              color: ColorManager.primaryColor,
              fontSize: FontSize.textFontSize,
            ),
            const SizedBox(
              height: 4,
            ),
            InkWell(
              onTap: () => eventController.pickImage(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: ColorManager.primaryColor, width: 2),
                    ),
                    child: eventController.posterPhoto != null
                        ? Image.network(
                            eventController.posterPhoto as String,
                            fit: BoxFit.fitWidth,
                          )
                        : Container(
                            color: Colors.grey,
                          ),
                  ),
                  const Center(
                    child: Icon(Icons.add),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            CustomTextFormField(
              controller: eventController.nameController,
              labelText: StringsManager.eventNameTxt,
              prefixIconData: Icons.celebration,
              textInputAction: TextInputAction.next,
              autofocus: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return ErrorManager.kEventNameNullError;
                }
                return null;
              },
            ),
            const SizedBox(
              height: 12,
            ),
            CustomTextFormField(
              controller: eventController.descriptionController,
              labelText: StringsManager.descriptionTxt,
              prefixIconData: Icons.description,
              maxLength: 50,
              maxLines: 1,
              textInputAction: TextInputAction.next,
              autofocus: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return ErrorManager.kDescriptionNullError;
                }
                return null;
              },
            ),
            const SizedBox(
              height: 12,
            ),
            TextDropdownFormField(
              options: category,
              dropdownHeight: 230,
              controller: eventController.categoryController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                labelStyle: const TextStyle(
                  color: ColorManager.primaryColor,
                  fontSize: FontSize.textFontSize,
                  fontWeight: FontWeight.w400,
                ),
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: FontSize.textFontSize,
                ),
                prefixIcon: const Icon(
                  Icons.place_rounded,
                  size: 20,
                  color: ColorManager.primaryColor,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    RadiusManager.fieldRadius,
                  ),
                  borderSide: const BorderSide(
                    color: ColorManager.primaryColor,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(RadiusManager.fieldRadius),
                  borderSide: const BorderSide(
                    color: ColorManager.primaryColor,
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
                  color: ColorManager.primaryColor,
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
              height: 12,
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
                  prefixIcon: const Icon(
                    Icons.event_rounded,
                    color: ColorManager.primaryColor,
                  )),
              style: const TextStyle(color: ColorManager.blackColor),
            ),
            const SizedBox(
              height: 12,
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
                  prefixIcon: const Icon(
                    Icons.event_rounded,
                    color: ColorManager.primaryColor,
                  )),
              style: const TextStyle(color: ColorManager.blackColor),
            ),
            const SizedBox(
              height: 12,
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
                  prefixIcon: const Icon(
                    Icons.timer_rounded,
                    color: ColorManager.primaryColor,
                  )),
              style: const TextStyle(color: ColorManager.blackColor),
            ),
            const SizedBox(
              height: 12,
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
                  prefixIcon: const Icon(
                    Icons.timer_rounded,
                    color: ColorManager.primaryColor,
                  )),
              style: const TextStyle(color: ColorManager.blackColor),
            ),
            const SizedBox(
              height: 12,
            ),
            CustomTextFormField(
              controller: eventController.priceController,
              labelText: StringsManager.priceTxt,
              prefixIconData: Icons.paid,
              textInputAction: TextInputAction.done,
              autofocus: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return ErrorManager.kEventNameNullError;
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Obx(
              () => CustomButton(
                color: ColorManager.blackColor,
                buttonType: ButtonType.loading,
                loadingWidget: eventController.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : null,
                onPressed: () async {
                  eventController.addEvent(
                      eventController.nameController.text.trim(),
                      eventController.startDateController.text,
                      eventController.endDateController.text,
                      eventController.startTimeController.text,
                      eventController.endTimeController.text,
                      eventController.priceController.text.trim(),
                      eventController.categoryController.value!,
                      eventController.descriptionController.text.trim());
                },
                text: "Add",
                hasInfiniteWidth: true,
                textColor: ColorManager.backgroundColor,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
