import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/events_controller.dart';
import '../manager/color_manager.dart';
import '../manager/font_manager.dart';
import '../manager/strings_manager.dart';
import '../manager/values_manager.dart';
import '../models/event.dart';
import '../widgets/custom_text.dart';

class EventsOrganizedScreen extends StatelessWidget {
  EventsOrganizedScreen({super.key});

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
                      final events = snapshot.data;
                      if (events!.isEmpty) {
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
                        itemCount: events.length,
                        itemBuilder: (ctx, i) {
                          final event = events[i];
                          return Container(
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
                                      if (loadingProgress == null) return child;
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
                                        text: event.name,
                                        textAlign: TextAlign.start,
                                        fontWeight: FontWeightManager.bold,
                                        fontSize: FontSize.titleFontSize * 0.7,
                                        fontFamily:
                                            FontsManager.fontFamilyPoppins,
                                        color: ColorManager.blackColor,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: const [
                                          Icon(Icons.favorite_border,
                                              color: ColorManager.primaryColor),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Icon(Icons.calendar_month,
                                              color: ColorManager.primaryColor),
                                          SizedBox(
                                            width: 12,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
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
