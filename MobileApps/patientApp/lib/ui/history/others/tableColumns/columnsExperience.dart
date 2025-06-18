import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/color.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/sizer_utils.dart';
import '../../../../utils/utils.dart';

  DataColumn cExperience(Orientation orientation, HistoryController logic){
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
                  ? Sizes.width_30
                  : Sizes.width_60,
              child: const Column(
                children: [
                  Text(
                    Constant.experience,
                    textAlign: TextAlign
                        .center,
                    overflow: TextOverflow
                        .ellipsis,
                  ),
                  /*Container(
                                                        margin: EdgeInsets.only(
                                                            top: Sizes.height_0_7),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(left: Sizes
                                                                  .width_3),
                                                              child: const Text(
                                                                'A',
                                                                textAlign: TextAlign
                                                                    .center,
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            const Text(
                                                              'B',
                                                              textAlign: TextAlign
                                                                  .center,
                                                            ),
                                                            const Spacer(),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(right: Sizes
                                                                  .width_3),
                                                              child: const Text(
                                                                'C 6',
                                                                textAlign: TextAlign
                                                                    .center,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )*/
                ],
              ),
            ),

          ],
        ),
      ),
    ),
  );
}

  Widget cExperienceNormal(Orientation orientation, HistoryController logic, BuildContext context){
  return Container(
    height: Constant.commonHeightForTableBoxMobileHeader,
    decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
              color: CColor.transparent
          ),
        )
    ),

    child: Container(
      // color: Colors.tealAccent,
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width *
          Utils.getExperienceRowColumnWidth(context,logic),
          // 0.25,
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
                      "Allows you to log and reflect on your overall workout experience and satisfaction, available at the activity and daily level.")),
            ),
          ];
        },
        child:const Text(
          Constant.experience,
          textAlign: TextAlign
              .center,
          overflow: TextOverflow
              .ellipsis,
        ),
      ),
    ),
  );
}