import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/color.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/sizer_utils.dart';
import '../../../../utils/utils.dart';

  DataColumn cCalories(Orientation orientation, HistoryController logic){
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
              width: (orientation ==
                  Orientation.portrait)
                  ? Sizes.width_20
                  : Sizes.width_50,
              child: const Column(
                children: [
                  Text(
                    Constant.calories,
                    textAlign: TextAlign
                        .center,
                    overflow: TextOverflow
                        .ellipsis,
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

  Widget cCaloriesNormal(Orientation orientation, HistoryController logic,BuildContext context){
  return  Container(
    height: Constant.commonHeightForTableBoxMobileHeader,
    decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
              color: CColor.transparent
          ),
        )
    ),

    child: Container(
      // color:  Colors.limeAccent,
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * Utils.getCaloriesRowColumnWidth(context,logic),
      child: PopupMenuButton(
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
                      border: Border.all(width: 1.w),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                      "Calculates the total calories burned from all physical activities. You can see this information for each activity, day, or week.")),
            ),
          ];
        },
        child:const Text(
          Constant.calories,
          textAlign: TextAlign
              .center,
          overflow: TextOverflow
              .ellipsis,
        ),
      ),

    ),
  );
}