import 'package:event_booking_app/manager/color_manager.dart';
import 'package:event_booking_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/search_controller.dart';
import '../manager/font_manager.dart';
import '../manager/values_manager.dart';
import '../widgets/custom_search.dart';

class EventScreen extends StatelessWidget {
  EventScreen({super.key});

  final searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.scaffoldBackgroundColor,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: MarginManager.marginM),
        child: Column(
          children: [
            CustomSearchWidget(
              controller: searchController.searchController,
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (ctx, i) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: MarginManager.marginXS),
                    color: ColorManager.cardBackGroundColor,
                    width: double.infinity,
                    height: 150,
                    child: Row(
                      children: [
                        Image.network(
                          'https://img.freepik.com/free-psd/fashion-sale-poster-template_23-2148973952.jpg?w=2000',
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Txt(
                                text: '02-April-2023 at 8:00 PM',
                                useOverflow: true,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeightManager.regular,
                                fontSize: FontSize.subTitleFontSize,
                                fontFamily: FontsManager.fontFamilyPoppins,
                                color: ColorManager.blackColor,
                              ),
                              const Txt(
                                text:
                                    'Career Fair: Exclusive Tech Hiring Event-New Tickets Available',
                                textAlign: TextAlign.start,
                                fontWeight: FontWeightManager.bold,
                                fontSize: FontSize.titleFontSize * 0.7,
                                fontFamily: FontsManager.fontFamilyPoppins,
                                color: ColorManager.blackColor,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
