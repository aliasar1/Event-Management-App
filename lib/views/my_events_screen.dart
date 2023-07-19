import 'package:event_booking_app/controllers/auth_controller.dart';
import 'package:event_booking_app/views/edit_add_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/events_controller.dart';
import '../models/event.dart';
import '../utils/exports/manager_exports.dart';
import '../utils/exports/widgets_exports.dart';
import '../widgets/custom_drawer.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  static const String routeName = '/myEventsScreen';

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
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
        ),
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
                                      fontWeight: FontWeightManager.semibold,
                                      fontSize: FontSize.textFontSize,
                                      fontFamily:
                                          FontsManager.fontFamilyPoppins,
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
                                          return CustomBottomSheet(
                                              event: event);
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(const AddEventScreen());
          },
          backgroundColor: ColorManager.blackColor,
          child: const Icon(
            Icons.add,
            color: ColorManager.scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }
}
