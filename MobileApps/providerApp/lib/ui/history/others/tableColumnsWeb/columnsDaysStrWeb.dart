import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:flutter/material.dart';

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
      child:  Text(
        Constant.daysStrength,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: AppFontStyle.headerStyle(constraints),
      ),
    ),
  );
}