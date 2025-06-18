import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../utils/utils.dart';

Widget editableActivityMinModDayData(int mainIndex, int daysIndex,
    int daysDataIndex, HistoryController logic,BuildContext context,
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
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: Utils.getInputTypeKeyboard(),
                  enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
                      logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel &&
                      element.isModerate ).toList().isNotEmpty
                  && !logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].isFromAppleHealth) ,
                  enableInteractiveSelection: false,
                  focusNode: logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].modMinValueFocus,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: FontSize.size_10),
                  maxLines: 1,
                  autofocus: false,
                  autocorrect: true,
                  controller: logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
                      .activityLevelDataList[daysDataIndex].modMinController,
                  onChanged: (value) {
                    if (onChangeData != null) {
                      onChangeData.call(value);
                    }
                  },
                  onEditingComplete: (){
                    logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].modMinValueFocus.unfocus();
                  },

                  onSubmitted: (values){
                    logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].modMinValueFocus.unfocus();
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
                    FocusScope.of(context).requestFocus(logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].modMinValueFocus);
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

Widget editableActivityMinVigDayData(int mainIndex, int daysIndex,
    int daysDataIndex, HistoryController logic,BuildContext context,
    {Function? onChangeData}) {
  return SizedBox(
      width: 20,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.right,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: Utils.getInputTypeKeyboard(),
                  enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
                      logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel &&
                      element.isVigorous ).toList().isNotEmpty
                      && !logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].isFromAppleHealth),
                  enableInteractiveSelection: false,
                  focusNode: logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].vigMinValueFocus,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: FontSize.size_10),
                  maxLines: 1,
                  autofocus: false,
                  autocorrect: true,
                  controller: logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
                      .activityLevelDataList[daysDataIndex].vigMinController,
                  onChanged: (value) {
                    if (onChangeData != null) {
                      onChangeData.call(value);
                    }
                  },
                  onEditingComplete: (){
                    logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].vigMinValueFocus.unfocus();
                  },

                  onSubmitted: (values){
                    logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].vigMinValueFocus.unfocus();
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
                    FocusScope.of(context).requestFocus(logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].vigMinValueFocus);
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

Widget editableActivityMinTotalDaysData(int mainIndex, int daysIndex,
    int daysDataIndex, HistoryController logic,BuildContext context,
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
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: Utils.getInputTypeKeyboard(),
                  enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
                      logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel &&
                  element.isTotal ).toList().isNotEmpty
                      && !logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].isFromAppleHealth) ,
                  enableInteractiveSelection: false,
                  focusNode: logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].totalMinValueFocus,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: FontSize.size_10),
                  maxLines: 1,
                  autofocus: false,
                  autocorrect: true,
                  controller: logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex]
                      .activityLevelDataList[daysDataIndex].totalMinController,
                  onChanged: (value) {
                    if (onChangeData != null) {
                      onChangeData.call(value);
                    }
                  },
                  onEditingComplete: (){
                    logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].totalMinValueFocus.unfocus();
                  },

                  onSubmitted: (values){
                    logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].totalMinValueFocus.unfocus();
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
                    FocusScope.of(context).requestFocus(logic.trackingChartDataList[mainIndex].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].totalMinValueFocus);
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

