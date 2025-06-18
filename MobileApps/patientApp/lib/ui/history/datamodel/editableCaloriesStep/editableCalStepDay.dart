import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/sizer_utils.dart';
import '../../../../utils/utils.dart';
import '../../../welcomeScreen/activityConfiguration/trackingPref/datamodel/trackingPref.dart';
import '../../controllers/history_controller.dart';
import '../caloriesStepHeartRate.dart';


  Widget editableCalStepDay(int daysIndex, HistoryController logic,
      CaloriesStepHeartRateDay data, int mainIndex, String titleType, List<TrackingPref> trackingPrefList,BuildContext context,
      {Function? onChangeData}) {
    return SizedBox(
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.right,
                    // enabled: (Constant.isEditMode && Constant.configurationInfo.where((element) => (titleType == Constant.titleSteps)?element.isSteps:element.isCalories ).toList().isNotEmpty ) ,
                    enabled: (Constant.isEditMode && trackingPrefList.where((element) => (titleType == Constant.titleSteps)
                        ?(element.titleName == Constant.configurationHeaderSteps && element.isSelected):
                    (element.titleName == Constant.configurationHeaderCalories && element.isSelected)).toList().isNotEmpty ) ,
                    enableInteractiveSelection: false,
                    focusNode: data.daysValueFocus,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: Utils.getInputTypeKeyboard(),
                    textInputAction: TextInputAction.done,
                    style: TextStyle(fontSize: FontSize.size_10),
                    maxLines: 1,
                    autofocus: false,
                    autocorrect: true,
                    controller: data.daysValueTitleController,
                    onChanged: (value) {
                      if (onChangeData != null) {
                        onChangeData.call(value);
                      }
                    },
                    onEditingComplete: (){
                      data.daysValueFocus.unfocus();
                    },

                    onSubmitted: (values){
                      data.daysValueFocus.unfocus();
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
                      FocusScope.of(context).requestFocus(data.daysValueFocus);
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
