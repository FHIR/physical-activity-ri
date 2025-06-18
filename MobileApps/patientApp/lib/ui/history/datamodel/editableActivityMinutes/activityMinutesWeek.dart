import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../utils/color.dart';
import '../../../../utils/utils.dart';
import '../../../welcomeScreen/activityConfiguration/trackingPref/datamodel/trackingPref.dart';

Widget editableMod(int index, HistoryController logic, String cType,List<TrackingPref> trackingPrefList,
    {Function? onChangeData}) {
  return SizedBox(
      width: 20,
      child: TextField(
        textAlign: TextAlign.right,
        // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isModerate ).toList().isNotEmpty ) ,
        enabled: (Constant.isEditMode && trackingPrefList.where((element) => (cType == Constant.activityMinutesMod)
            && (element.titleName == Constant.configurationHeaderModerate && element.isSelected)).toList().isNotEmpty ) ,
        enableInteractiveSelection: false,
        focusNode: logic.trackingChartDataList[index].modMinValueFocus,
        textInputAction: TextInputAction.done,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: Utils.getInputTypeKeyboard(),
        style: TextStyle(fontSize: FontSize.size_10),
        maxLines: 1,
        autofocus: false,
        autocorrect: true,
        controller: logic.trackingChartDataList[index].modMinController,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
}

Widget editableVig(int index, HistoryController logic, String cType,List<TrackingPref> trackingPrefList,
{Function? onChangeData}) {
  return SizedBox(
      width: 20,
      child: TextField(
        textAlign: TextAlign.right,
        // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isVigorous ).toList().isNotEmpty ) ,
        enabled: (Constant.isEditMode && trackingPrefList.where((element) => (cType == Constant.activityMinutesVig)
            && (element.titleName == Constant.configurationHeaderVigorous && element.isSelected)).toList().isNotEmpty ) ,
        enableInteractiveSelection: false,
        focusNode: logic.trackingChartDataList[index].vigMinValueFocus,
        textInputAction: TextInputAction.done,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: Utils.getInputTypeKeyboard(),
        style: TextStyle(fontSize: FontSize.size_10),
        maxLines: 1,
        autofocus: false,
        autocorrect: true,
        controller: logic.trackingChartDataList[index].vigMinController,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
}

Widget editableActivityMinutes(int index, HistoryController logic, String cType,List<TrackingPref> trackingPrefList,
    {Function? onChangeData}) {
  return SizedBox(
      width: 20,
      child: TextField(
        textAlign: TextAlign.right,
        // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isTotal ).toList().isNotEmpty ) ,
        enabled: (Constant.isEditMode && trackingPrefList.where((element) => (cType == Constant.activityMinutesTotal)
            && (element.titleName == Constant.configurationHeaderTotal && element.isSelected)).toList().isNotEmpty ) ,
        enableInteractiveSelection: false,
        focusNode: logic.trackingChartDataList[index].totalMinValueFocus,
        textInputAction: TextInputAction.done,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: Utils.getInputTypeKeyboard(),
        /*style: TextStyle(fontSize: FontSize.size_10,
            color: (Constant.limitOfValue <=
                ((logic.activityMinDataList[index].totalValueController.text == "")
                    ? 0
                    : double.parse(
                    logic.activityMinDataList[index].totalValueController.text)))
                ? CColor.toastBackground
                : CColor.red),*/
        style: TextStyle(fontSize: FontSize.size_10),
        maxLines: 1,
        autofocus: false,
        autocorrect: true,
        controller: logic.trackingChartDataList[index].totalMinController,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    );
}
