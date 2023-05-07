import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/events_controller.dart';
import '../models/event.dart';
import '../utils/exports/manager_exports.dart';
import '../utils/exports/widgets_exports.dart';

class EventsOrganizedScreen extends StatefulWidget {
  const EventsOrganizedScreen({super.key});

  static const String routeName = '/eventsOraganizedScreen';

  @override
  State<EventsOrganizedScreen> createState() => _EventsOrganizedScreenState();
}

class _EventsOrganizedScreenState extends State<EventsOrganizedScreen> {
  final eventController = Get.put(EventController());

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
              text: StringsManager.myEventsTxt,
              fontWeight: FontWeightManager.bold,
              fontSize: FontSize.headerFontSize,
              fontFamily: FontsManager.fontFamilyPoppins,
            ),
            Expanded(
              child: FutureBuilder<List<Event>>(
                future: eventController.getEventsOrganized(),
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
                      return Obx(() {
                        final events = eventController.organizedEvents;
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
                                    fontFamily: FontsManager.fontFamilyPoppins,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: eventController.organizedEvents.length,
                          itemBuilder: (ctx, i) {
                            final event = eventController.organizedEvents[i];
                            return InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomBottomSheet(event: event);
                                      });
                                },
                                child: EventListCard(event: event));
                          },
                        );
                      });
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
