import 'package:banny_table/db_helper/box/exercise_prescription_data.dart';
import 'package:banny_table/db_helper/box/referral_data.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/ExercisePrescription/controllers/exercise_prescription_list_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/constant.dart';

class ExercisePrescriptionListScreen extends StatelessWidget {
  const ExercisePrescriptionListScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          useMaterial3: false
      ),
      child: GetBuilder<ExercisePrescriptionListController>(builder: (logic) {
        return Scaffold(
          backgroundColor: CColor.white,
          appBar: AppBar(
            backgroundColor: CColor.primaryColor,
            title: const Text("Exercise Prescription"),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: CColor.primaryColor,
            onPressed: () {
              Get.toNamed(AppRoutes.exercisePrescriptionFrom,arguments: [null])!.then((value) => {
                logic.getReferralFormData()
              });
            },
            child: const Icon(Icons.add),
          ),
          body: SafeArea(
            child: Utils.pullToRefreshApi(
                _listReferralForm(logic, context), logic.refreshController, logic.onRefresh, logic.onLoading)
          ),
        );
      }),
    );
  }



  _listReferralForm(ExercisePrescriptionListController logic, BuildContext context) {
    return (logic.exerciseListData.isEmpty)
        ? _emptyWidget("Click + button to define a physical activity exercise prescription")
        : Container(
      color: CColor.white,
      margin: EdgeInsets.only(
          // top: Sizes.height_2,
          left: Sizes.width_1,
          right: Sizes.width_1),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _itemReferralForm(logic.exerciseListData[index],logic,context,index);
        },
        itemCount: logic.exerciseListData.length,
        padding: EdgeInsets.only(bottom: Sizes.height_1),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }

  _itemReferralForm(ExerciseData exerciseListData,
      ExercisePrescriptionListController logic, BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.exercisePrescriptionFrom,arguments: [exerciseListData])!.then((value) => {
          logic.getReferralFormData()
        });
      },
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CColor.white,
          boxShadow: const [
            BoxShadow(
              color: CColor.txtGray50,
              // blurRadius: 1,
              spreadRadius: 0.5,
            )
          ],
        ),
        margin: EdgeInsets.only(
            left:(kIsWeb) ? Sizes.width_1 : Sizes.width_3 ,
            right: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            top: Sizes.height_0_5,
            bottom: Sizes.height_0_5),
        padding: EdgeInsets.only(
            left: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            right: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            top: Sizes.height_1,
            bottom: Sizes.height_1),
        width: double.infinity,
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: Sizes.height_1
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: CColor.primaryColor30,
                        ),
                        child: Image.asset(
                          "assets/icons/ic_fitness.png",
                          height: Sizes.height_2,
                          width: Sizes.height_2,
                        ),
                      ),
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: Sizes.width_4),
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${exerciseListData.status}",
                                  style: AppFontStyle.styleW700(
                                    CColor.black,
                                    (kIsWeb)?FontSize.size_3:FontSize.size_10,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: Sizes.height_0_5),
                                  child: Text(
                                    "Referral Type: ${exerciseListData.referralScope}",
                                    style: AppFontStyle.styleW500(
                                      CColor.black,
                                      (kIsWeb)?FontSize.size_2:FontSize.size_9,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: Sizes.height_0_5),
                                  child: Text(
                                    "Period Date: ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(exerciseListData.startDate ?? DateTime.now())}"
                                        " to ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(exerciseListData.endDate ?? DateTime.now())}",
                                    style: AppFontStyle.styleW500(
                                      CColor.black,
                                      (kIsWeb)?FontSize.size_2:FontSize.size_9,
                                    ),
                                  ),
                                ),
                            (exerciseListData.priority ==
                                    Constant.priorityRoutine)
                                ? Container()
                                : Container(
                                    margin:
                                        EdgeInsets.only(top: Sizes.height_0_5),
                                    child: Text(
                                      "Priority: ${exerciseListData.priority}",
                                      style: AppFontStyle.styleW500(
                                        CColor.black,
                                        (kIsWeb)
                                            ? FontSize.size_2
                                            : FontSize.size_9,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )),
                      /*Column(
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            padding:
                            EdgeInsets.only(left: Sizes.width_3, bottom: Sizes.height_2),
                            child: Icon(Icons.edit, size: (kIsWeb)?Sizes.width_1_2:Sizes.width_4),
                          ),
                          InkWell(
                            onTap: () async {
                              logic.findData = false;
                              deleteConfirmDialog(context,index,logic,false);

                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding:
                              EdgeInsets.only(left: Sizes.width_3, bottom: Sizes.height_2),
                              child: Icon(Icons.delete_forever,color: CColor.red, size: (kIsWeb)?Sizes.width_1_2:Sizes.width_5),
                            ),
                          ),
                        ],
                      ),*/
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _emptyWidget(String title) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Sizes.width_5),
        child: Text(
          // "You can add your referral from the below + button",
          title,
          style: AppFontStyle.styleW500(CColor.black, (kIsWeb)?FontSize.size_3:FontSize.size_12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  /// This Is use On the Expand For the Referral Items


  deleteConfirmDialog(BuildContext context,int index,ExercisePrescriptionListController logic,bool isRouting) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          content:(logic.findData)?  const Text("There are tasks associated with this referral - Do you want to proceed?"): const Text(
              'Are you sure you want to delete referral?'),
          actions: <Widget>[
            InkWell(
              onTap: (){
                Get.back();
              },
              child: Container(
                margin: EdgeInsets.only(
                    bottom: Sizes.height_0_5
                ),
                child: (logic.findData)? const Text("No"):Text("Cancel") ,
              ),
            ),
            InkWell(
              onTap: (){
                logic.deleteItemReferral(index,isRouting);
              },
              child: Container(
                margin: EdgeInsets.only(
                    left: (kIsWeb) ? Sizes.width_1:Sizes.width_2_5,
                    bottom: Sizes.height_0_5,
                  right:(kIsWeb) ? Sizes.width_1: Sizes.width_2
                ),
                child:(logic.findData)? const Text( "Yes" ): Text( "Delete") ,
              ),
            )
          ],
        );
      },
    );
  }


}
