import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/exports/manager_exports.dart';
import '../utils/exports/widgets_exports.dart';
import '../utils/size_config.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  static const String routeName = '/offlineScreen';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: ColorManager.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(PaddingManager.paddingL),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(RadiusManager.fieldRadius),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(PaddingManager.paddingM),
                    child: SvgPicture.asset(
                      'assets/images/offline.svg',
                      height: SizeManager.svgImageSize,
                      width: SizeManager.svgImageSize,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: PaddingManager.paddingL),
                    child: Txt(
                      text: StringsManager.offlineTxt,
                      color: ColorManager.blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.headerFontSize,
                      fontFamily: FontsManager.fontFamilyPoppins,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: PaddingManager.paddingL),
                    child: Txt(
                      textAlign: TextAlign.center,
                      text: StringsManager.offlineMsgTxt,
                      fontSize: FontSize.subTitleFontSize,
                      fontFamily: FontsManager.fontFamilyPoppins,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: PaddingManager.paddingL,
                      left: PaddingManager.paddingM,
                      right: PaddingManager.paddingM,
                      bottom: PaddingManager.paddingM,
                    ),
                    child: CustomButton(
                      buttonType: ButtonType.textWithImage,
                      color: ColorManager.blackColor,
                      textColor: ColorManager.scaffoldBackgroundColor,
                      image: Icon(
                        Icons.wifi_rounded,
                        color: ColorManager.scaffoldBackgroundColor,
                      ),
                      text: StringsManager.openWifiTxt,
                      onPressed: AppSettings.openWIFISettings,
                      hasInfiniteWidth: true,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(PaddingManager.paddingM),
                    child: CustomButton(
                      buttonType: ButtonType.textWithImage,
                      color: ColorManager.blackColor,
                      textColor: ColorManager.scaffoldBackgroundColor,
                      image: Icon(
                        Icons.signal_cellular_alt_rounded,
                        color: ColorManager.scaffoldBackgroundColor,
                      ),
                      text: StringsManager.openDataTxt,
                      onPressed: AppSettings.openDataRoamingSettings,
                      hasInfiniteWidth: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
