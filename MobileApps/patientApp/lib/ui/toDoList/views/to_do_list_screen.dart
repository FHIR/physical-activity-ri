import 'package:banny_table/db_helper/box/to_do_form_data.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/toDoList/controllers/to_do_list_controller.dart';
import 'package:banny_table/ui/toDoList/dataModel/toDoDataListModel.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/sizer_utils.dart';
import '../../../utils/utils.dart';

class ToDoListScreen extends StatelessWidget {
  const ToDoListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return GetBuilder<ToDoListController>(builder: (logic) {
      return Scaffold(
        backgroundColor: CColor.white,
        appBar: AppBar(
          backgroundColor: CColor.primaryColor,
          title: const Text("ToDo List"),
          actions: [
            /*Container(
                margin: EdgeInsets.only(
                  right: Sizes.width_3
                ),
                child: GestureDetector(
                  onTap: (){
                    logic.getAllToDoApi();
                  },
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.history)),
                ))*/
          ],
        ),
        body: SafeArea(
          child:Utils.pullToRefreshApi(_listViewToDo(logic), logic.refreshController, logic.onRefresh, logic.onLoading),
          // child:_listViewToDo(logic),

      ),
      );
    });
  }

  _listViewToDo(ToDoListController logic) {
    return (logic.toDoDataList.isEmpty)
        ? _emptyWidget()
        : Column(
      children: [
        Expanded(
          child: Container(
              color: CColor.white,
              margin: EdgeInsets.only(
                  top: Sizes.height_2_1,
                  left: Sizes.width_1,
                  right: Sizes.width_1),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return _itemToDoList(logic.toDoDataList[index],logic,index,context);
                },
                itemCount: logic.toDoDataList.length,
                // padding: EdgeInsets.only(bottom: Sizes.height_10),
                physics: (!logic.isShowAllData) ? NeverScrollableScrollPhysics():AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
              ),
            ),
        ),
        if(!logic.isShowAllData)
          GestureDetector(
          onTapUp: (details) {
            logic.getAllToDoApi();
          },
          child: Container(
            // color: CColor.backgroundColor,
            padding: EdgeInsets.all(Sizes.width_3),
            margin: EdgeInsets.only(bottom: Sizes.height_2),
            child: const Text(
              'Show all',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w700,
                  color: CColor.primaryColor
              ),
            ),
          ),
        )
      ],
    );
  }

  _itemToDoList(ToDoDataListModel conditionData, ToDoListController logic,int index,BuildContext context) {
    return GestureDetector(
      onTap: () async {
/*
        Get.toNamed(AppRoutes.toDoFormScreen, arguments: [conditionData])!
            .then((value) => {

        });
*/

        var value = await Get.toNamed(AppRoutes.toDoFormScreen,
            arguments: [conditionData]);
        if (value != null) {
          await logic.updateLocalTodoList(value);

          logic.update();
        }

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
        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_1),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_1_5),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            (conditionData.priority == Constant.priorityUrgent)
                ? Container(
                margin: EdgeInsets.only(left: Sizes.width_0_5,top: Sizes.height_1),
                child: Image.asset(
                  Constant.icInformation,
                  color: CColor.red,
                  width: Sizes.height_2,
                  height: Sizes.height_2,
                ))
                : Container(),
            Expanded  (
                child: Container(
              margin: EdgeInsets.only(left: (conditionData.priority == Constant.priorityUrgent) ?Sizes.width_2 :Sizes.width_4,),

              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: <TextSpan>[
                        TextSpan(
                          text: "${Utils.uiStatusFromAPIStatus(conditionData.status ?? "")} ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                              color: Utils.uiStatusColorFromAPIStatus(conditionData.status ?? "")

                          ),
                        ),
                        TextSpan(
                          text: (conditionData.display != null)
                              ? '${conditionData.display} '
                              : "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: (conditionData.forDisplay != "null" && conditionData.forDisplay != null)
                              ? "for ${conditionData.forDisplay} "
                              : "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: (conditionData.priority == Constant.priorityUrgent)?"(${conditionData.priority})":"",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 3,
                  ),

                  /*Text(
                    "${conditionData.status} ",
                    style: AppFontStyle.styleW700(
                      CColor.black,
                      (kIsWeb)?FontSize.size_3:FontSize.size_10,
                    ),
                  ),
                  (conditionData.statusReason != null)?
                  Container(
                    margin: EdgeInsets.only(top: Sizes.height_0_5),
                    child: Text(
                      "Status Reason : ${conditionData.statusReason}",
                      style: AppFontStyle.styleW500(
                        CColor.black,
                        (kIsWeb)?FontSize.size_2:FontSize.size_9,
                      ),
                    ),
                  ): Container(),
                  (conditionData.priority != null )?
                  Container(
                    margin: EdgeInsets.only(top: Sizes.height_0_5),
                    child: Text(
                      "Priority : ${conditionData.priority}",
                      style: AppFontStyle.styleW500(
                        CColor.black,
                        (kIsWeb)?FontSize.size_2:FontSize.size_9,
                      ),
                    ),
                  ): Container(),
                  (conditionData.display != null )?
                  Container(
                    margin: EdgeInsets.only(top: Sizes.height_0_5),
                    child: Text(
                      "code : ${conditionData.display}",
                      style: AppFontStyle.styleW500(
                        CColor.black,
                        (kIsWeb)?FontSize.size_2:FontSize.size_9,
                      ),
                    ),
                  ): Container(),*/
                ],
              ),
            )),
            Column(
              children: [
                /*Container(
                  alignment: Alignment.topCenter,
                  padding:
                      EdgeInsets.only(left: Sizes.width_3, bottom: Sizes.height_3),
                  child: Icon(Icons.edit, size: (kIsWeb)?Sizes.width_1_2:Sizes.width_4),
                ),*/
                Container(
                  margin: EdgeInsets.only(right: Sizes.width_3),
                  alignment: Alignment.center,
                  child: Image.asset(
                    height: (kIsWeb)?Sizes.width_2:Sizes.width_4_5,
                    width: (kIsWeb)?Sizes.width_2:Sizes.width_4_5,
                      (conditionData.code == Constant.rxCode)?Constant.icHomeExercisePrescriptions:Constant.icHomePatientTask
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }


  _emptyWidget() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Sizes.width_5),
        child: Text(
          // "No ToDos are currently recorded ",
            "There are no tasks waiting for you",
          style: AppFontStyle.styleW500(CColor.black, (kIsWeb)?FontSize.size_3:FontSize.size_12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
