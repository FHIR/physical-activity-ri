import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/color.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/font_style.dart';
import '../../../../utils/sizer_utils.dart';
import '../../../../utils/utils.dart';

DataColumn cDaysStrWeb(HistoryController logic){
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
              // width: Sizes.width_20,
              width: Sizes.width_10,
              child: const Column(
                children: [
                  Text(
                    Constant.daysStrength,
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

Widget cDaysStrWebNormal(HistoryController logic,BuildContext context,BoxConstraints constraints){
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

    child: SizedBox(
      // width: Sizes.width_20,
      width: Utils.getDaysStrengthRowColumnWidthWeb(context,logic,constraints),
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
                      "Tracks the number of days you perform strength training exercises. This can be viewed at the day or week level.")),
            ),
          ];
        },
        child: Text(
          Constant.daysStrength,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: AppFontStyle.headerStyleWeb(constraints),
        ),
      ),
    ),
  );
}