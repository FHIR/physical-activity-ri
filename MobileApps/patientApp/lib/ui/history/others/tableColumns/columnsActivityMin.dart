import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/color.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/sizer_utils.dart';

// DataColumn cActivityMin(Orientation orientation, HistoryController logic){
//   return DataColumn(
//     label: Expanded(
//       child: Container(
//         decoration:  const BoxDecoration(
//             border: Border(
//               right: BorderSide(
//                   color: CColor.black
//               ),
//             )
//         ),
//         child: Row(
//           children: [
//             SizedBox(
//               width: (orientation ==
//                   Orientation.portrait)
//                   ? (!Constant.boolActivityMinMod &&
//                   !Constant.boolActivityMinVig)
//                   ? Sizes.width_40
//                   : Sizes.width_50
//                   : Sizes.width_80,
//               child: Column(
//                 children: [
//                    const Text(
//                     Constant.activityMinutes,
//                     textAlign: TextAlign
//                         .center,
//                   ),
//                   Container(
//                     margin: EdgeInsets
//                         .only(
//                         top: Sizes
//                             .height_0_7),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         (Constant.boolActivityMinMod)?Container(
//                           margin: EdgeInsets
//                               .only(
//                               left:
//                               Sizes
//                                   .width_3),
//                           child:  const Text(
//                             Constant.activityMinutesMod,
//                             textAlign:
//                             TextAlign
//                                 .center,
//                             overflow: TextOverflow
//                                 .ellipsis,
//                           ),
//                         ):Container(),
//                         (Constant.boolActivityMinMod)?  const Spacer():Container(),
//                         (Constant.boolActivityMinVig)?  const Text(
//                           Constant.activityMinutesVig,
//                           textAlign:
//                           TextAlign
//                               .center,
//                           overflow: TextOverflow
//                               .ellipsis,
//                         ):Container(),
//                         (Constant.boolActivityMinVig)?  const Spacer():Container(),
//                         Container(
//                           margin: EdgeInsets
//                               .only(
//                               right:
//                               Sizes
//                                   .width_3),
//                           child:  const Text(
//                             Constant.activityMinutesTotal,
//                             textAlign:
//                             TextAlign
//                                 .center,
//                             overflow: TextOverflow
//                                 .ellipsis,
//                           ),
//                         ),
//                         SizedBox(
//                           height: Sizes.width_5,
//                           width: Sizes.width_5,
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     ),
//   );
// }

//  Widget cActivityModNormal(HistoryController logic,BuildContext context){
//   return Container(
//     alignment: Alignment.center,
//     height: Constant.commonHeightForTableBoxMobileHeader,
//     decoration:  const BoxDecoration(
//         border: Border(
//           right: BorderSide(
//               color: CColor.transparent
//           ),
//         )
//     ),
//     child: SizedBox(
//       width:MediaQuery.of(context).size.width *
//           // Utils.getModRowColumnWidth(context,true,false,logic),
//           Utils.getModRowColumnWidth(context,logic),
//           // 0.25,
//       child: const Text(
//         Constant.activityMinutesMod,
//         textAlign: TextAlign
//             .center,
//       ),
//     ),
//   );
// }
//  Widget cActivityVigNormal(HistoryController logic,BuildContext context){
//   return Container(
//     alignment: Alignment.center,
//     height: Constant.commonHeightForTableBoxMobileHeader,
//     decoration:  const BoxDecoration(
//         border: Border(
//           right: BorderSide(
//               color: CColor.transparent
//           ),
//         )
//     ),
//     child: SizedBox(
//       width:MediaQuery.of(context).size.width *
//           Utils.getActivityMinRowColumnWidth(context,Constant.boolActivityMinMod,Constant.boolActivityMinVig,logic),
//       child: const Text(
//         Constant.activityMinutesVig,
//         textAlign: TextAlign
//             .center,
//       ),
//     ),
//   );
// }
//  Widget cActivityTotalNormal(HistoryController logic,BuildContext context){
//   return Container(
//     alignment: Alignment.center,
//     height: Constant.commonHeightForTableBoxMobileHeader,
//     decoration:  const BoxDecoration(
//         border: Border(
//           right: BorderSide(
//               color: CColor.transparent
//           ),
//         )
//     ),
//     child: SizedBox(
//       width:MediaQuery.of(context).size.width *
//           // Utils.getTotalRowColumnWidth(context,true,false,logic),
//           Utils.getTotalRowColumnWidth(context,logic),
//     // 0.25,
//       child: const Text(
//         Constant.activityMinutesTotal,
//         textAlign: TextAlign
//             .center,
//       ),
//     ),
//   );
// }
//  Widget cActivityNotesNormal(HistoryController logic,BuildContext context){
//   return Container(
//     alignment: Alignment.center,
//     height: Constant.commonHeightForTableBoxMobileHeader,
//     decoration:  const BoxDecoration(
//         border: Border(
//           right: BorderSide(
//               color: CColor.transparent
//           ),
//         )
//     ),
//     child: Container(
//       alignment: Alignment.center,
//       width:MediaQuery.of(context).size.width * Utils.getNotesRowColumnWidth(context,logic),
//       child: const Text(
//         Constant.noteType,
//         textAlign: TextAlign
//             .center,
//       ),
//     ),
//   );
// }

Widget cActivityMinNormal(Orientation orientation, HistoryController logic,BuildContext context,
    String columnType){
  return Container(
    alignment:(kIsWeb)? Alignment.topCenter :Alignment.center,
    height: Constant.commonHeightForTableBoxMobileHeader,
    decoration:  const BoxDecoration(
        border: Border(
          right: BorderSide(
              color: CColor.transparent
          ),
        )
    ),
    child: Container(
      // color: (columnType == Constant.configurationHeaderModerate)?Colors.red:
      // (columnType == Constant.configurationHeaderVigorous)?Colors.amber:
      // (columnType == Constant.configurationHeaderTotal)?Colors.blue:Colors.green
      // ,
      alignment:(kIsWeb)? Alignment.topCenter :Alignment.center,
      width:MediaQuery.of(context).size.width *
          ((columnType == Constant.configurationHeaderModerate)?Utils.getModRowColumnWidth(context,logic):
          (columnType == Constant.configurationHeaderVigorous)?Utils.getVigRowColumnWidth(context,logic):
          (columnType == Constant.configurationHeaderTotal)?Utils.getTotalRowColumnWidth(context,logic):
          Utils.getNotesRowColumnWidth(context,logic)),
      child: Container(
        alignment:(kIsWeb)? Alignment.topCenter :Alignment.center,
        margin: EdgeInsets
            .only(
            top: Sizes
                .height_0_7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderModerate &&
            element.isSelected).toList().isNotEmpty && columnType == Constant.configurationHeaderModerate)
                ?Container(
              // color: Colors.red,
               alignment:(kIsWeb)? Alignment.topCenter :Alignment.center,
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
                              border: Border.all(width: 1.w),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                              "Measures the time spent engaging in moderate-intensity activities like brisk walking. You can track this for each activity, day, or week.")),
                    ),
                  ];
                },
                child:const Text(
                  // Constant.activityMinutesMod,
                  Constant.trackingChartModHeader,
                  textAlign:
                  TextAlign
                      .center,
                  overflow: TextOverflow
                      .ellipsis,
                ),
              ),
            ):Container(),

            (logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderVigorous &&
                element.isSelected).toList().isNotEmpty && columnType == Constant.configurationHeaderVigorous)
                ?  Container(
              alignment:(kIsWeb)? Alignment.topCenter :Alignment.center,
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
                                    "Measures the time spent engaging in vigorous-intensity activities, tracked per activity, day, or week.")),
                          ),
                        ];
                      },
                      child:Container(
                        alignment: Alignment.center,
                        child: const Text(
                          Constant.trackingChartVigHeader,
                          textAlign:
                          TextAlign
                              .center,
                          overflow: TextOverflow
                              .ellipsis,
                        ),
                      )
                  )
                ):Container(),

            (logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderTotal &&
                element.isSelected).toList().isNotEmpty && columnType == Constant.configurationHeaderTotal)
                ? Container(
                  alignment:(kIsWeb)? Alignment.topCenter :Alignment.center,
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
                                border: Border.all(width: 1.w),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(
                                "Tracks the total duration of all physical activities combined. This can be viewed at the day, week, or individual activity level.")),
                      ),
                    ];
                  },
                  child:Container(
                    alignment: Alignment.center,
                    child:  Text(
                      Constant.trackingChartTotalHeader,
                      textAlign:
                      TextAlign
                          .center,
                      overflow: TextOverflow
                          .ellipsis,
                    ),
                  )
              ),
            ):Container(),

            (logic.trackingPrefList.where((element) => element.titleName == Constant.configurationNotes &&
                element.isSelected).toList().isNotEmpty && columnType == Constant.configurationNotes)
                ? Container(
              alignment:(kIsWeb)? Alignment.topCenter :Alignment.center,
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
                                    border: Border.all(width: 1.w),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Text(
                                    "Allows you to add personal notes about your workouts and activities. Notes can be added for each activity or summarised for the day or week.")),
                          ),
                        ];
                      },
                      child:Container(
                        alignment: Alignment.center,
                        child:  const Text(
                          Constant.configurationNotes,
                          textAlign:
                          TextAlign
                              .center,
                          overflow: TextOverflow
                              .ellipsis,
                        ),
                      )
                  ),
                ):Container(),

          ],
        ),
      ),
    ),
  );
}