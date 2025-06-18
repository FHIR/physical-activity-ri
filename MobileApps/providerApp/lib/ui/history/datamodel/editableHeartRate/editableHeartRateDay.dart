
import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/dataModel/trackingPref.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../utils/constant.dart';
import '../../../../utils/sizer_utils.dart';
import '../../../../utils/utils.dart';
import '../caloriesStepHeartRate.dart';

Widget editableRestDay(int index, HistoryController logic,
    CaloriesStepHeartRateDay dataList, List<TrackingPref> trackingPrefList,BuildContext context,
    {Function? onChangeData}) {
  return  SizedBox(
      // width: 20,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.right,
                  // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isRest ).toList().isNotEmpty ) ,
                  enabled: (Constant.isEditMode && trackingPrefList.where((element) => (element.titleName == Constant.configurationHeaderRest && element.isSelected)).toList().isNotEmpty ) ,
                  enableInteractiveSelection: false,
                  focusNode: dataList.daysValue1Focus,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: Utils.getInputTypeKeyboard(),
                  // keyboardType: TextInputType.number,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(RegExp(r"\d+([\.]\d+)?")),
                  // ],
                  style: TextStyle(fontSize: FontSize.size_10),
                  maxLines: 1,
                  autofocus: false,
                  autocorrect: true,
                  controller: dataList.daysValue1Title5Controller,
                  onChanged: (value) {
                    if (onChangeData != null) {
                      onChangeData.call(value);
                    }
                  },
                  onEditingComplete: (){
                    dataList.daysValue1Focus.unfocus();
                  },

                  onSubmitted: (values){
                    dataList.daysValue1Focus.unfocus();
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
                    FocusScope.of(context).requestFocus(dataList.daysValue1Focus);
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

Widget editablePeakDay(int index, HistoryController logic,
    CaloriesStepHeartRateDay dataList,List<TrackingPref> trackingPrefList,BuildContext context,
    {Function? onChangeData}) {
  return SizedBox(
      // width: 20,
      // height: 20,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.right,
                  // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isRest ).toList().isNotEmpty ) ,
                  enabled: (Constant.isEditMode && trackingPrefList.where((element) => (element.titleName == Constant.configurationHeaderPeck && element.isSelected)).toList().isNotEmpty ) ,
                  enableInteractiveSelection: false,
                  focusNode: dataList.daysValue2Focus,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: Utils.getInputTypeKeyboard(),
                  // keyboardType: TextInputType.number,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(RegExp(r"\d+([\.]\d+)?")),
                  // ],
                  style: TextStyle(fontSize: FontSize.size_10),
                  maxLines: 1,
                  autofocus: false,
                  autocorrect: true,
                  controller: dataList.daysValue2Title5Controller,
                  onChanged: (value) {
                    if (onChangeData != null) {
                      onChangeData.call(value);
                    }
                  },
                  onEditingComplete: (){
                    dataList.daysValue2Focus.unfocus();
                  },

                  onSubmitted: (values){
                    dataList.daysValue2Focus.unfocus();
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
                    FocusScope.of(context).requestFocus(dataList.daysValue2Focus);
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