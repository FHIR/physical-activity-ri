import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/sizer_utils.dart';
import '../../../../utils/utils.dart';
import '../../controllers/history_controller.dart';
import '../caloriesStepHeartRate.dart';

Widget editableCalStepDayData(int daysDataIndex, HistoryController logic,
    int mainIndex, int daysIndex,String titleType, CaloriesStepHeartRateData daysDataList,BuildContext context,
    {Function? onChangeData}) {
  return SizedBox(
      height: 20,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.right,
                 /* enabled: ( logic
                      .trackingChartDataList[mainIndex]
                      .dayLevelDataList[daysIndex]
                      .activityLevelDataList.isNotEmpty)?
                  (Constant.isEditMode &&
                      Constant.configurationInfo
                          .where((element) => element.title ==
                                      logic
                                          .trackingChartDataList[mainIndex]
                                          .dayLevelDataList[daysIndex]
                                          .activityLevelDataList[daysDataIndex]
                                          .displayLabel && element.isCalories
                             )
                          .toList()
                          .isNotEmpty):true,*/
                  enabled: ( logic
                      .caloriesDataList[mainIndex]
                      .daysList[daysIndex]
                      .daysDataList.isNotEmpty)?
                  (Constant.isEditMode &&
                      Constant.configurationInfo
                          .where((element) => element.title ==
                          logic
                              .caloriesDataList[mainIndex]
                              .daysList[daysIndex]
                              .daysDataList[daysDataIndex]
                              .activityName && element.isCalories
                      )
                          .toList()
                          .isNotEmpty):true,
                  enableInteractiveSelection: false,
                  focusNode: daysDataList.daysDataValueFocus,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: Utils.getInputTypeKeyboard(),
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: FontSize.size_10),
                  maxLines: 1,
                  autofocus: false,
                  autocorrect: true,
                  controller: daysDataList.daysDataValueTitleController,
                  onChanged: (value) {
                    if (onChangeData != null) {
                      onChangeData.call(value);
                    }
                  },
                  onEditingComplete: (){
                    daysDataList.daysDataValueFocus.unfocus();
                  },

                  onSubmitted: (values){
                    daysDataList.daysDataValueFocus.unfocus();
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
                    FocusScope.of(context).requestFocus(daysDataList.daysDataValueFocus);
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

Widget editableCalStepDayDataSteps(int daysDataIndex, HistoryController logic,
    int mainIndex, int daysIndex,String titleType, CaloriesStepHeartRateData daysDataList,BuildContext context,
    {Function? onChangeData}) {
  return SizedBox(
      height: 20,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.right,
                  enabled: (logic
                      .stepsDataList[mainIndex]
                      .daysList[daysIndex]
                      .daysDataList.isNotEmpty)?
                  (Constant.isEditMode &&
                      Constant.configurationInfo
                          .where((element) => element.title ==
                                     /* logic
                                          .trackingChartDataList[mainIndex]
                                          .dayLevelDataList[daysIndex]
                                          .activityLevelDataList[daysDataIndex]
                                          .displayLabel*/
                          logic
                              .stepsDataList[mainIndex]
                              .daysList[daysIndex]
                              .daysDataList[daysDataIndex]
                              .activityName && element.isSteps
                             )
                          .toList()
                          .isNotEmpty):true,
                  enableInteractiveSelection: false,
                  focusNode: daysDataList.daysDataValueFocus,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: Utils.getInputTypeKeyboard(),
                  style: TextStyle(fontSize: FontSize.size_10),
                  maxLines: 1,
                  autofocus: false,
                  autocorrect: true,
                  controller: daysDataList.daysDataValueTitleController,
                  onChanged: (value) {
                    if (onChangeData != null) {
                      onChangeData.call(value);
                    }
                  },
                  onEditingComplete: (){
                    daysDataList.daysDataValueFocus.unfocus();
                  },

                  onSubmitted: (values){
                    daysDataList.daysDataValueFocus.unfocus();
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
                    FocusScope.of(context).requestFocus(daysDataList.daysDataValueFocus);
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
