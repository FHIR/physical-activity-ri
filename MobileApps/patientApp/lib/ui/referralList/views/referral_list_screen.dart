import 'package:banny_table/db_helper/box/referral_data.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/referralList/controllers/referral_list_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../utils/constant.dart';

class ReferralListScreen extends StatelessWidget {
  const ReferralListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReferralListController>(builder: (logic) {
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          backgroundColor: CColor.white,
          appBar: AppBar(
            backgroundColor: CColor.primaryColor,
            title: const Text("Referral List",
              style: TextStyle(
                color: CColor.white,
                // fontSize: 20,
                fontFamily: Constant.fontFamilyPoppins,
              ),),
          ),
          /*floatingActionButton: FloatingActionButton(
              backgroundColor: CColor.primaryColor,
              onPressed: () {
                Get.toNamed(AppRoutes.referralForm,arguments: [null])!.then((value) => {
                  logic.getReferralFormData()
                });
              },
              child: const Icon(Icons.add),
            ),*/
          body: SafeArea(
            child: Utils.pullToRefreshApi(
                _listReferralForm(logic, context, constraints),
                logic.refreshController,
                logic.onRefresh,
                logic.onLoading),
          ),
        );
      });
    });
  }

  _listReferralForm(ReferralListController logic, BuildContext context,
      BoxConstraints constraints) {
    return (logic.referralListData.isEmpty)
        ? _emptyWidget("No referrals are currently recorded ")
        : Container(
            color: CColor.white,
            margin: EdgeInsets.only(
                // top: Sizes.height_2,
                left: Sizes.width_1,
                right: Sizes.width_1),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _itemReferralForm(logic.referralListData[index], logic,
                    context, index, constraints);
              },
              itemCount: logic.referralListData.length,
              padding: EdgeInsets.only(bottom: Sizes.height_1),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
          );
  }

  _itemReferralForm(ReferralData referralListData, ReferralListController logic,
      BuildContext context, int index, BoxConstraints constraints) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.referralForm, arguments: [referralListData,logic.conditionDataList])!
            .then((value) => {
              // logic.getReferralFormData()
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
        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb)
                ? AppFontStyle.sizesWidthManageWeb(1.1, constraints)
                : Sizes.width_3,
            vertical: (kIsWeb)
                ? AppFontStyle.sizesHeightManageWeb(0.5, constraints)
                : Sizes.height_0_5),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb)
                ? AppFontStyle.sizesWidthManageWeb(1.0, constraints)
                : Sizes.width_3,
            vertical: (kIsWeb)
                ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                : Sizes.height_1),
        width: double.infinity,
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: Sizes.height_1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all((kIsWeb)
                            ? AppFontStyle.sizesFontManageWeb(0.7, constraints)
                            : 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: CColor.primaryColor30,
                        ),
                        child: Image.asset(
                          Constant.icHomeReferrals,
                          height: (kIsWeb)
                              ? AppFontStyle.sizesWidthManageWeb(
                                  1.3, constraints)
                              : Sizes.height_2,
                          width: (kIsWeb)
                              ? AppFontStyle.sizesWidthManageWeb(
                                  1.3, constraints)
                              : Sizes.height_2,
                        ),
                      ),
                      (referralListData.priority == Constant.priorityUrgent)
                          ? Container(
                              margin: EdgeInsets.only(left: Sizes.width_2,top: Sizes.height_2),
                              child: Image.asset(
                                Constant.icInformation,
                                color: CColor.red,
                                width: Sizes.height_2,
                                height: Sizes.height_2,
                              ))
                          : Container(),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.only(
                            left: (kIsWeb)
                                ? AppFontStyle.sizesWidthManageWeb(
                                    1.2, constraints)
                                : (referralListData.priority == Constant.priorityUrgent) ?Sizes.width_2 :Sizes.width_4,
                            right: (kIsWeb)
                                ? AppFontStyle.sizesWidthManageWeb(
                                    1.2, constraints)
                                : Sizes.width_4),
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
                                    text: "${referralListData.status}: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: (kIsWeb)
                                          ? AppFontStyle.sizesFontManageWeb(
                                              1.1, constraints)
                                          : FontSize.size_10,
                                    ),
                                  ),
                                  TextSpan(
                                    text: (referralListData.referralScope !=
                                            null)
                                        ? '${referralListData.referralScope} '
                                        : "",
                                    style:  TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: (kIsWeb)
                                          ? AppFontStyle.sizesFontManageWeb(
                                          1.1, constraints)
                                          : FontSize.size_9,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "assigned to ${referralListData.performerName} ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: (kIsWeb)
                                          ? AppFontStyle.sizesFontManageWeb(
                                              1.1, constraints)
                                          : FontSize.size_9,
                                    ),
                                  ),
                                  TextSpan(
                                    text: (referralListData.priority ==
                                            Constant.priorityUrgent)
                                        ? "(${referralListData.priority})"
                                        : "",
                                    style:  TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: (kIsWeb)
                                          ? AppFontStyle.sizesFontManageWeb(
                                          1.1, constraints)
                                          : FontSize.size_9,
                                    ),
                                  ),
                                ],
                              ),
                              maxLines: 3,
                            ),
                            RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyMedium,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: (referralListData.startDate != null)
                                        ? '${DateFormat(Constant.commonDateFormatDdMmYyyy).format(referralListData.startDate!)}'
                                        : "",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: (kIsWeb)
                                          ? AppFontStyle.sizesFontManageWeb(
                                              1.0, constraints)
                                          : FontSize.size_9,
                                    ),
                                  ),
                                  TextSpan(
                                    text: (referralListData.endDate != null)
                                        ? ' to ${DateFormat(Constant.commonDateFormatDdMmYyyy).format(referralListData.endDate!)}'
                                        : "",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: (kIsWeb)
                                          ? AppFontStyle.sizesFontManageWeb(
                                              1.0, constraints)
                                          : FontSize.size_9,
                                    ),
                                  ),
                                ],
                              ),
                              maxLines: 3,
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
          style: AppFontStyle.styleW500(
              CColor.black, (kIsWeb) ? FontSize.size_3 : FontSize.size_12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// This Is use On the Expand For the Referral Items
  /*_listRoutingReferralFormExpand(ReferralListController logic, BuildContext context,int mainIndex) {
    return (logic.routingReferralListData.isEmpty)
        ? _emptyWidget("Not founded any routing form")
        : Container(
      color: CColor.white,
      margin: EdgeInsets.only(
          top: Sizes.height_2_1,
          // left: Sizes.width_1,
          // right: Sizes.width_1,
      ),
      child: ListView.builder(

        itemBuilder: (context, index) {
          return _itemRoutingReferralFormExpand(context,logic
              .getRoutingData(logic.referralListData[mainIndex].referralIdList!)[index],index,logic);
        },
        itemCount: logic.getRoutingData(logic.referralListData[mainIndex].referralIdList!).length,
        padding: EdgeInsets.only(bottom: Sizes.height_0_5),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }*/

/*  _itemRoutingReferralFormExpand(BuildContext context, RoutingReferralData
  routingReferralListData,int index, ReferralListController logic) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.routingReferral,arguments: [null,routingReferralListData,null])
        !.then((value) => {
         logic.getReferralFormData()
        });
      },
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CColor.greyF8,
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
            vertical: Sizes.height_2),
        width: double.infinity,
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
                        "Status: ${routingReferralListData.status}",
                        style: AppFontStyle.styleW700(
                          CColor.black,
                          (kIsWeb)?FontSize.size_3:FontSize.size_10,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: Sizes.height_0_5),
                        child: Text(
                          "Priority: ${routingReferralListData.priority}",
                          style: AppFontStyle.styleW500(
                            CColor.black,
                            (kIsWeb)?FontSize.size_2:FontSize.size_9,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  padding:
                  EdgeInsets.only(left: Sizes.width_3, bottom: Sizes.height_2),
                  child: Icon(Icons.edit, size: (kIsWeb)?Sizes.width_1_2:Sizes.width_4),
                ),
                InkWell(
                  onTap: (){
                    deleteConfirmDialog(context,index,logic,true);
                  },
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding:
                    EdgeInsets.only(left: Sizes.width_3, bottom: Sizes.height_1),
                    child: Icon(Icons.delete_forever,color: CColor.red, size: (kIsWeb)?Sizes.width_1_2:Sizes.width_5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }*/

  deleteConfirmDialog(BuildContext context, int index,
      ReferralListController logic, bool isRouting) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          content: (logic.findData)
              ? const Text(
                  "There are tasks associated with this referral - Do you want to proceed?")
              : const Text('Are you sure you want to delete referral?'),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                margin: EdgeInsets.only(bottom: Sizes.height_0_5),
                child: (logic.findData) ? const Text("No") : Text("Cancel"),
              ),
            ),
            InkWell(
              onTap: () {
                logic.deleteItemReferral(index, isRouting);
              },
              child: Container(
                margin: EdgeInsets.only(
                    left: (kIsWeb) ? Sizes.width_1 : Sizes.width_2_5,
                    bottom: Sizes.height_0_5,
                    right: (kIsWeb) ? Sizes.width_1 : Sizes.width_2),
                child: (logic.findData) ? const Text("Yes") : Text("Delete"),
              ),
            )
          ],
        );
      },
    );
  }

/*
  _listRoutingReferralForm(ReferralListController logic, BuildContext context) {
    return (logic.routingReferralListData.isEmpty)
        ? _emptyWidget("Not founded any routing form")
        : Container(
      color: CColor.white,
      margin: EdgeInsets.only(
          top: Sizes.height_2_1,
          left: Sizes.width_1,
          right: Sizes.width_1),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _itemRoutingReferralForm(context,logic.routingReferralListData[index],index,logic);
        },
        itemCount: logic.routingReferralListData.length,
        padding: EdgeInsets.only(bottom: Sizes.height_10),
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }

  _itemRoutingReferralForm(BuildContext context, RoutingReferralData routingReferralListData,int index, ReferralListController logic) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.routingReferral,arguments: [null,routingReferralListData,null])
        !.then((value) => {
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
        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_1),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_2),
        width: double.infinity,
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
                        "Status: ${routingReferralListData.status}",
                        style: AppFontStyle.styleW700(
                          CColor.black,
                          (kIsWeb)?FontSize.size_3:FontSize.size_10,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: Sizes.height_0_5),
                        child: Text(
                          "Priority: ${routingReferralListData.priority}",
                          style: AppFontStyle.styleW500(
                            CColor.black,
                            (kIsWeb)?FontSize.size_2:FontSize.size_9,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: Sizes.height_0_5),
                        child: Text(
                          "Business Status: ${routingReferralListData.businessStatus}",
                          style: AppFontStyle.styleW500(
                            CColor.black,
                            (kIsWeb)?FontSize.size_2:FontSize.size_9,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  padding:
                  EdgeInsets.only(left: Sizes.width_3, bottom: Sizes.height_4),
                  child: Icon(Icons.edit, size: (kIsWeb)?Sizes.width_1_2:Sizes.width_4),
                ),
                InkWell(
                  onTap: (){
                    deleteConfirmDialog(context,index,logic,true);
                  },
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    padding:
                    EdgeInsets.only(left: Sizes.width_3, bottom: Sizes.height_3),
                    child: Icon(Icons.delete_forever,color: CColor.red, size: (kIsWeb)?Sizes.width_1_2:Sizes.width_5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
*/
}
