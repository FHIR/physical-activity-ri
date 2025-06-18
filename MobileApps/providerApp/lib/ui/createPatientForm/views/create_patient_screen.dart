import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../utils/utils.dart';
import '../controllers/create_patient_controller.dart';

class CreatePatientScreen extends StatelessWidget {
  const CreatePatientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          useMaterial3: false
      ),
      child: GetBuilder<CreatePatientController>(builder: (logic) {
        return Scaffold(
          backgroundColor: CColor.white,
          appBar: AppBar(
            backgroundColor: CColor.primaryColor,
            title: Text((logic.isEdit) ? "Update Patient" : "Create Patient"),
          ),
          body: LayoutBuilder(
            builder: (BuildContext context,BoxConstraints constraints) {
              return SafeArea(
                child: SingleChildScrollView(
                  child:  Column(
                      children: [
                        _widgetFirstNameEnterText(logic, context,constraints),
                        _widgetLastNameEnterText(logic,constraints),
                        _widgetDOB(logic, context,constraints),
                        _widgetGenderSelectionDropDown(context, logic,constraints),
                        // _widgetCommunicationDropDown(context,logic),
                        _widgetPhoneNumberEditText(logic, context,constraints),
                        _widgetEmailAddressEditText(logic, context,constraints),
                        _widgetMailingAddressEditText(logic, context,constraints),
                        _widgetEmergencyPhoneNumberEditText(logic, context,constraints),
                        if(logic.isAdmin)_widgetGpEditText(logic, context,constraints),
                        Container(
                          margin: EdgeInsets.only(
                              top: Sizes.height_2, bottom: Sizes.height_5),
                          child: Row(
                            children: [
                              _buttonCancel(context,constraints),
                              _buttonAddUpdate(context,constraints),
                            ],
                          ),
                        ),
                      ],
                    ),
                ),
              );
            }
          ),
        );
      }),
    );
  }

  void showDialogForChooseCode(CreatePatientController logic,
      BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setStateDialogForChooseCode) {
            return AlertDialog(
              backgroundColor: CColor.white,
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              content: SingleChildScrollView(
                child: Container(
                  width: Get.width * 0.8,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      color: CColor.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListView.builder(
                        itemBuilder: (context, index) {
                          return _itemCodeData(index, context,
                              Utils.codeTodoList[index].display, logic);
                        },
                        itemCount: Utils.codeTodoList.length,
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                      ),
                      InkWell(
                        onTap: () {
                          showDialogForAddNewCode(
                              context, logic, setStateDialogForChooseCode);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: Sizes.width_2,
                          ),
                          child: Text(
                            "+ Add New Code",
                            style: AppFontStyle.styleW500(
                              CColor.primaryColor,
                              (kIsWeb) ? FontSize.size_3 : FontSize.size_12,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  showDialogForAddNewCode(BuildContext context, CreatePatientController logic,
      setStateDialogForChooseCode) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: CColor.white,
          contentPadding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          content: Wrap(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(Sizes.width_5),
                  width: Get.width * 0.8,
                  child: Column(
                    children: [
                      Container(
                        color: CColor.transparent,
                        child: TextFormField(
                          controller: logic.addNewCodeController,
                          focusNode: logic.addNewCodeFocus,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.text,
                          style: AppFontStyle.styleW500(CColor.black,
                              (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
                          maxLines: 2,
                          cursorColor: CColor.black,
                          decoration: InputDecoration(
                            hintText: "Enter your code".tr,
                            filled: true,
                            // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: CColor.primaryColor, width: 0.7),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: CColor.primaryColor, width: 0.7),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: CColor.primaryColor, width: 0.7),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: CColor.primaryColor, width: 0.7),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: Sizes.height_2),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      CColor.transparent),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: const BorderSide(
                                          color: CColor.primaryColor,
                                          width: 0.7),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.all((kIsWeb) ? 10 : 5),
                                  child: Text(
                                    "Cancel",
                                    textAlign: TextAlign.center,
                                    style: AppFontStyle.styleW400(
                                        CColor.black,
                                        (kIsWeb)
                                            ? FontSize.size_3
                                            : FontSize.size_12),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: Sizes.width_2),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  logic.addNewCodeDataIntoList(
                                      logic.addNewCodeController.text);
                                  setStateDialogForChooseCode(() {});
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      CColor.primaryColor),
                                  elevation: MaterialStateProperty.all(1),
                                  shadowColor:
                                  MaterialStateProperty.all(CColor.gray),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: const BorderSide(
                                          color: CColor.primaryColor,
                                          width: 0.7),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.all((kIsWeb) ? 10 : 5),
                                  child: Text(
                                    "Add",
                                    textAlign: TextAlign.center,
                                    style: AppFontStyle.styleW400(
                                        CColor.white,
                                        (kIsWeb)
                                            ? FontSize.size_3
                                            : FontSize.size_12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _itemCodeData(int index, BuildContext context, String codeDisplay,
      CreatePatientController logic) {
    return InkWell(
      onTap: () {
        logic.onChangeCode(index);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Sizes.height_3, left: Sizes.width_2),
        child: Text(
          codeDisplay,
          style: AppFontStyle.styleW500(
            (Utils.codeTodoList[index].display == logic.selectedDisplay)
                ? CColor.primaryColor
                : CColor.black,
            (kIsWeb) ? FontSize.size_3 : FontSize.size_12,
          ),
        ),
      ),
    );
  }

  _widgetFirstNameEnterText(CreatePatientController logic,
      BuildContext context,BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: (kIsWeb)
                  ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                  : Sizes.height_3,
              right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
              left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(2.0, constraints)  :Sizes.width_4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Given name",
                  style: AppFontStyle.styleW700(CColor.black,
                      (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                ),
              ),
              InkWell(
                onTap: () {
                  logic.addPhoneNumberList(Constant.firstNameAdd);
                },
                child: Container(
                    margin: EdgeInsets.only(
                      right: (kIsWeb)  ? AppFontStyle.sizesFontManageWeb(0.8, constraints) :Sizes.width_2,
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      size: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(2.0, constraints) : Sizes.width_7,
                    )),
              )
            ],
          ),
        ),
        ListView.builder(
          itemBuilder: (context, index) {
            return itemFirstName(logic, index,constraints);
          },
          shrinkWrap: true,
          itemCount: logic.firstNameModelList.length,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }

  Widget itemFirstName(CreatePatientController logic, int index,BoxConstraints constraints) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(
                top: (kIsWeb)
                    ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                    : Sizes.height_1,
                right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
                left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.0, constraints)  :Sizes.width_3),
            decoration: BoxDecoration(
              color: CColor.transparent,
              border: Border.all(
                color: CColor.primaryColor,
                width: 0.7,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: TextFormField(
              controller: logic.firstNameModelList[index].firstNameController,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.start,
              textInputAction: TextInputAction.done,
              style: AppFontStyle.styleW500(
                  CColor.black, (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
              cursorColor: CColor.black,
              decoration: InputDecoration(
                hintText: logic.firstNameFocusText,
                filled: true,
                border: InputBorder.none,
              ),
              onChanged: (values) {
                logic.onChangeAddFirstName(values, index);
              },
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            logic.removeInList(Constant.firstNameAdd,index);
          },
          child: Container(
              margin: EdgeInsets.only(
                  right: (kIsWeb) ?AppFontStyle.sizesFontManageWeb(2.0, constraints)  : Sizes.width_5_4
              ),
              child: Icon(Icons.close,color: CColor.red,)),
        )
      ],
    );
  }

  Widget _widgetLastNameEnterText(CreatePatientController logic,BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: (kIsWeb)
                  ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                  : Sizes.height_3,
              right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
              left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(2.0, constraints)  :Sizes.width_4),
          child: RichText(
            text: TextSpan(
              text: "Last name",
              style: AppFontStyle.styleW700(
                  CColor.black, (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
            ),
          ),
        ),
        Container(
          // height: Sizes.height_6,
          margin: EdgeInsets.only(
              top: (kIsWeb)
                  ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                  : Sizes.height_1,
              right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
              left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.0, constraints)  :Sizes.width_3),
          decoration: BoxDecoration(
            color: CColor.transparent,
            border: Border.all(
              color: CColor.primaryColor,
              width: 0.7,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: TextFormField(
            controller: logic.lastNameController,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.start,
            focusNode: logic.lastNameFocus,
            textInputAction: TextInputAction.done,
            style: AppFontStyle.styleW500(
                CColor.black, (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
            cursorColor: CColor.black,
            decoration: InputDecoration(
              hintText: logic.lastNameFocusText,
              filled: true,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _widgetDOB(CreatePatientController logic, BuildContext context,BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: (kIsWeb)
                  ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                  : Sizes.height_4,
              right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
              left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(2.0, constraints)  :Sizes.width_4),
          child: RichText(
            text: TextSpan(
              text: "Birth Date",
              style: AppFontStyle.styleW700(
                  CColor.black, (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
              children: const <TextSpan>[],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showDatePickerDialog(logic, context);
          },
          child: Container(
            // height: Sizes.height_5_5,
            decoration: BoxDecoration(
              border: Border.all(
                  color: CColor.primaryColor,
                  width: 0.7
              ),
              borderRadius: BorderRadius.circular(15),
              color: CColor.greyF8,
            ),
            margin: EdgeInsets.only(
                top: (kIsWeb)
                    ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                    : Sizes.height_0_5,
                right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
                left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.0, constraints)  :Sizes.width_3),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    readOnly: true,
                    controller: logic.dobController,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                    style: AppFontStyle.styleW500(CColor.black,
                        (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                    cursorColor: CColor.black,
                    decoration: const InputDecoration(
                      hintText: "YYYY-MM-DD",
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: Sizes.width_3),
                  child: const Icon(Icons.calendar_month_rounded),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> showDatePickerDialog(CreatePatientController logic,
      BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          content: Container(
              width: Get.width * 0.9,
              height: Get.height * 0.5,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                  color: CColor.white),
              child: SfDateRangePicker(
                onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                  logic.onSelectionChangedDatePicker(
                      dateRangePickerSelectionChangedArgs);
                },
                selectionMode: DateRangePickerSelectionMode.single,
                view: DateRangePickerView.month,
                showActionButtons: true,
                showNavigationArrow: Utils.manageCalenderInNavigation(),
                cancelText: "Cancel",
                confirmText: "Ok",
                onCancel: () {
                  Get.back();
                },
                onSubmit: (p0) {
                  Get.back();
                },
              )),
        );
      },
    );
  }

  Widget _buttonAddUpdate(BuildContext context,BoxConstraints constraints) {
    return Expanded(
      child: GetBuilder<CreatePatientController>(builder: (logic) {
        return Container(
          margin:
          EdgeInsets.only(
              top: (kIsWeb)
                  ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                  : Sizes.height_3,
              right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_2,
              left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.0, constraints)  :Sizes.width_2),
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              logic.insertPatient(context);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(CColor.primaryColor),
              elevation: MaterialStateProperty.all(1),
              shadowColor: MaterialStateProperty.all(CColor.gray),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side:
                  const BorderSide(color: CColor.primaryColor, width: 0.7),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all((kIsWeb) ? 10 : 5),
              child: Text(
                (logic.isEdit) ? "Update" : "Create",
                textAlign: TextAlign.center,
                style: AppFontStyle.styleW400(CColor.white,
                    (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_12),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buttonCancel(BuildContext context,BoxConstraints constraints) {
    return Expanded(
      child: Container(
        margin:
        EdgeInsets.only(
            top: (kIsWeb)
                ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                : Sizes.height_3,
            right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints):  Sizes.width_2,
            left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.1, constraints)  :Sizes.width_2),
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            Get.back();
            // Navigator.pop(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(CColor.transparent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: const BorderSide(color: CColor.primaryColor, width: 0.7),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all((kIsWeb) ? 10 : 5),
            child: Text(
              "Cancel",
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW400(
                  CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints): FontSize.size_12),
            ),
          ),
        ),
      ),
    );
  }

  _widgetGenderSelectionDropDown(BuildContext context,
      CreatePatientController logic,BoxConstraints constraints) {
    return GetBuilder<CreatePatientController>(builder: (logic) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: (kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  bottom: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(0.5, constraints) : Sizes.height_1,
                  top: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(1.0, constraints) : Sizes.height_3,
                  left: (kIsWeb)? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2),
              child: Text(
                "Gender",
                style: AppFontStyle.styleW700(
                  CColor.black,
                  (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3,
                  vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.3, constraints)  :Sizes.height_1_5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: CColor.greyF8,
                border: Border.all(color: CColor.primaryColor, width: 0.7),
              ),
              child: DropdownButtonFormField<String>(
                focusColor: Colors.white,
                decoration: const InputDecoration.collapsed(hintText: ''),
                value: logic.selectedGender,
                //elevation: 5,
                style: const TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                items: Utils.genderList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: AppFontStyle.styleW500(CColor.black,
                          (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  logic.onChangeGender(value!);
                  Debug.printLog("onChangeGender value...$value");
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _widgetPhoneNumberEditText(CreatePatientController logic,
      BuildContext context,BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: (kIsWeb)
                  ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                  : Sizes.height_3,
              right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
              left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(2.0, constraints)  :Sizes.width_4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Phone Numbers",
                  style: AppFontStyle.styleW700(CColor.black,
                      (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                ),
              ),
              InkWell(
                onTap: () {
                  logic.addPhoneNumberList(Constant.phoneNumberAdd);
                },
                child: Container(
                    margin: EdgeInsets.only(
                      right: (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(0.8, constraints) :Sizes.width_2,
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      size: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(2.0, constraints) : Sizes.width_7,
                    )),
              )
            ],
          ),
        ),
        ListView.builder(
          itemBuilder: (context, index) {
            return _itemPhoneNum(index, logic, context,constraints);
          },
          shrinkWrap: true,
          itemCount: logic.phoneNumberList.length,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }

  _itemPhoneNum(int index, CreatePatientController logic,
      BuildContext context,BoxConstraints constraints) {
    return logic.phoneNumberList.isNotEmpty
        ? Container(
      margin: EdgeInsets.symmetric(
        vertical: (kIsWeb)? AppFontStyle.sizesHeightManageWeb(1.0, constraints) : Sizes.height_1,
        horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_4,
      ),
      decoration: BoxDecoration(
        color: CColor.greyF8,
        border: Border.all(color: CColor.primaryColor, width: 0.7),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints)  : Sizes.width_3,
                vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.2, constraints) : Sizes.height_1_5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: DropdownButtonFormField<String>(
              focusColor: Colors.white,
              decoration: const InputDecoration.collapsed(hintText: ''),
              value: logic.phoneNumberList[index].phoneNumber,
              // iconSize: 0.0,
              style: const TextStyle(color: Colors.white),
              iconEnabledColor: Colors.black,
              items: Utils.phoneNoType
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: AppFontStyle.styleW500(CColor.black,
                        (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                logic.onChangesPhoneNoType(value, index);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2,
            ),
            child: const Divider(
              color: CColor.black,
              height: 2,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: (kIsWeb)? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2),
                  child: TextFormField(
                    controller: logic
                        .phoneNumberList[index].phoneNumberController,
                    keyboardType: Utils.getInputTypeKeyboard(),
                    textAlign: TextAlign.start,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    textInputAction: TextInputAction.done,
                    style: AppFontStyle.styleW500(CColor.black,
                        (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10),
                    cursorColor: CColor.black,
                    decoration: InputDecoration(
                      hintText: logic.phoneNumberEnter,
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      // logic.phoneNumberList[index].address1 = value;
                      Debug.printLog("phoneNo Ids........${value}");
                    },
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  logic.removeInList(Constant.phoneNumberAdd,index);
                },
                child: Container(
                    margin: EdgeInsets.only(
                        right: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.0, constraints):Sizes.width_3
                    ),
                    child: Icon(Icons.close,color: CColor.red,)),
              )

            ],
          ),
        ],
      ),
    )
        : Container();
  }

  _widgetEmailAddressEditText(CreatePatientController logic,
      BuildContext context,BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: (kIsWeb)
                  ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                  : Sizes.height_3,
              right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
              left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(2.0, constraints)  :Sizes.width_4),
          child: Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: "Emails",
                    style: AppFontStyle.styleW700(CColor.black,
                        (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                    children: [
                      ///This Is use For Goal Type is mandatory
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                            color: CColor.red,
                            fontSize: (kIsWeb)?AppFontStyle.sizesFontManageWeb(1.3, constraints): FontSize.size_10
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Expanded(
              //   child: Text(
              //     "Emails",
              //     style: AppFontStyle.styleW700(CColor.black,
              //         (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
              //   ),
              // ),
              InkWell(
                onTap: () {
                  logic.addPhoneNumberList(Constant.emailIdAdd);
                },
                child: Container(
                    margin: EdgeInsets.only(
                      right:(kIsWeb) ? AppFontStyle.sizesFontManageWeb(0.8, constraints) : Sizes.width_2,
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      size: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(2.0, constraints) : Sizes.width_7,
                    )),
              )
            ],
          ),
        ),
        ListView.builder(
          itemBuilder: (context, index) {
            return _itemEmail(index, logic, context,constraints);
          },
          shrinkWrap: true,
          itemCount: logic.emailIdModelList.length,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }

  _itemEmail(int index, CreatePatientController logic, BuildContext context,BoxConstraints constraints) {
    return logic.emailIdModelList.isNotEmpty
        ? Row(
          children: [
            Expanded(
              child: Container(
      // height: Sizes.height_6,
                margin: EdgeInsets.only(
                    top: (kIsWeb)
                        ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                        : Sizes.height_1,
                    right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
                    left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.0, constraints)  :Sizes.width_3),
      decoration: BoxDecoration(
              color: CColor.transparent,
              border: Border.all(
                color: CColor.primaryColor,
                width: 0.7,
              ),
              borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextFormField(
              controller: logic.emailIdModelList[index].emailIdControllers,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.start,
              textInputAction: TextInputAction.done,
              autofocus: false,
              style: AppFontStyle.styleW500(
                  CColor.black, (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
              cursorColor: CColor.black,
              decoration: InputDecoration(
                hintText: logic.emailIdsEnter,
                filled: true,
                border: InputBorder.none,
              ),
              onChanged: (value) {
                logic.emailIdModelList[index].emailId = value;
                Debug.printLog("email Ids........${value}");
              },
      ),
    ),
            ),
            GestureDetector(
              onTap: (){
                logic.removeInList(Constant.emailIdAdd,index);
              },
              child: Container(
                  margin: EdgeInsets.only(
                    right: (kIsWeb) ?AppFontStyle.sizesFontManageWeb(2.0, constraints) :Sizes.width_5_4
                  ),
                  child: Icon(Icons.close,color: CColor.red,)),
            )
          ],
        )
        : Container();
  }

  _widgetMailingAddressEditText(CreatePatientController logic,
      BuildContext context,BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: (kIsWeb)
                  ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                  : Sizes.height_3,
              right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
              left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(2.0, constraints)  :Sizes.width_4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Address",
                  style: AppFontStyle.styleW700(CColor.black,
                      (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                ),
              ),
              InkWell(
                onTap: () {
                  logic.addPhoneNumberList(Constant.addAddressAdd);
                },
                child: Container(
                    margin: EdgeInsets.only(
                      right: (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(0.8, constraints) :Sizes.width_2,
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      size: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(2.0, constraints) : Sizes.width_7,
                    )),
              )
            ],
          ),
        ),
        ListView.builder(
          itemBuilder: (context, index) {
            return _itemAddress(index, logic, context,constraints);
          },
          shrinkWrap: true,
          itemCount: logic.addressModelList.length,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }

  _itemAddress(int index, CreatePatientController logic, BuildContext context,BoxConstraints constraints) {
    return logic.addressModelList.isNotEmpty
        ? Container(
      margin: EdgeInsets.symmetric(
        vertical: (kIsWeb)? AppFontStyle.sizesHeightManageWeb(1.0, constraints) : Sizes.height_1,
        horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_4,
      ),
      decoration: BoxDecoration(
        color: CColor.greyF8,
        border: Border.all(color: CColor.primaryColor, width: 0.7),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints)  : Sizes.width_3,
                vertical: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.2, constraints) : Sizes.height_1_5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              // color: CColor.greyF8,
              // border: Border.all(color: CColor.primaryColor, width: 0.7),
            ),
            child: DropdownButtonFormField<String>(
              focusColor: Colors.white,
              decoration: const InputDecoration.collapsed(hintText: ''),
              value: logic.addressModelList[index].addressType,
              // iconSize: 0.0,
              style: const TextStyle(color: Colors.white),
              iconEnabledColor: Colors.black,
              items: Utils.addressType
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: AppFontStyle.styleW500(CColor.black,
                        (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_10),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                logic.onChangesAddressType(value, index);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2,
            ),
            child: const Divider(
              color: CColor.black,
              height: 2,
            ),
          ),
          Row(
            children: [
              /*Container(
                margin: EdgeInsets.only(
                  left: Sizes.width_2
                ),
                child: Text(
                  "Address 1",
                  style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?(kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.0, constraints):FontSize.size_10),
                ),
              ),*/
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(0.8, constraints):Sizes.width_2),
                  child: TextFormField(
                    controller: logic.addressModelList[index].address1,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.done,
                    style: AppFontStyle.styleW500(CColor.black,
                        (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.3, constraints):  FontSize.size_10),
                    cursorColor: CColor.black,
                    decoration: InputDecoration(
                      hintText: logic.address1Enter,
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      // logic.addressModelList[index].address1 = value;
                      Debug.printLog("email Ids........$value");
                    },
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  logic.removeInList(Constant.addAddressAdd,index);
                },
                child: Container(
                    margin: EdgeInsets.only(
                        right: Sizes.width_3
                    ),
                    child: Icon(Icons.close,color: CColor.red,)),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2,
            ),
            child: const Divider(
              color: CColor.black,
              height: 2,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(0.8, constraints):Sizes.width_2),
                  child: TextFormField(
                    controller: logic.addressModelList[index].address2,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.done,
                    style: AppFontStyle.styleW500(CColor.black,
                        (kIsWeb) ?   AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                    cursorColor: CColor.black,
                    decoration: InputDecoration(
                      hintText: logic.address2Enter,
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      // logic.addressModelList[index].address2 = value;
                      Debug.printLog("address1Enter Ids........${value}");
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2,
            ),
            child: const Divider(
              color: CColor.black,
              height: 2,
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(0.8, constraints):Sizes.width_2),
                      child: TextFormField(
                        controller: logic.addressModelList[index].city,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.start,
                        textInputAction: TextInputAction.done,
                        style: AppFontStyle.styleW500(
                            CColor.black,
                            (kIsWeb)
                                ?   AppFontStyle.sizesFontManageWeb(1.3, constraints)
                                : FontSize.size_10),
                        cursorColor: CColor.black,
                        decoration: InputDecoration(
                          hintText: logic.addressCityEnter,
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          // logic.addressModelList[index].city = value;
                          Debug.printLog(
                              "addressCityEnter Ids........${value}");
                        },
                      ),
                    ),
                  ),
                  /*Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: Sizes.width_2
                      ),
                      child: TextFormField(
                        controller: logic.addressModelList[index].distinct,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.start,
                        textInputAction: TextInputAction.done,
                        style: AppFontStyle.styleW500(CColor.black,( ?  sizesFontManageWeb(value constraints).sizesWidthManageWeb(130, constraints):: FontSize.size_10),
                        cursorColor: CColor.black,
                        decoration: InputDecoration(
                          hintText: logic.addressDistEnter,
                          border:InputBorder.none,
                        ),
                        onChanged:(value){
                          // logic.addressModelList[index].distinct = value;
                          Debug.printLog("addressDistEnter Ids........${value}");
                        },
                      ),
                    ),
                  ),*/
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2,
                      ),
                      child: const Divider(
                        color: CColor.black,
                        height: 2,
                      ),
                    ),
                  ),
                  /*Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: (kIsWeb) ? Sizes.width_3 : Sizes.width_2,
                      ),
                      child: const Divider(
                        color: CColor.black,
                        height: 2,
                      ),
                    ),
                  ),*/
                ],
              )
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(0.8, constraints):Sizes.width_2),
                      child: TextFormField(
                        controller: logic.addressModelList[index].state,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.start,
                        textInputAction: TextInputAction.done,
                        style: AppFontStyle.styleW500(
                            CColor.black,
                            (kIsWeb)
                                ?   AppFontStyle.sizesFontManageWeb(1.3, constraints)
                                : FontSize.size_10),
                        cursorColor: CColor.black,
                        decoration: InputDecoration(
                          hintText: logic.addressStateEnter,
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          // logic.addressModelList[index].state.text = value;
                          Debug.printLog(
                              "addressStateEnter Ids........${value}");
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(0.8, constraints):Sizes.width_2),
                      child: TextFormField(
                        controller: logic.addressModelList[index].pinCode,
                        keyboardType: Utils.getInputTypeKeyboard(),
                        textAlign: TextAlign.start,
                        textInputAction: TextInputAction.done,
                        style: AppFontStyle.styleW500(
                            CColor.black,
                            (kIsWeb)
                                ?   AppFontStyle.sizesFontManageWeb(1.3, constraints)
                                : FontSize.size_10),
                        cursorColor: CColor.black,
                        decoration: InputDecoration(
                          hintText: logic.addressCodeEnter,
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          // logic.addressModelList[index].pinCode.text = value;
                          Debug.printLog(
                              "addressCodeEnter Ids........${value}");
                        },
                      ),
                    ),
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         margin: EdgeInsets.symmetric(
              //           horizontal: (kIsWeb) ? Sizes.width_3 : Sizes.width_2,
              //         ),
              //         child: const Divider(
              //           color: CColor.black,
              //           height: 2,
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //       child: Container(
              //         margin: EdgeInsets.symmetric(
              //           horizontal: (kIsWeb) ? Sizes.width_3 : Sizes.width_2,
              //         ),
              //         child: const Divider(
              //           color: CColor.black,
              //           height: 2,
              //         ),
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ],
      ),
    )
        : Container();
  }

  Widget _widgetEmergencyPhoneNumberEditText(CreatePatientController logic,
      BuildContext context,BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: (kIsWeb)
                  ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                  : Sizes.height_3,
              right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
              left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(2.0, constraints)  :Sizes.width_4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Emergency contact",
                  style: AppFontStyle.styleW700(CColor.black,
                      (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                ),
              ),
              InkWell(
                onTap: () {
                  logic.addPhoneNumberList(Constant.emergencyPhoneNumberAdd);
                },
                child: Container(
                    margin: EdgeInsets.only(
                      right: (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(0.8, constraints) :Sizes.width_2,
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      size: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(2.0, constraints) : Sizes.width_7,
                    )),
              )
            ],
          ),
        ),
        ListView.builder(
          itemBuilder: (context, index) {
            return _itemEmergencyPhoneNum(index, logic, context,constraints);
          },
          shrinkWrap: true,
          itemCount: logic.emergencyContactModelList.length,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }

  _itemEmergencyPhoneNum(int index, CreatePatientController logic,
      BuildContext context,BoxConstraints constraints) {
    return logic.emergencyContactModelList.isNotEmpty
        ? Container(
      margin: EdgeInsets.symmetric(
        vertical: (kIsWeb)? AppFontStyle.sizesHeightManageWeb(1.0, constraints) : Sizes.height_1,
        horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3_5,
      ),
      decoration: BoxDecoration(
        color: CColor.greyF8,
        border: Border.all(color: CColor.primaryColor, width: 0.7),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          /*Container(
            margin: EdgeInsets.only(
                top: Sizes.height_2, right: Sizes.width_3, left: Sizes.width_4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Given name",
                    style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?FontSize.size_3:FontSize.size_10),
                  ),
                ),
                InkWell(
                  onTap: () {
                    logic.addGivenName(index);
                  },
                  child: Container(
                      margin: EdgeInsets.only(
                        right: Sizes.width_2,),
                      child: Icon(Icons.add_rounded,size: (kIsWeb) ? Sizes.width_2:Sizes.width_7,)),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: Sizes.width_5,vertical: Sizes.height_1_5
            ),
            decoration: BoxDecoration(
              color: CColor.transparent,
              border:Border.all(
                color: CColor.primaryColor, width: 0.7,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListView.builder(itemBuilder: (context, indexGiven) {
              return _itemGivenName(logic,index,indexGiven);
            },
              shrinkWrap: true,
              itemCount:logic.emergencyContactModelList[index].givenNameList.length,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ),*/
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      // height: Sizes.height_6,
                      margin: EdgeInsets.only(
                          top: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(0.7, constraints):Sizes.height_0_4,
                          right:(kIsWeb)?AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3,
                          left: (kIsWeb)?AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
                      decoration: const BoxDecoration(
                        color: CColor.transparent,
                      ),
                      child: TextFormField(
                        controller: logic.emergencyContactModelList[index]
                            .patientNameController,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.start,
                        textInputAction: TextInputAction.done,
                        autofocus: false,
                        style: AppFontStyle.styleW500(CColor.black,
                            (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : FontSize.size_10),
                        cursorColor: CColor.black,
                        decoration: InputDecoration(
                          hintText: logic.patientGpNameHint,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      logic.removeInList(Constant.emergencyPhoneNumberAdd,index);
                    },
                    child: Container(
                        margin: EdgeInsets.only(
                            right:(kIsWeb) ?AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3
                        ),
                        child: Icon(Icons.close,color: CColor.red,)),
                  )

                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_2,
                ),
                child: const Divider(
                  color: CColor.black,
                  height: 2,
                ),
              ),
              Container(
                // height: Sizes.height_6,
                margin: EdgeInsets.only(
                    top: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(0.7, constraints):Sizes.height_0_4,
                    right:(kIsWeb)?AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3,
                    left: (kIsWeb)?AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3),
                /*decoration: BoxDecoration(
              color: CColor.transparent,
              border:Border.all(
                color: CColor.primaryColor, width: 0.7,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),*/
                child: TextFormField(
                  controller: logic.emergencyContactModelList[index]
                      .phoneNumberController,
                  keyboardType: Utils.getInputTypeKeyboard(),
                  textAlign: TextAlign.start,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  textInputAction: TextInputAction.done,
                  autofocus: false,
                  style: AppFontStyle.styleW500(CColor.black,
                      (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                  cursorColor: CColor.black,
                  decoration: InputDecoration(
                    hintText: logic.emergencyPhoneNumberEnter,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    )
        : Container();
  }

  /*_itemGivenName( CreatePatientController logic,int index,int givenIndex){
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
              top: Sizes.height_0_8, right: Sizes.width_3, left: Sizes.width_3),
          child:  TextFormField(
            controller: logic.emergencyContactModelList[index].givenNameList[givenIndex].givenNameController,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.start,
            textInputAction: TextInputAction.done,
            autofocus: false,
            style: AppFontStyle.styleW500(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
            cursorColor: CColor.black,
            decoration: InputDecoration(
              hintText: logic.enterGivenName,
              border:InputBorder.none,
            ),
            onChanged:(value){
              Debug.printLog("givenName........${value}");
            },
          ),
        ),
        logic.emergencyContactModelList[index].givenNameList.length-1 != givenIndex ? Container(
          margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_3 : Sizes.width_2,
          ),
          child: const Divider(
            color: CColor.black,
            height: 2,
          ),
        ) : Container(),
      ],
    );
  }

  _widgetCommunicationDropDown(BuildContext context, CreatePatientController logic) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: Sizes.width_3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  bottom: Sizes.height_1,
                  top: Sizes.height_3,
                  left: Sizes.width_2),
              child: Text(
                "Communication",
                style: AppFontStyle.styleW700(
                  CColor.black,
                  (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_3,
                  vertical: Sizes.height_1_5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: CColor.greyF8,
                border: Border.all(color: CColor.primaryColor, width: 0.7),
              ),
              child: DropdownButtonFormField<String>(
                focusColor: Colors.white,
                decoration: const InputDecoration.collapsed(hintText: ''),
                  value: logic.selectedCommunication,
                style: const TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                items: Utils.communicationList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: AppFontStyle.styleW500(CColor.black,
                          (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
                    ),
                  );
                }).toList(),
                onChanged: (values){
                  logic.onChangesCommunication(values);
                },
              ),
            ),
          ],
        ),
      );
  }
*/

  _widgetGpEditText(CreatePatientController logic,
      BuildContext context,BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: (kIsWeb)
                  ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                  : Sizes.height_3,
              right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
              left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(2.0, constraints)  :Sizes.width_4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "General Practitioner (GP)",
                  style: AppFontStyle.styleW700(CColor.black,
                      (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                ),
              ),
              InkWell(
                onTap: () {
                  showDialogForProviderSearch(logic, context);
                  // logic.getListPractitioner();
                  // logic.addPhoneNumberList(Constant.gpAdd);
                },
                child: Container(
                    margin: EdgeInsets.only(
                      right: (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(0.8, constraints) :Sizes.width_2,
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      size: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(2.0, constraints)  : Sizes.width_7,
                    )),
              )
            ],
          ),
        ),
        /* ListView.builder(
          itemBuilder: (context, index) {
            return _itemGp(index, logic, context);
          },
          shrinkWrap: true,
          itemCount: logic.generalPractitionerList.length,
          physics: const NeverScrollableScrollPhysics(),
        ),*/
        if(logic.practitionerProfileListSelected.isNotEmpty)
        /*Container(
          margin: EdgeInsets.only(
            top: Sizes.height_1_5
          ),
          height: Sizes.height_6,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return _itemSelectedOnScreenItem(
                  index, context, logic);
            },
            itemCount: logic.practitionerProfileListSelected.length,
            padding: const EdgeInsets.all(0),
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
          ),
        ),*/
          _widgetSelectedGP(context, logic,constraints)
      ],
    );
  }

  _itemGp(int index, CreatePatientController logic, BuildContext context) {
    return logic.generalPractitionerList.isNotEmpty
        ? Container(
      margin: EdgeInsets.symmetric(
        vertical: Sizes.height_1,
        horizontal: (kIsWeb) ? Sizes.width_3 : Sizes.width_4,
      ),
      decoration: BoxDecoration(
        color: CColor.greyF8,
        border: Border.all(color: CColor.primaryColor, width: 0.7),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: Sizes.width_2),
            child: TextFormField(
              controller:
              logic.generalPractitionerList[index].gpNameController,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.start,
              textInputAction: TextInputAction.done,
              style: AppFontStyle.styleW500(CColor.black,
                  (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
              cursorColor: CColor.black,
              decoration: InputDecoration(
                hintText: logic.patientNameHintText,
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: (kIsWeb) ? Sizes.width_3 : Sizes.width_2,
            ),
            child: const Divider(
              color: CColor.black,
              height: 2,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: Sizes.width_2),
            child: TextFormField(
              controller:
              logic.generalPractitionerList[index].gpPhoneController,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.start,
              textInputAction: TextInputAction.done,
              style: AppFontStyle.styleW500(CColor.black,
                  (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
              cursorColor: CColor.black,
              decoration: InputDecoration(
                hintText: logic.patientGpPhoneHint,
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: (kIsWeb) ? Sizes.width_3 : Sizes.width_2,
            ),
            child: const Divider(
              color: CColor.black,
              height: 2,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: Sizes.width_2),
            child: TextFormField(
              controller:
              logic.generalPractitionerList[index].gpFaxController,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.start,
              textInputAction: TextInputAction.done,
              style: AppFontStyle.styleW500(CColor.black,
                  (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
              cursorColor: CColor.black,
              decoration: InputDecoration(
                hintText: logic.patientGpFaxHint,
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: (kIsWeb) ? Sizes.width_3 : Sizes.width_2,
            ),
            child: const Divider(
              color: CColor.black,
              height: 2,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: Sizes.width_2),
            child: TextFormField(
              controller:
              logic.generalPractitionerList[index].gpEmailController,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.start,
              textInputAction: TextInputAction.done,
              style: AppFontStyle.styleW500(CColor.black,
                  (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
              cursorColor: CColor.black,
              decoration: InputDecoration(
                hintText: logic.patientGpEmailHint,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    )
        : Container();
  }

  void showDialogForProviderSearch(CreatePatientController logic,
      BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setStateDialog) {
            // logic.getListPractitioner(setStateDialog);
            // setStateDialog((){});
            return AlertDialog(
              backgroundColor: CColor.white,
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              content: SingleChildScrollView(
                child: Container(
                  width: Get.width * 0.8,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      color: CColor.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: Sizes.height_0_8,
                            right: Sizes.width_3,
                            left: Sizes.width_1_5,
                            bottom: Sizes.height_1),
                        decoration: BoxDecoration(
                          color: CColor.transparent,
                          border: Border.all(
                            color: CColor.primaryColor, width: 0.7,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: TextFormField(
                          controller: logic.searchProviderControllers,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.start,
                          focusNode: logic.searchProviderFocus,
                          textInputAction: TextInputAction.done,
                          style: AppFontStyle.styleW500(
                              CColor.black,
                              (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
                          cursorColor: CColor.black,
                          decoration: const InputDecoration(
                            hintText: "Search Name",
                            filled: true,
                            border: InputBorder.none,
                          ),
                          onChanged: (value) async {
                            await logic.getListPractitioner(setStateDialog: setStateDialog);
                            setStateDialog(() {});
                          },
                        ),
                      ),
                      if(logic.practitionerProfileListSelected.isNotEmpty)
                      _widgetSelectedGPDialog(context, logic) /*:
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            bottom: Sizes.height_1_5
                        ),
                        child: Text(
                          "No selected user found",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: CColor.black,
                              fontSize: FontSize.size_12),
                        ),
                      ),*/,
                      SizedBox(
                        height: Sizes.height_30,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return _itemSearchProvider(
                                index, context, logic, setStateDialog);
                          },
                          itemCount: logic.practitionerProfileList.length,
                          padding: const EdgeInsets.all(0),
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: Sizes.height_2),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      CColor.transparent),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: const BorderSide(
                                          color: CColor.primaryColor,
                                          width: 0.7),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    "Cancel",
                                    textAlign: TextAlign.center,
                                    style: AppFontStyle.styleW400(
                                        CColor.black, FontSize.size_12),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: Sizes.width_2),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  logic.update();
                                  Get.back();
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      CColor.primaryColor),
                                  elevation: MaterialStateProperty.all(1),
                                  shadowColor:
                                  MaterialStateProperty.all(CColor.gray),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: const BorderSide(
                                          color: CColor.primaryColor,
                                          width: 0.7),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    "ok",
                                    textAlign: TextAlign.center,
                                    style: AppFontStyle.styleW400(
                                        CColor.white, FontSize.size_12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((value) =>
    {
      logic.searchProviderControllers.clear(),
    });
  }

  _itemSearchProvider(int index, BuildContext context,
      CreatePatientController logic, setStateDialog) {
    return (logic.practitionerProfileList.isNotEmpty) ?
    InkWell(
      onTap: () {
        setStateDialog(() {
          logic.onChangeSelectAndNotSelectedValue(index);
        });
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: Sizes.width_2,
                top: Sizes.height_1_5,
                bottom: Sizes.height_0_5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        logic.practitionerProfileList[index].fName,
                        style: AppFontStyle.styleW700(
                          CColor.black,
                          // : CColor.black,
                          (kIsWeb) ? FontSize.size_3 : FontSize.size_11,
                        ),
                      ),
                      Text(
                        logic.practitionerProfileList[index].dob,
                        style: AppFontStyle.styleW500(
                          CColor.primaryColor,
                          // : CColor.black,
                          (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      right: Sizes.width_2
                  ),
                  child: Checkbox(
                      value: logic.practitionerProfileList[index].isSelected,
                      onChanged: (value) {
                        setStateDialog(() {
                          logic.onChangeSelectAndNotSelectedValue(index);
                        });
                      }),
                )
              ],
            ),
          ),
          const Divider(height: 1, color: CColor.black,)
        ],
      ),
    ) : (!logic.isShowProgress) ?
    Container(
      alignment: Alignment.center,
      child: Text(
        "No user found",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: CColor.black,
            fontSize: FontSize.size_10),
      ),
    ) : Container();
  }

  _itemSelectedItem(int index, BuildContext context,
      CreatePatientController logic, setStateDialog) {
    return (logic.practitionerProfileListSelected.isNotEmpty) ?
    Container(
      padding: EdgeInsets.symmetric(
          horizontal: Sizes.width_2,
          vertical: Sizes.height_1
      ),
      margin: EdgeInsets.only(bottom: Sizes.height_3, left: Sizes.width_2),
      decoration: BoxDecoration(
        color: CColor.primaryColor10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        logic.practitionerProfileListSelected[index].fName,
        style: AppFontStyle.styleW500(
          CColor.primaryColor,
          // : CColor.black,
          (kIsWeb) ? FontSize.size_3 : FontSize.size_12,
        ),
      ),
    ) :
    Container(
      alignment: Alignment.center,
      child: Text(
        "No Selected user found",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: CColor.black,
            fontSize: FontSize.size_7),
      ),
    );
  }

  _itemSelectedOnScreenItem(int index, BuildContext context,
      CreatePatientController logic) {
    return (logic.practitionerProfileListSelected.isNotEmpty) ?
    Container(
      padding: EdgeInsets.symmetric(
          horizontal: Sizes.width_2,
          vertical: Sizes.height_1
      ),
      margin: EdgeInsets.only(bottom: Sizes.height_1, left: Sizes.width_2),
      decoration: BoxDecoration(
        color: CColor.primaryColor10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        logic.practitionerProfileListSelected[index].fName,
        style: AppFontStyle.styleW500(
          CColor.primaryColor,
          // : CColor.black,
          (kIsWeb) ? FontSize.size_3 : FontSize.size_12,
        ),
      ),
    ) :
    Container(
      alignment: Alignment.center,
      child: Text(
        "No Selected user found",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: CColor.black,
            fontSize: FontSize.size_7),
      ),
    );
  }

  _widgetSelectedGP(BuildContext context, CreatePatientController logic,BoxConstraints constraints) {
    return Container(
        margin: EdgeInsets.only(
          top: Get.height * 0.02,
          left: Get.width * 0.04,
          right: Get.width * 0.04,
        ),
        child: logic.practitionerProfileListSelected.isNotEmpty
            ? Wrap(
          runSpacing: -5,
          children: List<Widget>.generate(
            logic.practitionerProfileListSelected.length,
                (int index) {
              return Container(
                margin: EdgeInsets.only(
                  bottom: Sizes.height_1,
                  left: Sizes.width_2,
                ),
                child: Chip(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.all(5),
                  backgroundColor: CColor.primaryColor10,
                  onDeleted: () {
                    Debug.printLog("Deleted Item Index...$index");
                    logic.onChangeRemoveSelectedId(index);
                  },
                  label: Text(
                    overflow: TextOverflow.ellipsis,
                    logic.practitionerProfileListSelected[index].fName,
                    style: AppFontStyle.styleW500(
                      CColor.primaryColor,
                      (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_12,
                    ),
                  ),
                ),
              );
            },
          ),
        )

            : Container());
  }

  _widgetSelectedGPDialog(BuildContext context, CreatePatientController logic) {
    return Container(
      /* margin: EdgeInsets.only(
          top: Get.height * 0.02,
          left: Get.width * 0.04,
          right: Get.width * 0.04,
        ),*/
        child: logic.practitionerProfileListSelected.isNotEmpty
            ? Wrap(
          runSpacing: -10,
          children: List<Widget>.generate(
              logic.practitionerProfileListSelected.length, (int index) {
            return Container(
              margin: EdgeInsets.only(
                  bottom: Sizes.height_1, left: Sizes.width_2),
              child: Chip(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      )),
                  padding: const EdgeInsets.all(3),
                  backgroundColor: CColor.primaryColor10,
                  label: Text(
                    logic.practitionerProfileListSelected[index].fName,
                    style: AppFontStyle.styleW500(
                      CColor.primaryColor,
                      (kIsWeb) ? FontSize.size_3 : FontSize.size_10,
                    ),
                  )),
            );
          }),
        )
            : Container());
  }
}
