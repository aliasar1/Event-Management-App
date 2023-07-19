import 'package:event_booking_app/controllers/events_controller.dart';
import 'package:event_booking_app/models/event.dart';
import 'package:event_booking_app/utils/extensions.dart';
import 'package:event_booking_app/views/all_events_screen.dart';
import 'package:event_booking_app/views/edit_add_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

import '../controllers/auth_controller.dart';
import '../manager/color_manager.dart';
import '../manager/firebase_constants.dart';
import '../manager/font_manager.dart';
import '../manager/strings_manager.dart';
import '../manager/values_manager.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';

class EventDetailsScreem extends StatefulWidget {
  EventDetailsScreem(
      {super.key,
      required this.event,
      required this.controller,
      this.isFav = false});

  static const String routeName = '/eventDetailScreen';

  final Event event;
  final EventController controller;
  final bool isFav;

  @override
  State<EventDetailsScreem> createState() => _EventDetailsScreemState();
}

class _EventDetailsScreemState extends State<EventDetailsScreem> {
  final authController = Get.put(AuthenticateController());

  bool isRegistered = false;
  bool haveAttended = false;

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
      if (mounted && docSnap.exists) {
        setState(() {
          isRegistered = true;
        });
      }
    });
    _fetchHasAttendedStatus();
  }

  Future<void> _fetchHasAttendedStatus() async {
    if (mounted && isRegistered) {
      final status =
          await widget.controller.fetchHasAttendedStatus(widget.event.id);
      setState(() {
        haveAttended = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateStart = DateFormat("dd-MM-yyyy").parse(widget.event.startDate);
    DateTime dateEnd = DateFormat("dd-MM-yyyy").parse(widget.event.endDate);
    DateTime startTime = DateFormat('hh:mm a').parse(widget.event.startTime);
    DateTime endTime = DateFormat('hh:mm a').parse(widget.event.endTime);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.scaffoldBackgroundColor,
        body: Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: SizedBox(
                            width: double.infinity,
                            child: Image.network(
                              widget.event.posterUrl,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Hero(
                    tag: widget.event.id,
                    child: SizedBox(
                      height: Get.height * 0.35,
                      width: double.infinity,
                      child: Image.network(
                        widget.event.posterUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Get.offAll(AllEventsScreen());
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: SizeManager.sizeXL,
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: MarginManager.marginM),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Txt(
                            text: widget.controller.eventName == ""
                                ? widget.event.name.capitalizeFirstOfEach
                                : widget
                                    .controller.eventName.capitalizeFirstOfEach,
                            fontWeight: FontWeightManager.bold,
                            fontSize: FontSize.headerFontSize * 0.8,
                            fontFamily: FontsManager.fontFamilyPoppins,
                          ),
                        ),
                        Txt(
                          text: widget.event.price == "0"
                              ? "FREE"
                              : 'Rs. ${widget.event.price.toString()}',
                          fontWeight: FontWeightManager.semibold,
                          fontSize: FontSize.textFontSize,
                          color: ColorManager.blueColor,
                          fontFamily: FontsManager.fontFamilyPoppins,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Obx(
                      () => Txt(
                        text: widget.controller.eventDescription == ""
                            ? widget.event.description.capitalize
                            : widget.controller.eventDescription.capitalize,
                        fontWeight: FontWeightManager.medium,
                        fontSize: FontSize.textFontSize * 0.8,
                        fontFamily: FontsManager.fontFamilyPoppins,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: SizeManager.sizeL,
                  ),
                ],
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
            const Spacer(),
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
                : isEventOngoing(widget.event)
                    ? haveAttended
                        ? Container()
                        : Obx(
                            () => Container(
                              margin: const EdgeInsets.all(10),
                              child: CustomButton(
                                color: ColorManager.blackColor,
                                hasInfiniteWidth: true,
                                buttonType: ButtonType.loading,
                                loadingWidget:
                                    widget.controller.isLoading2.value
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              backgroundColor: ColorManager
                                                  .scaffoldBackgroundColor,
                                            ),
                                          )
                                        : null,
                                onPressed: () {
                                  isRegistered
                                      ? widget.controller
                                          .removeParticipantFromEvent(
                                              firebaseAuth.currentUser!.uid,
                                              widget.event.id)
                                      : widget.controller.addParticipantToEvent(
                                          firebaseAuth.currentUser!,
                                          widget.event.id);
                                },
                                text: isRegistered
                                    ? "Deregister"
                                    : StringsManager.registerNowTxt,
                                textColor: ColorManager.backgroundColor,
                              ),
                            ),
                          )
                    : Container(),
          ],
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: Colors.blue,
          activeBackgroundColor: Colors.blue,
          overlayOpacity: 0,
          children: [
            SpeedDialChild(
              child: const Icon(
                Icons.delete,
                color: Colors.black,
              ),
              onTap: () => {
                Get.dialog(
                  AlertDialog(
                    backgroundColor: ColorManager.scaffoldBackgroundColor,
                    title: const Text('Confirm Delete Event'),
                    content: const Text(
                      'Are you sure you want to delete the event?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black)),
                        onPressed: () async {
                          widget.controller.deleteEvent(widget.event.id);
                          Get.offAll(AllEventsScreen());
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: ColorManager.backgroundColor),
                        ),
                      ),
                    ],
                  ),
                ),
              },
            ),
            SpeedDialChild(
              child: const Icon(
                Icons.edit,
                color: Colors.black,
              ),
              onTap: () {
                Get.to(const AddEventScreen());
              },
            ),
          ],
        ),
      ),
    );
  }

  bool isEventOngoing(Event event) {
    final endDate = DateFormat("dd-MM-yyyy").parse(event.endDate);
    final endTime =
        TimeOfDay.fromDateTime(DateFormat("h:mm a").parse(event.endTime))
            .toDateTime();
    final now = DateTime.now();

    return endDate.isAfter(now) ||
        (endDate.isAtSameMomentAs(now) && endTime.isAfter(now));
  }
}
