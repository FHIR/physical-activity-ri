import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/sizer_utils.dart';
import '../../../../utils/utils.dart';
import '../../controllers/history_controller.dart';
import '../caloriesStepHeartRate.dart';

Widget editableRestDayData(int index,int daysIndex, int daysDataIndex,HistoryController logic,
    CaloriesStepHeartRateData dataList,BuildContext context,
    {Function? onChangeData}) {
  return  SizedBox(
      // height: 20,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.right,
                 /* enabled: (logic.trackingChartDataList[index].dayLevelDataList[daysIndex].activityLevelDataList.isNotEmpty)?
                  (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
                      logic.trackingChartDataList[index].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel &&
                      element.isRest ).toList().isNotEmpty ):true ,*/
                  enabled: (logic.heartRateRestDataList[index].daysList[daysIndex].daysDataList.isNotEmpty)?
                  (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
                      logic.heartRateRestDataList[index].daysList[daysIndex].daysDataList[daysDataIndex].activityName &&
                      element.isRest ).toList().isNotEmpty ):true ,
                  enableInteractiveSelection: false,
                  focusNode: dataList.daysDataValue1Focus,
                  textInputAction: TextInputAction.done,
                  // keyboardType: TextInputType.number,
                  /*inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"\d+([\.]\d+)?")),
                  ],*/
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: Utils.getInputTypeKeyboard(),
                  style: TextStyle(fontSize: FontSize.size_10),
                  maxLines: 1,
                  autofocus: false,
                  autocorrect: true,
                  controller: dataList.daysDataValue1Title5Controller,
                  // controller: TextEditingController(text: dataList.total.toString()),
                  onChanged: (value) {
                    if (onChangeData != null) {
                      onChangeData.call(value);
                    }
                  },
                  onEditingComplete: (){
                    dataList.daysDataValue1Focus.unfocus();
                  },

                  onSubmitted: (values){
                    dataList.daysDataValue1Focus.unfocus();
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
                    FocusScope.of(context).requestFocus(dataList.daysDataValue1Focus);
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

/*Widget editableRestDayData(int index,int daysIndex, int daysDataIndex,HistoryController logic,
    CaloriesStepHeartRateData dataList,
    {Function? onChangeData}) {
  return KeyboardActions(
    config: Utils.buildKeyboardActionsConfig(dataList.daysDataValue1Focus),
    child: SizedBox(
      // height: 20,
      child: TextField(
        textAlign: TextAlign.right,
        enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
            logic.trackingChartDataList[index].dayLevelDataListdaysIndex].daysDataList[activityLevelDataList].displayLabel &&
            element.isRest ).toList().isNotEmpty ) ,
        enableInteractiveSelection: false,
        focusNode: dataList.daysDataValue1Focus,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r"\d+([\.]\d+)?")),
        ],
        style: TextStyle(fontSize: FontSize.size_10),
        maxLines: 1,
        autofocus: false,
        autocorrect: true,
        controller: dataList.daysDataValue1Title5Controller,
        // controller: TextEditingController(text: dataList.total.toString()),
        onChanged: (value) {
          if (onChangeData != null) {
            onChangeData.call(value);
          }
        },
      ),
    ),
  );
}*/

Widget editablePeakDayData(int index,int daysIndex, int daysDataIndex, HistoryController logic,
    CaloriesStepHeartRateData dataList,BuildContext context,
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
                  /*enabled: (logic.trackingChartDataList[index].dayLevelDataList[daysIndex].activityLevelDataList.isNotEmpty)?
                  (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
                      logic.trackingChartDataList[index].dayLevelDataList[daysIndex].activityLevelDataList[daysDataIndex].displayLabel &&
                      element.isPeck ).toList().isNotEmpty ):true ,*/
                  enabled: (logic.heartRatePeakDataList[index].daysList[daysIndex].daysDataList.isNotEmpty)?
                  (Constant.isEditMode && Constant.configurationInfo.where((element) => element.title ==
                      logic.heartRatePeakDataList[index].daysList[daysIndex].daysDataList[daysDataIndex].activityName &&
                      element.isPeck ).toList().isNotEmpty ):true ,
                  enableInteractiveSelection: false,
                  focusNode: dataList.daysDataValue2Focus,
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
                  controller: dataList.daysDataValue2Title5Controller,
                  // controller: TextEditingController(text: dataList.total.toString()),
                  onChanged: (value) {
                    if (onChangeData != null) {
                      onChangeData.call(value);
                    }
                  },
                  onEditingComplete: (){
                    dataList.daysDataValue2Focus.unfocus();
                  },

                  onSubmitted: (values){
                    dataList.daysDataValue2Focus.unfocus();
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
                    FocusScope.of(context).requestFocus(dataList.daysDataValue2Focus);
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
