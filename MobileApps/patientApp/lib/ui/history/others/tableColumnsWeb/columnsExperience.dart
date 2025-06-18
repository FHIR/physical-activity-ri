import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/color.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/font_style.dart';
import '../../../../utils/sizer_utils.dart';
import '../../../../utils/utils.dart';

  DataColumn cExperienceWeb(HistoryController logic){
  return DataColumn(
    label: Expanded(
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(
                  color: CColor.black
              ),
            )
        ),

        child: Row(
          children: [
            SizedBox(
              width: Sizes.width_10,
              child: const Column(
                children: [
                  Text(
                    Constant.experience,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    ),
  );
}

Widget cExperienceWebNormal(HistoryController logic, BuildContext context,BoxConstraints constraints){
  /*return Container(
    height: Constant.commonHeightForTableBoxWebHeader,
    decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
              color: CColor.transparent
          ),
        )
    ),

    child: Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * Utils.getExperienceRowColumnWidth(context,logic) - 0.05,
          child: Column(
            children: [
              Text(
                Constant.experience,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: AppFontStyle.headerStyle(),
              ),
            ],
          ),
        ),

      ],
    ),
  );*/
  return Container(
    alignment: Alignment.center,

    height: AppFontStyle.commonHeightForTrackingChartWeb(constraints),
    decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
              color: CColor.transparent
          ),
        )
    ),

    child: Container(
      alignment: Alignment.center,
      width:
          Utils.getExperienceRowColumnWidthWeb(context,logic,constraints),
      // 0.25,
      child:  PopupMenuButton(
        elevation: 0,
        constraints: BoxConstraints(
            minWidth: Get.width * 0.1, maxWidth: Get.width * 0.6),
        color: Colors.transparent,
        padding: const EdgeInsets.all(0),
        position: PopupMenuPosition.under,
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: CColor.white,
                      border: Border.all(width: 3),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                      "Allows you to log and reflect on your overall workout experience and satisfaction, available at the activity and daily level.")),
            ),
          ];
        },
        child: Text(
          Constant.experience,
          textAlign: TextAlign
              .center,
          overflow: TextOverflow
              .ellipsis,
          style: AppFontStyle.headerStyleWeb(constraints),
        ),
      ),
    ),
  );
}