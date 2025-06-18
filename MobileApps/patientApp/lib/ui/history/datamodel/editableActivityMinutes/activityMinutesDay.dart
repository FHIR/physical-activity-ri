import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../utils/utils.dart';
import '../../../welcomeScreen/activityConfiguration/trackingPref/datamodel/trackingPref.dart';

Widget editableActivityMinModDay(int mainIndex, int daysIndex,
    HistoryController logic,String cType,List<TrackingPref> trackingPrefList,BuildContext context,
    {Function? onChangeData}) {
  return  SizedBox(
      width: 20,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.right,
                  // enabled: Constant.isEditMode,
                  // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isModerate ).toList().isNotEmpty ) ,
                  enabled: (Constant.isEditMode && trackingPrefList.where((element) => (cType == Constant.activityMinutesMod)
                      && (element.titleName == Constant.configurationHeaderModerate && element.isSelected)).toList().isNotEmpty ) ,

                  keyboardType: Utils.getInputTypeKeyboard(),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                  enableInteractiveSelection: false,
                  focusNode: logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].modMinValueFocus,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: FontSize.size_10),
                  maxLines: 1,
                  autofocus: false,
                  autocorrect: true,
                  controller: logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
                      .modMinController,
                  onChanged: (value) {
                    if (onChangeData != null) {
                      onChangeData.call(value);
                    }
                  },
                  onEditingComplete: (){
                    logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].modMinValueFocus.unfocus();
                  },

                  onSubmitted: (values){
                    logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].modMinValueFocus.unfocus();
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: (){
                    FocusScope.of(context).requestFocus( logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].modMinValueFocus);
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
}

Widget editableActivityMinVigDay(int mainIndex, int daysIndex,
    HistoryController logic,String cType,List<TrackingPref> trackingPrefList,BuildContext context,
    {Function? onChangeData}) {
  return  SizedBox(
      width: 20,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.right,
                  // enabled: Constant.isEditMode,
                  // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isVigorous ).toList().isNotEmpty ) ,
                  enabled: (Constant.isEditMode && trackingPrefList.where((element) => (cType == Constant.activityMinutesVig)
                      && (element.titleName == Constant.configurationHeaderVigorous && element.isSelected)).toList().isNotEmpty ) ,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: Utils.getInputTypeKeyboard(),
                  enableInteractiveSelection: false,
                  focusNode: logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].vigMinValueFocus,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: FontSize.size_10),
                  maxLines: 1,
                  autofocus: false,
                  autocorrect: true,
                  controller: logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
                      .vigMinController,
                  onChanged: (value) {
                    if (onChangeData != null) {
                      onChangeData.call(value);
                    }
                  },
                  onEditingComplete: (){
                    logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].vigMinValueFocus.unfocus();
                  },

                  onSubmitted: (values){
                    logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].vigMinValueFocus.unfocus();
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: (){
                    FocusScope.of(context).requestFocus(logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].vigMinValueFocus);
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
}

Widget editableActivityMiTotalDays(int mainIndex, int daysIndex,
    HistoryController logic,String cType,List<TrackingPref> trackingPrefList,BuildContext context,
    {Function? onChangeData}) {
  return Stack(
    children: [
      Row(
        children: [
          Expanded(
            child: TextField(
                  textAlign: TextAlign.right,
                  // enabled: Constant.isEditMode,
              // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isTotal ).toList().isNotEmpty ) ,
              enabled: (Constant.isEditMode && trackingPrefList.where((element) => (cType == Constant.activityMinutesTotal)
                  && (element.titleName == Constant.configurationHeaderTotal && element.isSelected)).toList().isNotEmpty ) ,

              enableInteractiveSelection: false,
                  focusNode: logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].totalMinValueFocus,
                  textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: Utils.getInputTypeKeyboard(),
                  style: TextStyle(fontSize: FontSize.size_10),
                  maxLines: 1,
                  autofocus: false,
                  autocorrect: true,
                  controller: logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
                      .totalMinController,
                  onChanged: (value) {
                    if (onChangeData != null) {
                      onChangeData.call(value);
                    }
                  },
              onEditingComplete: (){
                logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].totalMinValueFocus.unfocus();
              },

              onSubmitted: (values){
                logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].totalMinValueFocus.unfocus();
              },
                ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: (){
                FocusScope.of(context).requestFocus(logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].totalMinValueFocus);
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
