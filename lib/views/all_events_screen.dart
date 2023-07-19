import 'package:event_booking_app/utils/exports/widgets_exports.dart';
import 'package:event_booking_app/utils/extensions.dart';
import 'package:event_booking_app/views/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/events_controller.dart';
import '../manager/color_manager.dart';
import '../manager/font_manager.dart';
import '../manager/strings_manager.dart';
import '../manager/values_manager.dart';
import '../models/event.dart';
import '../models/user.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_text.dart';

class AllEventsScreen extends StatelessWidget {
  AllEventsScreen({super.key});

  static const String routeName = '/allEventsScreen';

  final eventController = Get.put(EventController());
  final controller = Get.put(AuthenticateController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.scaffoldBackgroundColor,
        drawer: CustomDrawer(
          controller: controller,
        ),
        appBar: AppBar(
          backgroundColor: ColorManager.scaffoldBackgroundColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: ColorManager.blackColor),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.filter_list_outlined,
                color: ColorManager.blackColor,
              ),
              color: ColorManager.backgroundColor,
              onSelected: (value) {
                if (value == "1") {
                  eventController.toggleRegisteredEvent(false);
                } else {
                  eventController.toggleRegisteredEvent(true);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: "1",
                    child: Text("All Events"),
                  ),
                  const PopupMenuItem(
                    value: "2",
                    child: Text("Registered Events"),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: MarginManager.marginM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Txt(
                  textAlign: TextAlign.start,
                  text: eventController.isRegisteredEvents.value
                      ? "Registered Events"
                      : "Upcoming Events",
                  fontWeight: FontWeightManager.bold,
                  fontSize: FontSize.headerFontSize,
                  fontFamily: FontsManager.fontFamilyPoppins,
                ),
              ),
              Obx(
                () => Expanded(
                  child: FutureBuilder<List<Event>>(
                    future: eventController.isRegisteredEvents.value
                        ? eventController.loadRegisteredEvents()
                        : eventController.getAllEvents(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Event>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: ColorManager.blackColor,
                          ),
                        );
                      } else {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          final events =
                              eventController.isRegisteredEvents.value
                                  ? eventController.registeredEvents
                                  : eventController.allEvents;
                          if (events.isEmpty) {
                            return Center(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: MarginManager.marginXL),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/noevent.svg',
                                      height: SizeManager.svgImageSize,
                                      width: SizeManager.svgImageSize,
                                      fit: BoxFit.scaleDown,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Txt(
                                      textAlign: TextAlign.center,
                                      text: StringsManager.noEventsTxt,
                                      fontWeight: FontWeightManager.bold,
                                      fontSize: FontSize.titleFontSize,
                                      fontFamily:
                                          FontsManager.fontFamilyPoppins,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: eventController.isRegisteredEvents.value
                                ? eventController.registeredEvents.length
                                : eventController.allEvents.length,
                            itemBuilder: (ctx, i) {
                              final event =
                                  eventController.isRegisteredEvents.value
                                      ? eventController.registeredEvents[i]
                                      : eventController.allEvents[i];
                              return InkWell(
                                  onTap: () {
                                    Get.to(
                                      EventDetailsScreem(
                                        event: event,
                                        controller: eventController,
                                        isFav: false,
                                      ),
                                    );
                                  },
                                  child: AllEventsListCard(
                                    event: event,
                                    eventController: eventController,
                                  ));
                            },
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AllEventsListCard extends StatefulWidget {
  const AllEventsListCard({
    super.key,
    required this.event,
    required this.eventController,
  });

  final Event event;
  final EventController eventController;

  @override
  State<AllEventsListCard> createState() => _AllEventsListCardState();
}

class _AllEventsListCardState extends State<AllEventsListCard> {
  late List<Event> events;

  @override
  void initState() {
    super.initState();
    events = widget.eventController.registeredEvents.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorManager.cardBackGroundColor,
      ),
      margin: const EdgeInsets.symmetric(vertical: MarginManager.marginXS),
      width: double.infinity,
      height: 150,
      child: Row(
        children: [
          Hero(
            tag: widget.event.id,
            child: SizedBox(
              width: 140,
              height: 150,
              child: Image.network(
                widget.event.posterUrl,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.blackColor,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Txt(
                  text:
                      '${widget.event.startDate} at ${widget.event.startTime}',
                  useOverflow: true,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeightManager.regular,
                  fontSize: FontSize.subTitleFontSize,
                  fontFamily: FontsManager.fontFamilyPoppins,
                  color: ColorManager.blackColor,
                ),
                Txt(
                  text: widget.event.price == "0"
                      ? "FREE"
                      : 'Rs. ${widget.event.price.toString()}',
                  textAlign: TextAlign.start,
                  fontWeight: FontWeightManager.bold,
                  fontSize: FontSize.titleFontSize * 0.7,
                  fontFamily: FontsManager.fontFamilyPoppins,
                  color: ColorManager.blueColor,
                ),
                Txt(
                  text: widget.event.name.capitalizeFirstOfEach,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeightManager.bold,
                  fontSize: FontSize.titleFontSize * 0.7,
                  fontFamily: FontsManager.fontFamilyPoppins,
                  color: ColorManager.blackColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    events.contains(widget.event)
                        ? const Chip(
                            label: Txt(
                              text: "Registered",
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.blue,
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: FavoriteIcon(
                              event: widget.event,
                              eventController: widget.eventController)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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

  Future<dynamic> buildBottomParticipantSheet(BuildContext context,
      List<User> participants, List<Map<String, dynamic>> presence) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: ColorManager.scaffoldBackgroundColor,
      builder: (BuildContext context) {
        return SizedBox(
          height: double.infinity,
          child: ListView.builder(
            itemCount: participants.length,
            itemBuilder: (BuildContext context, int index) {
              final participant = participants[index];
              return ListTile(
                title: Txt(
                  text: participant.name,
                  color: ColorManager.blackColor,
                  fontWeight: FontWeightManager.bold,
                  fontSize: FontSize.textFontSize,
                ),
                subtitle: Txt(
                  text: participant.email,
                  color: ColorManager.primaryLightColor,
                  fontSize: FontSize.subTitleFontSize,
                ),
                trailing: presence.any(
                        (p) => p['uid'] == participant.uid && p['haveAttended'])
                    ? const Icon(Icons.check, color: Colors.green)
                    : const Icon(Icons.close, color: Colors.red),
              );
            },
          ),
        );
      },
    );
  }
}
