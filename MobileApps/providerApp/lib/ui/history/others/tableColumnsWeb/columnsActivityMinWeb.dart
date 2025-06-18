import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:flutter/material.dart';

import '../../../../utils/color.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/font_style.dart';
import '../../../../utils/sizer_utils.dart';
import '../../../../utils/utils.dart';

// DataColumn cActivityMinWeb(HistoryController logic) {
//   return DataColumn(
//     label: Expanded(
//       child: Container(
//         decoration: const BoxDecoration(
//             border: Border(
//           right: BorderSide(color: CColor.black),
//         )),
//         child: Row(
//           children: [
//             SizedBox(
//               width: (!Constant.boolActivityMinMod && !Constant.boolActivityMinVig)
//                   ? Sizes.width_15
//                   : Sizes.width_25,
//               child: Column(
//                 children: [
//                   const Text(
//                     Constant.activityMinutes,
//                     textAlign: TextAlign.center,
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(top: Sizes.height_0_7),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         (Constant.boolActivityMinMod)
//                             ? Container(
//                                 margin: EdgeInsets.only(left: Sizes.width_3),
//                                 child: const Text(
//                                   Constant.activityMinutesMod,
//                                   textAlign: TextAlign.center,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               )
//                             : Container(),
//                         (Constant.boolActivityMinMod) ? const Spacer() : Container(),
//                         (Constant.boolActivityMinVig)
//                             ? const Text(
//                                 Constant.activityMinutesVig,
//                                 textAlign: TextAlign.center,
//                                 overflow: TextOverflow.ellipsis,
//                               )
//                             : Container(),
//                         (Constant.boolActivityMinVig) ? const Spacer() : Container(),
//                         Container(
//                           margin: EdgeInsets.only(right: Sizes.width_3),
//                           child: const Text(
//                             Constant.activityMinutesTotal,
//                             textAlign: TextAlign.center,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

/*Widget cActivityMinWebNormal(HistoryController logic,BuildContext context) {
  return Container(
    height: Constant.commonHeightForTableBoxWebHeader,
    decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: CColor.transparent),
        )),
    child: Row(
      children: [
        SizedBox(
          width:MediaQuery.of(context).size.width *
              Utils.getActivityMinRowColumnWidth(context,Constant.boolActivityMinMod,Constant.boolActivityMinVig,logic),
          child: Column(
            children: [
               Text(
                Constant.activityMinutes,
                textAlign: TextAlign.center,
                style: AppFontStyle.headerStyle(),
              ),
              Container(
                margin: EdgeInsets.only(top: Sizes.height_0_7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (Constant.boolActivityMinMod)
                        ? Container(
                      margin: EdgeInsets.only(left: Sizes.width_3),
                      child: Text(
                        Constant.activityMinutesMod,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: AppFontStyle.headerStyle(),
                      ),
                    )
                        : Container(),
                    (Constant.boolActivityMinMod) ? const Spacer() : Container(),
                    (Constant.boolActivityMinVig)
                        ?  Text(
                      Constant.activityMinutesVig,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyle.headerStyle(),
                    )
                        : Container(),
                    (Constant.boolActivityMinVig) ?  const Spacer() : Container(),
                    Container(
                      margin: EdgeInsets.only(right: Sizes.width_3),
                      child:  Text(
                        Constant.activityMinutesTotal,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: AppFontStyle.headerStyle(),
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
  );
}*/

Widget cActivityMinWebNormal( HistoryController logic,BuildContext context,
    String columnType,BoxConstraints constraints){
  return Container(
    alignment: Alignment.center,
    height: AppFontStyle.commonHeightForTrackingChartWeb(constraints),
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
      alignment: Alignment.center,
      width:/*MediaQuery.of(context).size.width **/
      ((columnType == Constant.configurationHeaderModerate)?Utils.getModRowColumnWidthWeb(context,logic,constraints):
      (columnType == Constant.configurationHeaderVigorous)?Utils.getVigRowColumnWidthWeb(context,logic,constraints):
      (columnType == Constant.configurationHeaderTotal)?Utils.getTotalRowColumnWidthWeb(context,logic,constraints):
      Utils.getNotesRowColumnWidthWeb(context,logic,constraints)),
      child: Container(
        alignment: Alignment.center,
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
              alignment: Alignment.center,
              child:  Text(
                // Constant.activityMinutesMod,
                Constant.trackingChartModHeader,
                textAlign:
                TextAlign
                    .center,
                overflow: TextOverflow
                    .ellipsis,
                style: AppFontStyle.headerStyle(constraints),
              ),
            ):Container(),

            (logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderVigorous &&
                element.isSelected).toList().isNotEmpty && columnType == Constant.configurationHeaderVigorous)
                ?  Container(
              alignment: Alignment.center,
              child: Text(
                Constant.trackingChartVigHeader,
                textAlign:
                TextAlign
                    .center,
                overflow: TextOverflow
                    .ellipsis,
                style: AppFontStyle.headerStyle(constraints),

              ),
            ):Container(),

            (logic.trackingPrefList.where((element) => element.titleName == Constant.configurationHeaderTotal &&
                element.isSelected).toList().isNotEmpty && columnType == Constant.configurationHeaderTotal)
                ? Container(
              alignment: Alignment.center,
              child: Text(
                Constant.trackingChartTotalHeader,
                textAlign:
                TextAlign
                    .center,
                overflow: TextOverflow
                    .ellipsis,
                style: AppFontStyle.headerStyle(constraints),
              ),
            ):Container(),

            (logic.trackingPrefList.where((element) => element.titleName == Constant.configurationNotes &&
                element.isSelected).toList().isNotEmpty && columnType == Constant.configurationNotes)
                ? Container(
              alignment: Alignment.center,
              child:  Text(
                Constant.configurationNotes,
                textAlign:
                TextAlign
                    .center,
                overflow: TextOverflow
                    .ellipsis,
                style: AppFontStyle.headerStyle(constraints),
              ),
            ):Container(),

          ],
        ),
      ),
    ),
  );
}

//
// Widget cActivityModNormal(HistoryController logic,BuildContext context){
//   return Container(
//     height: Constant.commonHeightForTableBoxMobileHeader,
//     decoration:  const BoxDecoration(
//         border: Border(
//           right: BorderSide(
//               color: CColor.transparent
//           ),
//         )
//     ),
//     child: Row(
//       children: [
//         SizedBox(
//           width:MediaQuery.of(context).size.width *
//               Utils.getModRowColumnWidth(context,logic),
//           // 0.25,
//           child: const Text(
//             Constant.activityMinutesMod,
//             textAlign: TextAlign
//                 .center,
//           ),
//         ),
//
//       ],
//     ),
//   );
// }
// Widget cActivityVigNormal(HistoryController logic,BuildContext context){
//   return Container(
//     height: Constant.commonHeightForTableBoxMobileHeader,
//     decoration:  const BoxDecoration(
//         border: Border(
//           right: BorderSide(
//               color: CColor.transparent
//           ),
//         )
//     ),
//     child: Row(
//       children: [
//         SizedBox(
//           width:MediaQuery.of(context).size.width *
//               // Utils.getVigRowColumnWidth(context,false,true,logic),
//               Utils.getVigRowColumnWidth(context,logic),
//           // 0.25,
//           child: const Text(
//             Constant.activityMinutesVig,
//             textAlign: TextAlign
//                 .center,
//           ),
//         ),
//
//       ],
//     ),
//   );
// }
// Widget cActivityTotalNormal(HistoryController logic,BuildContext context){
//   return Container(
//     height: Constant.commonHeightForTableBoxMobileHeader,
//     decoration:  const BoxDecoration(
//         border: Border(
//           right: BorderSide(
//               color: CColor.transparent
//           ),
//         )
//     ),
//     child: Row(
//       children: [
//         SizedBox(
//           width:MediaQuery.of(context).size.width *
//               // Utils.getTotalRowColumnWidth(context,true,false,logic),
//               Utils.getTotalRowColumnWidth(context,logic),
//           // 0.25,
//           child: const Text(
//             Constant.activityMinutesTotal,
//             textAlign: TextAlign
//                 .center,
//           ),
//         ),
//
//       ],
//     ),
//   );
// }
// Widget cActivityNotesNormal(HistoryController logic,BuildContext context){
//   return Container(
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
