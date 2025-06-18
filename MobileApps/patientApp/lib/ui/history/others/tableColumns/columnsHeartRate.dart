import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/color.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/sizer_utils.dart';
import '../../../../utils/utils.dart';

  DataColumn cHeartRate(Orientation orientation, HistoryController logic){
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
                  : Sizes.width_50,
              child: Column(
                children: [
                  const Text(
                    Constant.heartRate,
                    textAlign: TextAlign
                        .center,
                  ),
                  Container(
                    margin: EdgeInsets
                        .only(
                        top: Sizes
                            .height_0_7),
                    child: Row(
                      children: [
                        Container(
                          margin:
                          EdgeInsets
                              .only(
                              left: Sizes
                                  .width_3),
                          child: const Text(
                            Constant.heartRateRest,
                            textAlign: TextAlign
                                .center,
                            overflow: TextOverflow
                                .ellipsis,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          margin:
                          EdgeInsets
                              .only(
                              right: Sizes
                                  .width_3),
                          child: const Text(
                            Constant.heartRatePeak,
                            textAlign: TextAlign
                                .center,
                            overflow: TextOverflow
                                .ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    ),
  );
}

//   Widget cRestHeartRateNormal(HistoryController logic, BuildContext context, String title){
//   return Container(
//     alignment: Alignment.center,
//     height: Constant.commonHeightForTableBoxMobileHeader,
//     decoration: const BoxDecoration(
//         border: Border(
//           right: BorderSide(
//               color: CColor.transparent
//           ),
//         )
//     ),
//     child: SizedBox(
//       width: MediaQuery.of(context).size.width * Utils.getRestHeartRateRowColumnWidth(context,logic),
//       child: Text(
//         title,
//         textAlign: TextAlign
//             .center,
//       ),
//     ),
//   );
// }
//   Widget cPeakHeartRateNormal(Orientation orientation, HistoryController logic, BuildContext context){
//   return Container(
//     height: Constant.commonHeightForTableBoxMobileHeader,
//     decoration: const BoxDecoration(
//         border: Border(
//           right: BorderSide(
//               color: CColor.transparent
//           ),
//         )
//     ),
//     child: Row(
//       children: [
//         SizedBox(
//           // width: MediaQuery.of(context).size.width * Utils.gePeaktHeartRateRowColumnWidth(context,logic),
//           width: MediaQuery.of(context).size.width * Utils.getHeartRateRowColumnWidth(context,logic),
//           child: const Text(
//             Constant.heartRatePeak,
//             textAlign: TextAlign
//                 .center,
//           ),
//         ),
//
//       ],
//     ),
//   );
// }

Widget cHeartRateNormal(Orientation orientation, HistoryController logic, BuildContext context,String columnType){
  return Container(
    alignment: Alignment.center,
    height: Constant.commonHeightForTableBoxMobileHeader,
    decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
              color: CColor.transparent
          ),
        )
    ),
    child: SizedBox(
      width: MediaQuery.of(context).size.width * ((columnType == Constant.configurationHeaderRest)?
      Utils.getRestHeartRateRowColumnWidth(context,logic):Utils.getPeakHeartRateRowColumnWidth(context,logic)),
      child: Container(
        // color: (columnType == Constant.configurationHeaderRest)? Colors.orange: Colors.indigoAccent,
        alignment: Alignment.center,

        margin: EdgeInsets
            .only(
            top: Sizes
                .height_0_7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (logic.trackingPrefList.where((element) =>
            element.titleName == Constant.configurationHeaderRest &&
            element.isSelected).toList().isNotEmpty
                && columnType == Constant.configurationHeaderRest)
              PopupMenuButton(
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
                              "Monitors your resting heart rate, providing insights into your overall cardiovascular health. This can be tracked daily or weekly")),
                    ),
                  ];
                },
                child:Text(
                  Constant.trackingChartRateRestHeader,
                  textAlign: TextAlign
                      .center,
                  overflow: TextOverflow
                      .ellipsis,
                ),
              ),


            if (logic.trackingPrefList.where((element) =>
            element.titleName == Constant.configurationHeaderPeck &&
                element.isSelected).toList().isNotEmpty
                && columnType == Constant.configurationHeaderPeck)
              PopupMenuButton(
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
                              "Records your highest heart rate during physical activities, indicating the intensity of your workouts. You can review this data per activity, day, or week.")),
                    ),
                  ];
                },
                child:Text(
                  Constant.trackingChartRatePeakHeader,
                  textAlign: TextAlign
                      .center,
                  overflow: TextOverflow
                      .ellipsis,
                ),
              ),

          ],
        ),
      ),
    ),
  );
}