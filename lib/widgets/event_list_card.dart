import 'package:event_booking_app/manager/font_manager.dart';
import 'package:event_booking_app/models/user.dart';
import 'package:event_booking_app/utils/extensions.dart';
import 'package:event_booking_app/widgets/qrscanner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/events_controller.dart';
import '../manager/color_manager.dart';
import '../manager/values_manager.dart';
import '../models/event.dart';
import 'custom_text.dart';

import 'package:intl/intl.dart';

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
                  text: event.name.capitalizeFirstOfEach,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeightManager.bold,
                  fontSize: FontSize.titleFontSize * 0.7,
                  fontFamily: FontsManager.fontFamilyPoppins,
                  color: ColorManager.blackColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isEventOngoing(event)
                        ? QrCodeScanner(event: event)
                        : const Chip(
                            label: Txt(
                              text: "Completed",
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.green,
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () async {
                            final participants = await eventController
                                .getAllEventParticipants(event.id);
                            final presence =
                                await eventController.getUserPresence(event.id);
                            buildBottomParticipantSheet(
                                context, participants, presence);
                          },
                          child: const Icon(
                            Icons.groups_2_rounded,
                            color: ColorManager.blackColor,
                            size: 36,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        InkWell(
                          onTap: () async {
                            eventController.deleteEvent(event.id);
                          },
                          child: isEventOngoing(event)
                              ? const Icon(Icons.delete,
                                  color: ColorManager.redColor)
                              : Container(),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                      ],
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
