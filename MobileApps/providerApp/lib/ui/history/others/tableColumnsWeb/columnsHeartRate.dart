import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:flutter/material.dart';
import '../../../../utils/color.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/font_style.dart';
import '../../../../utils/sizer_utils.dart';
import '../../../../utils/utils.dart';

DataColumn cHeartRateWeb(HistoryController logic,BoxConstraints constraints){
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    Constant.heartRate,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: AppFontStyle.headerStyle(constraints),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: Sizes.height_0_7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            width: Sizes.width_4_5,
                            child: const Text(
                              Constant.heartRateRest,
                              textAlign: TextAlign
                                  .center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          child: Container(
                            width: Sizes.width_4_5,
                            /*margin: EdgeInsets
                                                                .only(right: Sizes
                                                                .width_3),*/
                            alignment: Alignment.center,
                            child: const Text(
                              Constant.heartRatePeak,
                              textAlign: TextAlign
                                  .center,
                              overflow: TextOverflow.ellipsis,
                            ),
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

// Widget cHeartRateWebNormal(HistoryController logic, BuildContext context){
//   return  Container(
//     height: Constant.commonHeightForTableBoxWebHeader,
//     decoration: const BoxDecoration(
//         border: Border(
//           right: BorderSide(
//               color: CColor.transparent
//           ),
//         )
//     ),
//
//     child: Row(
//       children: [
//         SizedBox(
//           width: MediaQuery.of(context).size.width * Utils.gePeaktHeartRateRowColumnWidth(context,logic),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 Constant.heartRate,
//                 textAlign: TextAlign.center,
//                 overflow: TextOverflow.ellipsis,
//                style: AppFontStyle.headerStyle(),
//               ),
//               Container(
//                 margin: EdgeInsets.only(
//                     top: Sizes.height_0_7),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Container(
//                         width: Sizes.width_4_5,
//                         child:  Text(
//                           Constant.heartRateRest,
//                           textAlign: TextAlign
//                               .center,
//                           overflow: TextOverflow.ellipsis,
//                          style: AppFontStyle.headerStyle(),
//                         ),
//                       ),
//                     ),
//                     const Spacer(),
//                     Expanded(
//                       child: Container(
//                         width: Sizes.width_4_5,
//                         alignment: Alignment.center,
//                         child: Text(
//                           Constant.heartRatePeak,
//                           textAlign: TextAlign
//                               .center,
//                           overflow: TextOverflow.ellipsis,
//                           style: AppFontStyle.styleW400(CColor.black, 3.sp),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//
//       ],
//     ),
//   );
// }


// Widget cRestHeartRateNormal(HistoryController logic, BuildContext context, String title){
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
//           width: MediaQuery.of(context).size.width * Utils.getRestHeartRateRowColumnWidth(context,logic),
//           child: Text(
//             title,
//             textAlign: TextAlign
//                 .center,
//           ),
//         ),
//
//       ],
//     ),
//   );
// }
// Widget cPeakHeartRateNormal(HistoryController logic, BuildContext context){
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
//           width: MediaQuery.of(context).size.width * Utils.gePeaktHeartRateRowColumnWidth(context,logic),
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

Widget cHeartRateWebNormal( HistoryController logic, BuildContext context,String columnType,BoxConstraints constraints){
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
      width:  ((columnType == Constant.configurationHeaderRest)?
      Utils.getRestHeartRateRowColumnWidthWeb(context,logic,constraints):Utils.getPeakHeartRateRowColumnWidthWeb(context,logic,constraints)),
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
              Text(
                Constant.trackingChartRateRestHeader,
                textAlign: TextAlign
                    .center,
                overflow: TextOverflow
                    .ellipsis,
                style: AppFontStyle.headerStyle(constraints),
              ),


            if (logic.trackingPrefList.where((element) =>
            element.titleName == Constant.configurationHeaderPeck &&
                element.isSelected).toList().isNotEmpty
                && columnType == Constant.configurationHeaderPeck)
              Text(
                Constant.trackingChartRatePeakHeader,
                textAlign: TextAlign
                    .center,
                overflow: TextOverflow
                    .ellipsis,
                style: AppFontStyle.headerStyle(constraints),
              ),

          ],
        ),
      ),
    ),
  );
}