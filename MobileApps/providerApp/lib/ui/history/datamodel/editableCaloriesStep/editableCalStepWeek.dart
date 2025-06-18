import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/dataModel/trackingPref.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/sizer_utils.dart';
import '../../../../utils/utils.dart';
import '../../controllers/history_controller.dart';
import '../caloriesStepHeartRate.dart';

Widget editableCalStepWeek(int index, HistoryController logic,String titleType,
    CaloriesStepHeartRateWeek dataList, List<TrackingPref> trackingPrefList,BuildContext context,
    {Function? onChangeData }) {
  return  SizedBox(
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.right,
                  enabled: (Constant.isEditMode && trackingPrefList.where((element) => (titleType == Constant.titleSteps)
                      ?(element.titleName == Constant.configurationHeaderSteps && element.isSelected):
                      (element.titleName == Constant.configurationHeaderCalories && element.isSelected)).toList().isNotEmpty ),
                  enableInteractiveSelection: false,
                  focusNode: dataList.weekValueFocus,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: FontSize.size_10),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: Utils.getInputTypeKeyboard(),
                  maxLines: 1,
                  autofocus: false,
                  autocorrect: true,
                  controller: dataList.weekValueTitleController,
                  onChanged: (value) {
                    if (onChangeData != null) {
                      onChangeData.call(value);
                    }
                  },
                  onTap: (){
                  },
                  onEditingComplete: (){
                    dataList.weekValueFocus.unfocus();
                  },

                  onSubmitted: (values){
                    dataList.weekValueFocus.unfocus();
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
                    FocusScope.of(context).requestFocus(dataList.weekValueFocus);
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


