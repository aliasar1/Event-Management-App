import 'package:event_booking_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/events_controller.dart';
import '../manager/color_manager.dart';
import '../manager/font_manager.dart';
import '../manager/strings_manager.dart';
import '../manager/values_manager.dart';
import '../models/event.dart';
import '../widgets/custom_bottom_sheet.dart';
import '../widgets/custom_text.dart';
import '../widgets/fav_icon.dart';

class EventsAttendedScreen extends StatelessWidget {
  EventsAttendedScreen({super.key});

  static const String routeName = '/eventsAttendedScreen';

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
              text: StringsManager.eventsLogTxt,
              fontWeight: FontWeightManager.bold,
              fontSize: FontSize.headerFontSize,
              fontFamily: FontsManager.fontFamilyPoppins,
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: FutureBuilder<List<Event>>(
                future: eventController.getAttendedEvents(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Event>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: ColorManager.blackColor,
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: SizeManager.svgImageSize * 1.3,
                            width: SizeManager.svgImageSize * 1.3,
                            child: SvgPicture.asset(
                              'assets/images/eventLog.svg',
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Txt(
                            textAlign: TextAlign.center,
                            text: StringsManager.noEventsAttendedTxt,
                            fontWeight: FontWeightManager.bold,
                            fontSize: FontSize.titleFontSize,
                            fontFamily: FontsManager.fontFamilyPoppins,
                          ),
                        ],
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
                          return GestureDetector(
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
                                        if (loadingProgress == null)
                                          return child;
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            FavoriteIcon(
                                              event: event,
                                              eventController: eventController,
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                String url =
                                                    await eventController
                                                        .showEventQr(event);
                                                showQr(context, url);
                                              },
                                              child: const Icon(
                                                Icons.qr_code,
                                                color:
                                                    ColorManager.primaryColor,
                                              ),
                                            ),
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

  void showQr(BuildContext ctx, String url) {
    showDialog(
      context: ctx,
      builder: (ctx) => AlertDialog(
        content: SizedBox(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(url, width: 200, height: 200),
              const SizedBox(
                height: 5,
              ),
              const Txt(
                text: "Scan this QR code at the event entrance",
                color: Colors.black,
                fontWeight: FontWeightManager.bold,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
