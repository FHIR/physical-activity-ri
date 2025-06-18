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
import '../controllers/create_Practitioner_controller.dart';

class CreatePractitionerScreen extends StatelessWidget {
  const CreatePractitionerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          useMaterial3: false
      ),

      child: GetBuilder<CreatePractitionerController>(builder: (logic) {
        return Scaffold(
          backgroundColor: CColor.white,
          appBar: AppBar(
            backgroundColor: CColor.primaryColor,
            title: Text((logic.isEdited)?"Update Provider":"Create Provider"),
          ),
          body: LayoutBuilder(
            builder: (BuildContext context,BoxConstraints constraints) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: GetBuilder<CreatePractitionerController>(builder: (logic) {
                    return Column(
                      children: [
                        _widgetFirstNameEnterText(logic, context,constraints),
                        _widgetLastNameEnterText(logic,constraints),
                        _widgetDOB(logic, context,constraints),
                        _widgetGenderSelectionDropDown(context, logic,constraints),
                        _widgetPhoneNumberEditText(logic, context,constraints),
                        _widgetEmailAddressEditText(logic, context,constraints),
                        _widgetMailingAddressEditText(logic, context,constraints),
                        // _widgetQualificationEditText(logic, context),
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
                    );
                  }),
                ),
              );
            }
          ),
        );
      }),
    );
  }

  _widgetFirstNameEnterText(
      CreatePractitionerController logic, BuildContext context,BoxConstraints constraints) {
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
                      (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                ),
              ),
              InkWell(
                onTap: () {
                  logic.addItemsList(Constant.firstNameAdd);
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

  Widget itemFirstName(CreatePractitionerController logic, int index,BoxConstraints constraints) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(
                  top: (kIsWeb)
                    ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                    : Sizes.height_1,
                right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
                left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3),
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
                  CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
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

  Widget _widgetLastNameEnterText(CreatePractitionerController logic,BoxConstraints constraints) {
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
                  CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
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
                CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
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

  Widget _widgetDOB(CreatePractitionerController logic, BuildContext context,BoxConstraints constraints) {
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
                  CColor.black, (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.3, constraints)  : FontSize.size_10),
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

  Future<void> showDatePickerDialog(CreatePractitionerController logic,
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
      child: GetBuilder<CreatePractitionerController>(builder: (logic) {
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
              logic.insertPractitioner(context);
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
                (logic.isEdited) ? "Update" : "Create",
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
      CreatePractitionerController logic,BoxConstraints constraints) {
    return GetBuilder<CreatePractitionerController>(builder: (logic) {
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
                  (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10,
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

  Widget  _widgetPhoneNumberEditText(
      CreatePractitionerController logic,
      BuildContext context,BoxConstraints constraints
      ) {
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
                      (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                ),
              ),
              InkWell(
                onTap: () {
                  logic.addItemsList(Constant.phoneNumberAdd);
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
            return _itemPhoneNum(index, logic, context,constraints);
          },
          shrinkWrap: true,
          itemCount: logic.phoneNumberList.length,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }

  _itemPhoneNum(
      int index, CreatePractitionerController logic, BuildContext context,BoxConstraints constraints) {
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

  _widgetQualificationEditText(
      CreatePractitionerController logic,
      BuildContext context,BoxConstraints constraints
      ) {
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
                  "Qualification",
                  style: AppFontStyle.styleW700(CColor.black,
                      (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                ),
              ),
              InkWell(
                onTap: () {
                  logic.addItemsList(Constant.qualificationAdd);
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
        Container(
          // margin: EdgeInsets.only(top: Sizes.height_3),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _itemQualification(index, logic, context,constraints);
            },
            shrinkWrap: true,
            itemCount: logic.qualificationIdModelList.length,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ),

      ],
    );
  }

/*  _widgetQualificationEditText(CreatePractitionerController logic,
      BuildContext context,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: Sizes.height_3),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _itemQualification(index, logic, context);
            },
            shrinkWrap: true,
            itemCount: logic.qualificationIdModelList.length,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ),
        InkWell(
          onTap: () {
            logic.addItemsList(Constant.qualificationAdd);
          },
          child: Container(
            margin: EdgeInsets.only(
                right: Sizes.width_5,
                top: Sizes.height_1
            ),
            alignment: Alignment.centerRight,
            *//*child: Icon(
                Icons.add_rounded,
                                      size: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(2.0, constraints) : Sizes.width_7,

              ),*//*
            child: const Text(
              "+Add",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: CColor.primaryColor,
              ),
            ),
          ),
        )
      ],
    );
  }*/

  _itemQualification(int index, CreatePractitionerController logic,
      BuildContext context,BoxConstraints constraints) {
    return logic.qualificationIdModelList.isNotEmpty ?

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
        controller: logic.qualificationIdModelList[index]
            .qualificationIdControllers,
        keyboardType: TextInputType.text,
        textAlign: TextAlign.start,
        textInputAction: TextInputAction.done,
        autofocus: false,
        style: AppFontStyle.styleW500(
            CColor.black,                         (kIsWeb) ?   AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),

        cursorColor: CColor.black,
        decoration: InputDecoration(
          hintText: logic.qualificationEnter,
          filled: true,
          border: InputBorder.none,
        ),
        onChanged: (value) {
          logic.qualificationIdModelList[index].qualificationId = value;
          Debug.printLog("email Ids........${value}");
        },
      ),
    )
    /*Container(
      margin: EdgeInsets.only(
            top: (kIsWeb)
                    ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                    : Sizes.height_1,
                right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints):  Sizes.width_3,
                left: (kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.0, constraints)  :Sizes.width_3),
      child: TextFormField(
        controller: logic.qualificationIdModelList[index]
            .qualificationIdControllers,
        textAlign: TextAlign.start,
        keyboardType: TextInputType.text,
        onChanged: (value) {
          logic.qualificationIdModelList[index].qualificationId = value;
          Debug.printLog("qualification Ids........$value");
        },
        autofocus: false,
        style: AppFontStyle.styleW500(
            CColor.black,                         (kIsWeb) ?   AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),

        cursorColor: CColor.black,
        decoration: InputDecoration(
          // hintText: "Enter your description".tr,
          filled: true,
          contentPadding: EdgeInsets.only(
              left: Sizes.width_3, right: Sizes.width_3),
          labelStyle: const TextStyle(
              color: CColor.darkGray
          ),
          labelText: "Qualification",
          border: OutlineInputBorder(
            borderSide:
            const BorderSide(color: CColor.primaryColor, width: 0.7),
            borderRadius: BorderRadius.circular(15.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
            const BorderSide(color: CColor.primaryColor, width: 0.7),
            borderRadius: BorderRadius.circular(15.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide:
            const BorderSide(color: CColor.primaryColor, width: 0.7),
            borderRadius: BorderRadius.circular(15.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
            const BorderSide(color: CColor.primaryColor, width: 0.7),
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
    )*/ : Container();
  }

  _widgetMailingAddressEditText(
      CreatePractitionerController logic,
      BuildContext context,BoxConstraints constraints
      ) {
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
                      (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),
                ),
              ),
              InkWell(
                onTap: () {
                  logic.addItemsList(Constant.addAddressAdd);
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
            return _itemAddress(index, logic, context,constraints);
          },
          shrinkWrap: true,
          itemCount: logic.addressModelList.length,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }

  _itemAddress(int index, CreatePractitionerController logic, BuildContext context,BoxConstraints constraints) {
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
                  style: AppFontStyle.styleW700(CColor.black, (kIsWeb)?FontSize.size_3:FontSize.size_10),
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
                      Debug.printLog("email Ids........${value}");
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
                            (kIsWeb) ?   AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),

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
                        style: AppFontStyle.styleW500(CColor.black,(kIsWeb)?FontSize.size_3: FontSize.size_10),
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
                            (kIsWeb) ?   AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),

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
                            (kIsWeb) ?   AppFontStyle.sizesFontManageWeb(1.3, constraints) : FontSize.size_10),

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

  _widgetEmailAddressEditText(
      CreatePractitionerController logic,
      BuildContext context,BoxConstraints constraints
      ) {
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

              /*InkWell(
                onTap: () {
                  logic.addItemsList(Constant.emailIdAdd);
                },
                child: Container(
                    margin: EdgeInsets.only(
                      right: (kIsWeb)  ? AppFontStyle.sizesFontManageWeb(0.8, constraints) :Sizes.width_2,
                    ),
                    child: Icon(
                      Icons.add_rounded,
                                            size: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(2.0, constraints) : Sizes.width_7,

                    )),
              )*/
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

  _itemEmail(int index, CreatePractitionerController logic, BuildContext context,BoxConstraints constraints) {
    return logic.emailIdModelList.isNotEmpty
        ? Container(
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
        // enabled: logic.isEdited ? false :true,
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
    )
        : Container();
  }

}
