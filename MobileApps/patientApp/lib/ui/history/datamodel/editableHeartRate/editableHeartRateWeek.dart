import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/datamodel/trackingPref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/sizer_utils.dart';
import '../../../../utils/utils.dart';
import '../../controllers/history_controller.dart';
import '../caloriesStepHeartRate.dart';

Widget editableRestWeek(int index, HistoryController logic,
    CaloriesStepHeartRateWeek dataList, List<TrackingPref> trackingPrefList,BuildContext context,
    {Function? onChangeData}) {
  return  SizedBox(
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.right,
                  // enabled: Constant.isEditMode,
                  // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isRest ).toList().isNotEmpty ) ,
                  enabled: (Constant.isEditMode && trackingPrefList.where((element) => (element.titleName == Constant.configurationHeaderRest && element.isSelected)).toList().isNotEmpty ) ,
                  enableInteractiveSelection: false,
                  focusNode: dataList.weekValue1Focus,
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
                  controller: dataList.weekValue1Title5Title5Controller,
                  onChanged: (value) {
                    if (onChangeData != null) {
                      onChangeData.call(value);
                    }
                  },
                  onEditingComplete: (){
                    dataList.weekValue1Focus.unfocus();
                  },

                  onSubmitted: (values){
                    dataList.weekValue1Focus.unfocus();
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
                    FocusScope.of(context).requestFocus(dataList.weekValue1Focus);
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

/*Widget editableRestWeek(int index, HistoryController logic,
    CaloriesStepHeartRateWeek dataList,
    {Function? onChangeData}) {
  return KeyboardActions(
    config: Utils.buildKeyboardActionsConfig(dataList.weekValue1Focus),
    child: SizedBox(
      height: 20,
      child: TextField(
        textAlign: TextAlign.right,
        enabled: Constant.isEditMode,
        enableInteractiveSelection: false,
        focusNode: dataList.weekValue1Focus,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"\d+([\.]\d+)?")),
        ],
        style: TextStyle(fontSize: FontSize.size_10),
        maxLines: 1,
        autofocus: false,
        autocorrect: true,
        controller: dataList.weekValue1Title5Title5Controller,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    ),
  );
}*/

Widget editablePeakWeek(int index, HistoryController logic,
    CaloriesStepHeartRateWeek dataList, List<TrackingPref> trackingPrefList,BuildContext context,
    {Function? onChangeData}) {
  return SizedBox(
      // height: 20,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.right,
                  // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.isPeck ).toList().isNotEmpty ) ,
                  enabled: (Constant.isEditMode && trackingPrefList.where((element) => (element.titleName == Constant.configurationHeaderPeck && element.isSelected)).toList().isNotEmpty ) ,
                  enableInteractiveSelection: false,
                  focusNode: dataList.weekValue2Focus,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: Utils.getInputTypeKeyboard(),
                  /*keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"\d+([\.]\d+)?")),
                  ],*/
                  style: TextStyle(fontSize: FontSize.size_10),
                  maxLines: 1,
                  autofocus: false,
                  autocorrect: true,
                  controller: dataList.weekValue2Title5Controller,
                  onChanged: (value) {
                    if (onChangeData != null) {
                      onChangeData.call(value);
                    }
                  },
                  onEditingComplete: (){
                    dataList.weekValue2Focus.unfocus();
                  },

                  onSubmitted: (values){
                    dataList.weekValue2Focus.unfocus();
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
                    FocusScope.of(context).requestFocus(dataList.weekValue2Focus);
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

  /*Widget editablePeakWeek(int index, HistoryController logic,
    CaloriesStepHeartRateWeek dataList,
    {Function? onChangeData}) {
  return KeyboardActions(
    config: Utils.buildKeyboardActionsConfig(dataList.weekValue2Focus),
    child: SizedBox(
      height: 20,
      child: TextField(
        textAlign: TextAlign.right,
        enabled: Constant.isEditMode,
        enableInteractiveSelection: false,
        focusNode: dataList.weekValue2Focus,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"\d+([\.]\d+)?")),
        ],
        style: TextStyle(fontSize: FontSize.size_10),
        maxLines: 1,
        autofocus: false,
        autocorrect: true,
        controller: dataList.weekValue2Title5Controller,
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    ),
  );*/


}