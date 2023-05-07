import 'package:event_booking_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/events_controller.dart';
import '../models/event.dart';
import '../utils/exports/manager_exports.dart';
import '../utils/exports/widgets_exports.dart';

class EventScreen extends StatefulWidget {
  @override
  State<EventScreen> createState() => _EventScreenState();

  static const String routeName = '/upComingEventsScreen';
}

class _EventScreenState extends State<EventScreen> {
  final eventController = Get.put(EventController());

  @override
  void dispose() {
    Get.delete<EventController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.scaffoldBackgroundColor,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: MarginManager.marginM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Txt(
              textAlign: TextAlign.start,
              text: StringsManager.ongoingEventsTxt,
              fontWeight: FontWeightManager.bold,
              fontSize: FontSize.headerFontSize,
              fontFamily: FontsManager.fontFamilyPoppins,
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: FutureBuilder<List<Event>>(
                future: eventController.getAllEvents(),
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
                      final events = snapshot.data;
                      return ListView.builder(
                        itemCount: events?.length ?? 0,
                        itemBuilder: (ctx, i) {
                          final event = events![i];
                          return InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomBottomSheet(event: event);
                                  });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: MarginManager.marginXS),
                              color: ColorManager.cardBackGroundColor,
                              width: double.infinity,
                              height: 150,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 140,
                                    height: 150,
                                    child: Image.network(
                                      event.posterUrl,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: ColorManager.blackColor,
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return const Icon(Icons
                                            .error); // Show an error icon if there's an issue with loading the image
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Txt(
                                          text:
                                              '${event.startDate} at ${event.startTime}',
                                          useOverflow: true,
                                          textAlign: TextAlign.start,
                                          fontWeight: FontWeightManager.regular,
                                          fontSize: FontSize.subTitleFontSize,
                                          fontFamily:
                                              FontsManager.fontFamilyPoppins,
                                          color: ColorManager.blackColor,
                                        ),
                                        Txt(
                                          text:
                                              event.name.capitalizeFirstOfEach,
                                          textAlign: TextAlign.start,
                                          fontWeight: FontWeightManager.bold,
                                          fontSize:
                                              FontSize.titleFontSize * 0.7,
                                          fontFamily:
                                              FontsManager.fontFamilyPoppins,
                                          color: ColorManager.blackColor,
                                        ),
                                        event.organizerId ==
                                                firebaseAuth.currentUser!.uid
                                            ? const Chip(
                                                label: Txt(
                                                  text: "Organizer",
                                                  color: Colors.white,
                                                ),
                                                backgroundColor:
                                                    ColorManager.primaryColor,
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  FavoriteIcon(
                                                    event: event,
                                                    eventController:
                                                        eventController,
                                                  ),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  const Icon(
                                                      Icons.calendar_month,
                                                      color: ColorManager
                                                          .primaryColor),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                ],
                                              )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
