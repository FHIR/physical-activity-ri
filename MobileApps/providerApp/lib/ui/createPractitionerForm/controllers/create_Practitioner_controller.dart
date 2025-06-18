
import 'package:banny_table/dataModel/patientDataModel.dart';
import 'package:banny_table/db_helper/box/referral_data.dart';
import 'package:banny_table/db_helper/box/to_do_form_data.dart';
import 'package:banny_table/ui/createPatientForm/datamodel/createPatientDataModel.dart';
import 'package:banny_table/ui/patientIndependentMode/controllers/patient_independent_controller.dart';
import 'package:banny_table/ui/toDoList/dataModel/codeModel.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:fhir/r4.dart';
import 'package:fhir/r4/general_types/general_types.dart';
import 'package:fhir/r4/resource_types/base/individuals/individuals.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../resources/PaaProfiles.dart';


class CreatePractitionerController extends GetxController {
  // var selectedVerificationStatus = "";
  // var status = "";
  // var selectedDisplay = "";
  // var selectedCode = "";
  String selectedGender = "";
  // String selectedPriority = "";
  String selectedAddressType = "";
  String selectedPhoneNoType = "";
  String selectedCommunication = "";
  List<FirstNameModel> firstNameModelList = [];
  List<PhoneNumberListModel> phoneNumberList = [];
  List<QualificationIdModel> qualificationIdModelList = [];
  List<AddressModel> addressModelList = [];
  List<EmailIdModel> emailIdModelList = [];



  String selectTextFirst = "Please enter reason";
  String businessStatusFocusText = "Please enter business Status";

  TextEditingController addNewCodeController = TextEditingController();
  FocusNode addNewCodeFocus = FocusNode();
  TextEditingController statusReason = TextEditingController();
  TextEditingController businessStatus = TextEditingController();
  // var editedToDoData = ToDoTableData();
  var arguments = Get.arguments;
  var isEdited = false;
  String providerId = "";
  bool isProgress = false;
  FocusNode statusReasonFocus = FocusNode();
  FocusNode businessStatusFocus = FocusNode();

  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode dobFocus = FocusNode();
  FocusNode genderFocus = FocusNode();

  // TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  String firstNameFocusText = "";
  String phoneNumberEnter = "Please enter a phone number";
  String lastNameFocusText = "";
  String dobFocusText = "";
  String emailIdsEnter = "";
  // String QualificationEnter = "Please enter Qualification";
  String qualificationEnter = "";
  String address1Enter = "Line 1";
  String address2Enter = "Line 2";
  String addressCityEnter = "City";
  String addressDistEnter = "District";
  String addressStateEnter = "State";
  String addressCodeEnter = "PostalCode";
  String emergencyPhoneNumberEnter = "Please enter a Emergency contact";
  String enterGivenName = "Please enter a Given Name";
  String nameEnter = "Please Enter a First Name";
  String patientGpNameHint = "Please Enter a Name";
  String patientNameHintText = "Please Enter a Name";
  String patientGpPhoneHint = "Please Enter a Contact";
  String patientGpFaxHint = "Please Enter a Fax";
  String patientGpEmailHint = "Please Enter a Email";
  PatientDataModel practitionerData = PatientDataModel();
  // ReferralData referralEditedData = ReferralData();
  var selectedDateFormat = DateTime.now();
  var selectedDateStr = "";

  @override
  void onInit() {
    if (arguments != null) {
      if (arguments[0] != null) {
        ///Get practitioner data
        practitionerData = arguments[0];
        getAndSetData(practitionerData);
      } else {
        addSingleEntry();
        // status = Utils.todoStatusList[0];
        // selectedPriority = Utils.priorityList[0];
        // selectedDisplay = Utils.codeTodoList[0].display;
        // selectedCode = Utils.codeTodoList[0].code ?? "";
        selectedGender = Utils.genderList[0];
        selectedAddressType =Utils.addressType[0];
        selectedCommunication =Utils.communicationList[0];
        selectedPhoneNoType =Utils.phoneNoType[0];
      }
    } else {
      addSingleEntry();
      // status = Utils.todoStatusList[0];
      // selectedPriority = Utils.priorityList[0];
      // selectedDisplay = Utils.codeTodoList[0].display;
      // selectedCode = Utils.codeTodoList[0].code ?? "";
      selectedGender = Utils.genderList[0];
      selectedAddressType =Utils.addressType[0];
      selectedCommunication =Utils.communicationList[0];
      selectedPhoneNoType =Utils.phoneNoType[0];
    }
    Debug.printLog("Primary data.....${Utils.getPrimaryServerData()}");
    super.onInit();
  }

  addSingleEntry(){
    firstNameModelList.add(FirstNameModel());
    // phoneNumberList.add(PhoneNumberListModel());
    emailIdModelList.add(EmailIdModel());
    // phoneNumberList[phoneNumberList.length -1].phoneNumber = Utils.phoneNoType[0];
    // qualificationIdModelList.add(QualificationIdModel());
    // addressModelList.add(AddressModel());
    // addressModelList[addressModelList.length -1].addressType = Utils.addressType[0];
  }

  insertPractitioner(BuildContext context) async {
    if(emailIdModelList[0].emailIdControllers.text != ""){
      isProgress = true;
      if(isProgress) {
        Utils.showDialogForProgress(Get.context!, Constant.txtPleaseWait, Constant.txtPractitionerDataProgress);
      }
      List<String> firstNamesList = [];
      var lastName = lastNameController.text.toString().trim();
      var dob = dobController.text.toString().trim();
      var gender = selectedGender;
      List<PractitionerQualification> qualificationList = [];
      List<ContactPoint> contactPointPhoneList = [];
      List<Address> addressList = [];
      List<Reference> referenceList = [];
      ///Add a FirstName MultiPle List
      for(int i = 0 ;i<firstNameModelList.length;i++){
        firstNamesList.add(firstNameModelList[i].firstNameController.text.toString().trim());
      }
      for(int i = 0 ;i<phoneNumberList.length;i++){
        ContactPoint contactPoint = ContactPoint(
          system: ContactPointSystem.phone,
          value: phoneNumberList[i].phoneNumberController.text.toString().trim(),
          use: (phoneNumberList[i].phoneNumber == Constant.phoneNoTypeHome)? ContactPointUse.home:
          (phoneNumberList[i].phoneNumber == Constant.phoneNoTypeMobile)? ContactPointUse.mobile : ContactPointUse.work,
        );
        contactPointPhoneList.add(contactPoint);
      }
      for(int i = 0 ;i<qualificationIdModelList.length;i++){
        PractitionerQualification qualification = PractitionerQualification(
            code: CodeableConcept(coding: [
              Coding(
                  code: Code(qualificationIdModelList[i]
                      .qualificationIdControllers
                      .text
                      .toString().trim()))
            ])) ;
        qualificationList.add(qualification);
      }
      for(int i=0;i<addressModelList.length;i++){
        Address address = Address(
          type:(addressModelList[i].addressType == Constant.addressTypeResidence)? AddressType.physical:
          (addressModelList[i].addressType == Constant.addressTypeMailing)?AddressType.postal:AddressType.both,
          line: [
            addressModelList[i].address1.text.toString().trim(),
            addressModelList[i].address2.text.toString().trim()
          ],
          city: addressModelList[i].city.text.toString().trim(),
          state: addressModelList[i].state.text.toString().trim(),
          postalCode: addressModelList[i].pinCode.text.toString(),
        );
        addressList.add(address);
      }
      for(int i = 0 ;i<emailIdModelList.length;i++){
        ContactPoint contactPoint = ContactPoint(
          system: ContactPointSystem.email,
          value: emailIdModelList[i].emailIdControllers.text.toString().trim(),
        );
        contactPointPhoneList.add(contactPoint);
      }

      var data = CreatePatientDataModel();
      data.firstNameList = firstNamesList.toList();
      data.lName = lastName;
      data.dob = dob;
      data.gender = gender;
      data.phoneNumbersList = contactPointPhoneList;
      data.addressList = addressList;
      data.referenceList = referenceList;
      // data.qualificationList = qualificationList;

      PaaProfiles profiles = PaaProfiles();
      Practitioner practitioner;
      if(isEdited){
        practitioner = profiles.createPractitioner(data,providerId);
      }else{
        practitioner = profiles.createPractitioner(data,"");
      }

      var patientId = await profiles.processCreatePractitioner(practitioner,providerId);
      Debug.printLog("providerId....$patientId");
      if(isProgress){
        Get.back();
      }
      String name = "";
      if(patientId == "null" || patientId == null){
        patientId = "";
        if(data.firstNameList.isNotEmpty){
          name = data.firstNameList[0];
        }
      }
      if(isEdited){
        if(context.mounted)Utils.showToast(context, "Provider updated successfully");
      }else{
        if(context.mounted)Utils.showToast(context, "Provider created successfully");
      }

      PatientDataModel patientDataModel = PatientDataModel();
      patientDataModel.patientId = patientId;
      patientDataModel.givenNameList = data.firstNameList;
      patientDataModel.fName = firstNamesList[0];
      patientDataModel.lName = lastNameController.text.toString().trim();
      patientDataModel.dob = data.dob;
      patientDataModel.gender = data.gender;
      patientDataModel.isSelected = false;
      List<PhoneNumberListModelLocal>  phoneNoList = [];
      ///Phone No
      for (int i = 0; i < phoneNumberList.length; i++) {
        PhoneNumberListModelLocal phoneNumberListModelLocal = PhoneNumberListModelLocal();
        phoneNumberListModelLocal.phoneNumberController.text =  phoneNumberList[i].phoneNumberController.text.toString().trim();
        phoneNumberListModelLocal.phoneUse = (phoneNumberList[i].phoneNumber == Constant.phoneNoTypeHome)
            ? ContactPointUse.home
            :
        (phoneNumberList[i].phoneNumber == Constant.phoneNoTypeMobile)
            ? ContactPointUse.mobile
            : ContactPointUse.work;
        phoneNumberListModelLocal.phoneSystemType = ContactPointSystem.phone;
        phoneNoList.add(phoneNumberListModelLocal);
      }

      patientDataModel.phoneNoList = phoneNoList;

      ///Email Addresss
      List<EmailIdModelLocal>  emailIdList = [];
      for (int i = 0; i < emailIdModelList.length; i++) {
        EmailIdModelLocal emailIdModelLocal =EmailIdModelLocal();
        emailIdModelLocal.emailIdType = ContactPointSystem.email;
        emailIdModelLocal.emailIdControllers.text = emailIdModelList[i].emailIdControllers.text.toString().trim();
        emailIdList.add(emailIdModelLocal);
      }
      patientDataModel.emailIdList = emailIdList;

      List<AddressModelLocal>  addressModelLists = [];

      for (int i = 0; i < addressModelList.length; i++) {
        AddressModelLocal addressModelLocal = AddressModelLocal();
        addressModelLocal.addressType = (addressModelList[i].addressType ==
            Constant.addressTypeResidence) ? AddressType.physical :
        (addressModelList[i].addressType == Constant.addressTypeMailing)
            ? AddressType.postal
            : AddressType.both;
        addressModelLocal.pinCode.text =  addressModelList[i].pinCode.text.toString().trim();
        addressModelLocal.city.text =  addressModelList[i].city.text.toString().trim();
        addressModelLocal.state.text = addressModelList[i].state.text.toString().trim();
        addressModelLocal.address1.text = addressModelList[i].address1.text.toString().trim();
        addressModelLocal.address2.text = addressModelList[i].address2.text.toString().trim();
        addressModelLocal.distinct.text = addressModelList[i].distinct.text.toString().trim();
        addressModelLists.add(addressModelLocal);
      }
      patientDataModel.addressModelList = addressModelLists;




      PatientIndependentController patientIndependentController = Get.find();
      if(patientIndependentController.practitionerProfileList.where((element) => element.patientId == patientId).toList().isEmpty){
        patientIndependentController.practitionerProfileList.insert(0,patientDataModel);
        patientIndependentController.updateMethod();
      }else{
        int index = patientIndependentController.practitionerProfileList.indexWhere((element) => element.patientId == patientId).toInt();
        if(index != -1){
          patientIndependentController.practitionerProfileList[index] = patientDataModel;
          patientIndependentController.updateMethod();
        }
      }
      Get.back();


      // await getCallApi(patientId,name);
      // Get.back();
    }
    else{
      Utils.showToast(context, "Please Enter a Email Id");
    }

  }

/*  getCallApi(String id,String name) {
    PatientIndependentController patientIndependentController = Get.find();
    patientIndependentController.getListPractitioner(isBack: true,valueId: id,valueName: name);
  }*/

  // void onChangeStatus(String value) {
  //   status = value;
  //   update();
  // }

  // void onChangePriority(String? value) {
  //   selectedPriority = value ?? "";
  //   update();
  // }

  // void onChangeCode(int index) {
  //   selectedDisplay =Utils.codeTodoList[index].display;
  //   selectedCode = Utils.codeTodoList[index].code ?? "";
  //   Get.back();
  //   update();
  // }

/*
  void addNewCodeDataIntoList(String displayAdd) {
    Utils.codeTodoList.add(CodeToDoModel(display: displayAdd));
    Get.back();
    addNewCodeController.clear();
    update();
  }
*/

  void onSelectionChangedDatePicker(DateRangePickerSelectionChangedArgs args) {
    selectedDateFormat = args.value;
    selectedDateStr = DateFormat(Constant.commonDateFormatDdMmYyyy)
        .format(selectedDateFormat);
    dobController.text = selectedDateStr;
    update();
  }

  onChangeGender(value){
    selectedGender = value;
    update();
  }

  addItemsList(String values){
    if(values == Constant.phoneNumberAdd){
      phoneNumberList.add(PhoneNumberListModel());
      phoneNumberList[phoneNumberList.length -1].phoneNumber = Utils.phoneNoType[0];
    }else if(values == Constant.qualificationAdd){
      qualificationIdModelList.add(QualificationIdModel());
    }else if(values == Constant.addAddressAdd) {
      addressModelList.add(AddressModel());
      addressModelList[addressModelList.length -1].addressType = Utils.addressType[0];
    }else if(values ==Constant.firstNameAdd ){
      firstNameModelList.add(FirstNameModel());
    }else if(values ==Constant.emailIdAdd){
      emailIdModelList.add(EmailIdModel());
    }
    update();
  }

  onChangesAddressType(value,int index){
    selectedAddressType = value;
    addressModelList[index].addressType = value;
    update();
  }
  onChangesPhoneNoType(value,int index){
    selectedPhoneNoType = value;
    phoneNumberList[index].phoneNumber = value;
    update();
  }
  onChangesCommunication(value){
    selectedCommunication = value;
    update();
  }


  void onChangeAddFirstName(String values,int index) {
    firstNameModelList[index].firstName = values;
    update();
  }

  void getAndSetData(PatientDataModel practitionerData) {
    Debug.printLog("getAndSetData...$practitionerData");
    isEdited = true;
    providerId = practitionerData.patientId;
    selectedGender = practitionerData.gender;
    lastNameController.text = practitionerData.lName;
    dobController.text = practitionerData.dob;
    genderController.text = selectedGender;

    if (practitionerData.givenNameList.isNotEmpty) {
      for (int i = 0; i < practitionerData.givenNameList.length; i++) {
        var data = FirstNameModel();
        data.firstName = practitionerData.givenNameList[i];
        data.firstNameController.text = practitionerData.givenNameList[i];
        firstNameModelList.add(data);
      }
    } else {
      firstNameModelList.add(FirstNameModel());
    }

    if (practitionerData.phoneNoList.isNotEmpty) {
      for (int i = 0; i < practitionerData.phoneNoList.length; i++) {
        PhoneNumberListModel phoneNumberListModel = PhoneNumberListModel();
        if (practitionerData.phoneNoList[i].phoneUse == ContactPointUse.home) {
          phoneNumberListModel.phoneNumber = Constant.phoneNoTypeHome;
        } else if (practitionerData.phoneNoList[i].phoneUse ==
            ContactPointUse.mobile) {
          phoneNumberListModel.phoneNumber = Constant.phoneNoTypeMobile;
        } else {
          phoneNumberListModel.phoneNumber = Constant.phoneNoTypeWork;
        }
        phoneNumberListModel.phoneNumberController.text =
            practitionerData.phoneNoList[i].phoneNumberController.text;
        phoneNumberList.add(phoneNumberListModel);
      }
    } else {
      phoneNumberList.add(PhoneNumberListModel());
      phoneNumberList[phoneNumberList.length - 1].phoneNumber =
          Utils.phoneNoType[0];
    }

    if (practitionerData.qualificationDataList.isNotEmpty) {
      for (int i = 0; i < practitionerData.qualificationDataList.length; i++) {
        QualificationIdModel qualificationDataClass = QualificationIdModel();
        qualificationDataClass.qualificationId =
            practitionerData.qualificationDataList[i].codeText;
        qualificationDataClass.qualificationIdControllers.text =
            practitionerData.qualificationDataList[i].codeText;
        qualificationIdModelList.add(qualificationDataClass);
      }
    } else {
      qualificationIdModelList.add(QualificationIdModel());
    }

    /// Email
    if(practitionerData.emailIdList.isNotEmpty){
      for(int i =0;i<practitionerData.emailIdList.length;i++){
        EmailIdModel emailIdModel  = EmailIdModel();
        emailIdModel.emailId =  Constant.emailType;
        emailIdModel.emailIdControllers.text = practitionerData.emailIdList[i].emailIdControllers.text;
        emailIdModelList.add(emailIdModel);
      }
    }else{
      emailIdModelList.add(EmailIdModel());
    }

    if (practitionerData.addressModelList.isNotEmpty) {
      for (int i = 0; i < practitionerData.addressModelList.length; i++) {
        AddressModel addressModel = AddressModel();
        addressModel.address1 = practitionerData.addressModelList[i].address1;
        addressModel.address2 = practitionerData.addressModelList[i].address2;
        addressModel.city = practitionerData.addressModelList[i].city;
        addressModel.state = practitionerData.addressModelList[i].state;
        addressModel.pinCode = practitionerData.addressModelList[i].pinCode;
        if (practitionerData.addressModelList[i].addressType ==
            AddressType.physical) {
          addressModel.addressType = Constant.addressTypeResidence;
        } else if (practitionerData.addressModelList[i].addressType == AddressType.postal){
          addressModel.addressType = Constant.addressTypeMailing;
        } else {
          addressModel.addressType = Constant.addressTypeBoth;
        }
        addressModelList.add(addressModel);
      }
    } else {
      addressModelList.add(AddressModel());
      addressModelList[addressModelList.length - 1].addressType =
          Utils.addressType[0];
    }
  }


  removeInList(String values,int index){
    if(values == Constant.phoneNumberAdd){
      phoneNumberList.removeAt(index);
    }else if(values == Constant.emailIdAdd){
      emailIdModelList.removeAt(index);
    }else if(values == Constant.addAddressAdd) {
      addressModelList.removeAt(index);
    }else if(values ==Constant.firstNameAdd ){
      firstNameModelList.removeAt(index);
    }
    update();
  }
}
