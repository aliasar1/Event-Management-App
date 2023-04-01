import 'package:event_booking_app/manager/font_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/events_controller.dart';
import '../manager/color_manager.dart';
import '../manager/values_manager.dart';
import '../models/event.dart';
import 'custom_text.dart';

class EventListCard extends StatelessWidget {
  EventListCard({
    super.key,
    required this.event,
  });

  final Event event;
  final eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorManager.cardBackGroundColor,
      ),
      margin: const EdgeInsets.symmetric(vertical: MarginManager.marginXS),
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
          const SizedBox(
            width: 12,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Txt(
                  text: '${event.startDate} at ${event.startTime}',
                  useOverflow: true,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeightManager.regular,
                  fontSize: FontSize.subTitleFontSize,
                  fontFamily: FontsManager.fontFamilyPoppins,
                  color: ColorManager.blackColor,
                ),
                Txt(
                  text: event.name,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeightManager.bold,
                  fontSize: FontSize.titleFontSize * 0.7,
                  fontFamily: FontsManager.fontFamilyPoppins,
                  color: ColorManager.blackColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.favorite_border,
                        color: ColorManager.primaryColor),
                    const SizedBox(
                      width: 12,
                    ),
                    InkWell(
                      onTap: () async {
                        eventController.deleteEvent(event.id);
                      },
                      child: const Icon(Icons.delete,
                          color: ColorManager.redColor),
                    ),
                    const SizedBox(
                      width: 12,
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
}
