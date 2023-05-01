import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_booking_app/manager/firebase_constants.dart';
import 'package:event_booking_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/events_controller.dart';
import '../manager/color_manager.dart';
import '../manager/font_manager.dart';
import '../manager/strings_manager.dart';
import '../manager/values_manager.dart';
import '../models/event.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';

class CustomBottomSheet extends StatefulWidget {
  CustomBottomSheet({super.key, required this.event});

  final Event event;

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  final eventController = Get.put(EventController());
  bool isRegistered = false;

  @override
  void initState() {
    super.initState();
    final docRef = firestore
        .collection('events')
        .doc(widget.event.id)
        .collection('participants')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    docRef.then((docSnap) {
      if (docSnap.exists) {
        setState(() {
          isRegistered = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateStart = DateFormat("dd-MM-yyyy").parse(widget.event.startDate);
    DateTime dateEnd = DateFormat("dd-MM-yyyy").parse(widget.event.endDate);
    DateTime startTime = DateFormat('hh:mm a').parse(widget.event.startTime);
    DateTime endTime = DateFormat('hh:mm a').parse(widget.event.endTime);
    return SingleChildScrollView(
      child: Container(
        height: 570,
        color: ColorManager.scaffoldBackgroundColor,
        padding: const EdgeInsets.symmetric(
            vertical: MarginManager.marginXL,
            horizontal: MarginManager.marginXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: 140,
                width: double.infinity,
                child: Image.network(
                  widget.event.posterUrl,
                  fit: BoxFit.cover,
                )),
            Txt(
              text: widget.event.name.capitalizeFirstOfEach,
              textAlign: TextAlign.left,
              fontFamily: FontsManager.fontFamilyPoppins,
              color: ColorManager.blackColor,
              fontWeight: FontWeight.w700,
              fontSize: FontSize.titleFontSize,
            ),
            Flexible(
              child: Txt(
                text: widget.event.description,
                textAlign: TextAlign.left,
                fontFamily: FontsManager.fontFamilyPoppins,
                color: ColorManager.primaryColor,
                fontSize: FontSize.subTitleFontSize,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorManager.blackColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: ColorManager.cardBackGroundColor,
                  ),
                  width: 140,
                  height: 130,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Txt(
                        text: DateFormat('EEEE').format(dateStart),
                        fontFamily: FontsManager.fontFamilyPoppins,
                        color: ColorManager.blackColor,
                        fontWeight: FontWeightManager.semibold,
                      ),
                      CircleAvatar(
                        backgroundColor: ColorManager.blackColor,
                        child: Txt(
                          text: DateFormat('d').format(dateStart),
                          color: ColorManager.scaffoldBackgroundColor,
                        ),
                      ),
                      Txt(
                          text:
                              "${DateFormat('MMMM').format(dateStart)} ${DateFormat('y').format(dateStart)}"),
                      Txt(
                          text:
                              "Starts at ${DateFormat('hh').format(startTime)}:${startTime.minute} ${DateFormat('a').format(startTime)}"),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorManager.blackColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: ColorManager.cardBackGroundColor,
                  ),
                  width: 140,
                  height: 130,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Txt(
                        text: DateFormat('EEEE').format(dateEnd),
                        fontFamily: FontsManager.fontFamilyPoppins,
                        color: ColorManager.blackColor,
                        fontWeight: FontWeightManager.semibold,
                      ),
                      CircleAvatar(
                        backgroundColor: ColorManager.blackColor,
                        child: Txt(
                          text: DateFormat('d').format(dateEnd),
                          color: ColorManager.scaffoldBackgroundColor,
                        ),
                      ),
                      Txt(
                          text:
                              "${DateFormat('MMMM').format(dateEnd)} ${DateFormat('y').format(dateEnd)}"),
                      Txt(
                          text:
                              "Ends at ${DateFormat('hh').format(endTime)}:${endTime.minute} ${DateFormat('a').format(endTime)}"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            widget.event.organizerId == firebaseAuth.currentUser!.uid
                ? const Center(
                    child: Chip(
                      label: Txt(
                        text: "You are organizer of this event.",
                        color: Colors.white,
                      ),
                      backgroundColor: ColorManager.primaryColor,
                    ),
                  )
                : Obx(
                    () => CustomButton(
                      color: ColorManager.blackColor,
                      hasInfiniteWidth: true,
                      buttonType: ButtonType.loading,
                      loadingWidget: eventController.isLoading2.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                backgroundColor:
                                    ColorManager.scaffoldBackgroundColor,
                              ),
                            )
                          : null,
                      onPressed: () {
                        isRegistered
                            ? eventController.removeParticipantFromEvent(
                                firebaseAuth.currentUser!.uid, widget.event.id)
                            : eventController.addParticipantToEvent(
                                firebaseAuth.currentUser!, widget.event.id);
                      },
                      text: isRegistered
                          ? "Deregister"
                          : StringsManager.registerNowTxt,
                      textColor: ColorManager.backgroundColor,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
