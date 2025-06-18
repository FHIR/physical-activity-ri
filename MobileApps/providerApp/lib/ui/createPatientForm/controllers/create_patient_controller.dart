
import 'dart:async';

import 'package:banny_table/dataModel/patientDataModel.dart';
import 'package:banny_table/db_helper/box/referral_data.dart';
import 'package:banny_table/db_helper/box/to_do_form_data.dart';
import 'package:banny_table/ui/createPatientForm/datamodel/createPatientDataModel.dart';
import 'package:banny_table/ui/patientIndependentMode/controllers/patient_independent_controller.dart';
import 'package:banny_table/ui/toDoList/dataModel/codeModel.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModelJson.dart';
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
import '../../../utils/preference.dart';


class CreatePatientController extends GetxController {
  // var selectedVerificationStatus = "";
  var status = "";
  var selectedDisplay = "";
  var selectedCode = "";
  var selectedGender = "";
  String selectedPriority = "";
  String selectedAddressType = "";
  String selectedPhoneNoType = "";
  String selectedCommunication = "";
  List<FirstNameModel> firstNameModelList = [];
  List<PhoneNumberListModel> phoneNumberList = [];
  // List<PhoneNumberListModel> emergencyPhoneNumberList = [];
  List<EmergencyContactModel> emergencyContactModelList = [];
  List<EmailIdModel> emailIdModelList = [];
  List<AddressModel> addressModelList = [];
  List<GeneralPractitionerModel> generalPractitionerList = [];
  Timer? _debounceTimer;
  List<PatientDataModel> practitionerProfileList = [];
  List<PatientDataModel> practitionerProfileListSelected = [];
  bool isShowProgress = false;


  String selectTextFirst = "Please enter reason";
  String businessStatusFocusText = "Please enter business Status";

  TextEditingController addNewCodeController = TextEditingController();
  FocusNode addNewCodeFocus = FocusNode();
  TextEditingController statusReason = TextEditingController();
  TextEditingController businessStatus = TextEditingController();

  TextEditingController searchProviderControllers = TextEditingController();
  // var editedToDoData = ToDoTableData();
  var arguments = Get.arguments;
  // var isEdited = false;
  bool isProgress = false;
  FocusNode statusReasonFocus = FocusNode();
  FocusNode businessStatusFocus = FocusNode();
  FocusNode searchProviderFocus = FocusNode();

  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode dobFocus = FocusNode();
  FocusNode genderFocus = FocusNode();

  // TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  String firstNameFocusText = "";
  String phoneNumberEnter = "Phone number";
  String lastNameFocusText = "";
  String dobFocusText = "";
  String emailIdsEnter = "";
  String address1Enter = "Line 1";
  String address2Enter = "Line 2";
  String addressCityEnter = "City";
  String addressDistEnter = "District";
  String addressStateEnter = "State";
  String addressCodeEnter = "PostalCode";
  String emergencyPhoneNumberEnter = "Emergency contact";
  String enterGivenName = "Please enter a Given Name";
  String nameEnter = "Please Enter a First Name";
  String patientGpNameHint = "Name";
  String patientNameHintText = "Please Enter a Name";
  String patientGpPhoneHint = "Please Enter a Contact";
  String patientGpFaxHint = "Please Enter a Fax";
  String patientGpEmailHint = "Please Enter a Email";

  String fromScreenType = "";
  String patientIdEdit = "";
  bool isEdit = false;

  // ReferralData referralEditedData = ReferralData();
  var selectedDateFormat = DateTime.now();
  var selectedDateStr = "";
  var isAdmin = false;

  PatientDataModel createPatientDataModelEdit = PatientDataModel();
  @override
  void onInit() {
    if (arguments != null) {
      if (arguments[0] != null) {
        // firstNameModelList.add(FirstNameModel());
        createPatientDataModelEdit = arguments[0];
        Debug.printLog("arguments[0]....");
        isEdit = true;
        ///Patient Id
        patientIdEdit = createPatientDataModelEdit.patientId;

        /// First Name(Given Name)
        if(createPatientDataModelEdit.givenNameList.isNotEmpty){
          for(int i =0;i<createPatientDataModelEdit.givenNameList.length;i++){
            FirstNameModel firstNameModelEdit =FirstNameModel();
            firstNameModelEdit.firstName = createPatientDataModelEdit.givenNameList[i].toString();
            firstNameModelEdit.firstNameController.text = createPatientDataModelEdit.givenNameList[i].toString();
            firstNameModelList.add(firstNameModelEdit);
          }
        }else{
          firstNameModelList.add(FirstNameModel());
        }
        /// Last Name
        if(createPatientDataModelEdit.lName != ""){
          lastNameController.text = createPatientDataModelEdit.lName ?? "";
        }

        ///DOB
        if(createPatientDataModelEdit.dob != ""){
          dobController.text = createPatientDataModelEdit.dob;
        }

        ///Gender
        if(createPatientDataModelEdit.gender != ""){
          if(Utils.genderList.where((element) => element == createPatientDataModelEdit.gender).toList().isNotEmpty){
            selectedGender = createPatientDataModelEdit.gender;
          }else{
            selectedGender = Utils.genderList[0];
          }
        }


        ///Telecome No
        if(createPatientDataModelEdit.phoneNoList.isNotEmpty){
          for(int i =0;i<createPatientDataModelEdit.phoneNoList.length;i++){
            PhoneNumberListModel phoneNumberListModel  = PhoneNumberListModel();
            if(createPatientDataModelEdit.phoneNoList[i].phoneUse == ContactPointUse.home) {
              phoneNumberListModel.phoneNumber =  Constant.phoneNoTypeHome;
            }else if(createPatientDataModelEdit.phoneNoList[i].phoneUse == ContactPointUse.mobile){
              phoneNumberListModel.phoneNumber =  Constant.phoneNoTypeMobile;
            }else {
              phoneNumberListModel.phoneNumber =  Constant.phoneNoTypeWork;
            }
            phoneNumberListModel.phoneNumberController.text = createPatientDataModelEdit.phoneNoList[i].phoneNumberController.text;
            phoneNumberList.add(phoneNumberListModel);
          }
        }
        else{
          // phoneNumberList.add(PhoneNumberListModel());
        }

        /// Email
        if(createPatientDataModelEdit.emailIdList.isNotEmpty){
          for(int i =0;i<createPatientDataModelEdit.emailIdList.length;i++){
            EmailIdModel emailIdModel  = EmailIdModel();
              emailIdModel.emailId =  Constant.emailType;
            emailIdModel.emailIdControllers.text = createPatientDataModelEdit.emailIdList[i].emailIdControllers.text;
            emailIdModelList.add(emailIdModel);
          }
        }

        ///Address
        if(createPatientDataModelEdit.addressModelList.isNotEmpty){
          for(int i =0;i<createPatientDataModelEdit.addressModelList.length;i++) {
            AddressModel addressModel = AddressModel();
            if (createPatientDataModelEdit.addressModelList[i].addressType ==
                AddressType.physical) {
              addressModel.addressType = Constant.addressTypeResidence;
            } else if (createPatientDataModelEdit.addressModelList[i].addressType == AddressType.postal){
              addressModel.addressType = Constant.addressTypeMailing;
          } else {
              addressModel.addressType = Constant.addressTypeBoth;
        }
            addressModel.address1.text = createPatientDataModelEdit.addressModelList[i].address1.text;
            addressModel.address2.text = createPatientDataModelEdit.addressModelList[i].address2.text;
            addressModel.state.text = createPatientDataModelEdit.addressModelList[i].state.text;
            addressModel.city.text = createPatientDataModelEdit.addressModelList[i].city.text;
            addressModel.pinCode.text = createPatientDataModelEdit.addressModelList[i].pinCode.text;
            addressModelList.add(addressModel);
          }
        }

        ///EmergencyContact
        if(createPatientDataModelEdit.emergencyContactModelLocalList.isNotEmpty){
          for(int i =0;i<createPatientDataModelEdit.emergencyContactModelLocalList.length;i++){
            EmergencyContactModel emergencyContactModel  = EmergencyContactModel();
            emergencyContactModel.phoneNumberController.text = createPatientDataModelEdit.emergencyContactModelLocalList[i].phoneNumberController.text;
            emergencyContactModel.patientNameController.text = createPatientDataModelEdit.emergencyContactModelLocalList[i].patientNameController.text;
            emergencyContactModelList.add(emergencyContactModel);
          }
        }

        ///Gp
        if(createPatientDataModelEdit.generalPractitioner.isNotEmpty){
          for(int i =0;i<createPatientDataModelEdit.generalPractitioner.length;i++){
            PatientDataModel givenNameModel  = PatientDataModel();
            givenNameModel.fName = createPatientDataModelEdit.generalPractitioner[i].displayName.toString();
            givenNameModel.patientId = createPatientDataModelEdit.generalPractitioner[i].providerId.toString();
            givenNameModel.isSelected = true;
            practitionerProfileListSelected.add(givenNameModel);
          }
        }
        Debug.printLog("Edit Mode");
      } else {
        firstNameModelList.add(FirstNameModel());

        status = Utils.todoStatusList[0];
        selectedPriority = Utils.priorityList[0];
        selectedDisplay = Utils.codeTodoList[0].display;
        selectedCode = Utils.codeTodoList[0].code ?? "";
        selectedGender = Utils.genderList[0];
        selectedAddressType =Utils.addressType[0];
        selectedCommunication =Utils.communicationList[0];
        selectedPhoneNoType =Utils.phoneNoType[0];
      }
    } else {
      firstNameModelList.add(FirstNameModel());

      status = Utils.todoStatusList[0];
      selectedPriority = Utils.priorityList[0];
      selectedDisplay = Utils.codeTodoList[0].display;
      selectedCode = Utils.codeTodoList[0].code ?? "";
      selectedGender = Utils.genderList[0];
      selectedAddressType =Utils.addressType[0];
      selectedCommunication =Utils.communicationList[0];
      selectedPhoneNoType =Utils.phoneNoType[0];
    }
    getListPractitioner();
    // var serverModelDataList = Preference.shared.getServerListedAllUrl(Preference.serverUrlAllListed) ?? [];
    var serverModelDataList = Utils.getServerList;
    var selectedUrlModel = serverModelDataList.where((element) => element.isSelected && element.isPrimary && element.providerId != "").toList();
    if(selectedUrlModel.isNotEmpty){
      isAdmin = selectedUrlModel[0].isAdmin;
    }

    super.onInit();
  }

  insertPatient(BuildContext context) async {
    if(emailIdModelList.isNotEmpty && emailIdModelList[0].emailIdControllers.text != "")
    {
      isProgress = true;
      if (isProgress) {
        Utils.showDialogForProgress(Get.context!, Constant.txtPleaseWait,
            Constant.txtPatientDataProgress);
      }
      List<String> firstNamesList = [];
      var lastName = lastNameController.text.toString().trim();
      var dob = dobController.text;
      var gender = selectedGender;
      List<ContactPoint> contactPointPhoneList = [];
      List<PatientContact> emergencyNumberDetailsList = [];
      List<Address> addressList = [];
      List<Reference> referenceList = [];

      ///Add a FirstName MultiPle List
      for (int i = 0; i < firstNameModelList.length; i++) {
        firstNamesList.add(firstNameModelList[i].firstNameController.text.toString().trim());
      }
      for (int i = 0; i < phoneNumberList.length; i++) {
        ContactPoint contactPoint = ContactPoint(
          system: ContactPointSystem.phone,
          value: phoneNumberList[i].phoneNumberController.text.toString().trim(),
          use: (phoneNumberList[i].phoneNumber == Constant.phoneNoTypeHome)
              ? ContactPointUse.home
              :
          (phoneNumberList[i].phoneNumber == Constant.phoneNoTypeMobile)
              ? ContactPointUse.mobile
              : ContactPointUse.work,
        );
        contactPointPhoneList.add(contactPoint);
      }
      for (int i = 0; i < emailIdModelList.length; i++) {
        ContactPoint contactPoint = ContactPoint(
          system: ContactPointSystem.email,
          value: emailIdModelList[i].emailIdControllers.text.toString().trim(),
        );
        contactPointPhoneList.add(contactPoint);
      }
      for (int i = 0; i < emergencyContactModelList.length; i++) {
        /*List<String> givenList = [];
      for(int j = 0 ;j<emergencyContactModelList[i].givenNameList.length;j++){
        givenList.add(emergencyContactModelList[i].givenNameList[j].givenNameController.text.toString());
      }*/
        PatientContact patientContact = PatientContact(
          relationship: [
            CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          "http://terminology.hl7.org/CodeSystem/v2-0131"),
                      code: Code("EP")
                  )
                ]
            )
          ],
          name: HumanName(
            text: emergencyContactModelList[i].patientNameController.text
                .toString().trim(),
            // given: givenList.toList(),
          ),
          telecom: [
            ContactPoint(
              system: ContactPointSystem.phone,
              value: emergencyContactModelList[i].phoneNumberController.text
                  .toString().trim(),
            )
          ],
        );
        emergencyNumberDetailsList.add(patientContact);
      }
      for (int i = 0; i < addressModelList.length; i++) {
        Address address = Address(
          type: (addressModelList[i].addressType ==
              Constant.addressTypeResidence) ? AddressType.physical :
          (addressModelList[i].addressType == Constant.addressTypeMailing)
              ? AddressType.postal
              : AddressType.both,
          line: [
            addressModelList[i].address1.text.toString().trim(),
            addressModelList[i].address2.text.toString().trim()
          ],
          city: addressModelList[i].city.text.toString().trim(),
          state: addressModelList[i].state.text.toString().trim(),
          postalCode: addressModelList[i].pinCode.text.toString().trim(),
        );
        addressList.add(address);
      }

      ///This Is (General Practitioner (GP))
      if (isAdmin) {
        for (int i = 0; i < practitionerProfileListSelected.length; i++) {
          Reference reference = Reference(

            /// That In Use A Provider id But Name Write in Patient Id
            reference: 'Practitioner/${practitionerProfileListSelected[i]
                .patientId}',
            display: "${practitionerProfileListSelected[i]
                .fName} ${practitionerProfileListSelected[i].lName}",
          );
          referenceList.add(reference);
        }
      } else {
        Reference reference = Reference(
          reference: 'Practitioner/${Utils.getProviderId()}',
          display: Utils.getProviderName(),
        );
        referenceList.add(reference);
      }

      var data = CreatePatientDataModel();
      data.patientId = patientIdEdit ?? "";
      data.firstNameList = firstNamesList.toList();
      data.lName = lastName;
      data.dob = dob;
      data.gender = gender;
      // data.communication =communication;
      data.phoneNumbersList = contactPointPhoneList;
      data.addressList = addressList;
      data.emergencyContactList = emergencyNumberDetailsList;
      data.referenceList = referenceList;
      // data.emailIdsList = emailIdModelList;

      PaaProfiles profiles = PaaProfiles();
      Patient patient = profiles.createPatient(data);
      ServerModelJson? getPrimaryData = Utils.getPrimaryServerData();
      var patientId = await profiles.processCreatePatient(
          patient, getPrimaryData);
      Debug.printLog("patientId....$patientId");
      if (isProgress) {
        Get.back();
      }
      String name = "";
      if (context.mounted) Utils.showToast(
          context, "Patient created successfully");
      // Get.back();
      if(patientId == "null" || patientId == null){
        patientId = "";
        if(data.firstNameList.isNotEmpty){
          name = data.firstNameList[0];
        }
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

      List<EmergencyContactModelLocal>  emergencyContactModelLocalList = [];

      for (int i = 0; i < emergencyContactModelList.length; i++) {

        EmergencyContactModelLocal emergencyContactModelLocal = EmergencyContactModelLocal();
        emergencyContactModelLocal.phoneNumberController.text = emergencyContactModelList[i].phoneNumberController.text.toString().trim();
        emergencyContactModelLocal.patientNameController.text = emergencyContactModelList[i].patientNameController.text.toString().trim();
        emergencyContactModelLocalList.add(emergencyContactModelLocal);
      }


      patientDataModel.emergencyContactModelLocalList = emergencyContactModelLocalList;
      ///


      if (isAdmin) {

        List<GeneralPractitioner>  generalPractitionerList = [];

        for (int i = 0; i < practitionerProfileListSelected.length; i++) {

          GeneralPractitioner generalPractitioner = GeneralPractitioner();
          generalPractitioner.providerId = practitionerProfileListSelected[i]
              .patientId;
          generalPractitioner.displayName = "${practitionerProfileListSelected[i]
              .fName} ${practitionerProfileListSelected[i].lName}";
          generalPractitionerList.add(generalPractitioner);
        }

        patientDataModel.generalPractitioner = generalPractitionerList;
      }

      PatientIndependentController patientIndependentController = Get.find();
      if(patientIndependentController.patientProfileList.where((element) => element.patientId == patientId).toList().isEmpty){
        patientIndependentController.patientProfileList.insert(0,patientDataModel);
        patientIndependentController.updateMethod();
      }else{
        int index = patientIndependentController.patientProfileList.indexWhere((element) => element.patientId == patientId).toInt();
        if(index != -1){
          patientIndependentController.patientProfileList[index] = patientDataModel;
          patientIndependentController.updateMethod();
        }
      }
      Get.back();
      // getCallApi(patientId,name);
    }
    else {
      Utils.showToast(context, "Please Enter a Email Id");
    }
  }

/*
  getCallApi(String id,String name) {
    // patientIndependentController.getPatientList(isBack: true,valuesId: id,valuesName: name);
  }
*/

  void onChangeStatus(String value) {
    status = value;
    update();
  }

  void onChangePriority(String? value) {
    selectedPriority = value ?? "";
    update();
  }

  void onChangeCode(int index) {
    selectedDisplay =Utils.codeTodoList[index].display;
    selectedCode = Utils.codeTodoList[index].code ?? "";
    Get.back();
    update();
  }

  void addNewCodeDataIntoList(String displayAdd) {
    Utils.codeTodoList.add(CodeToDoModel(display: displayAdd));
    Get.back();
    addNewCodeController.clear();
    update();
  }

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

  addPhoneNumberList(String values){
    if(values == Constant.phoneNumberAdd){
      phoneNumberList.add(PhoneNumberListModel());
      phoneNumberList[phoneNumberList.length -1].phoneNumber = Utils.phoneNoType[0];
    }else if(values == Constant.emailIdAdd){
      emailIdModelList.add(EmailIdModel());
    }else if(values == Constant.addAddressAdd) {
      addressModelList.add(AddressModel());
      addressModelList[addressModelList.length -1].addressType = Utils.addressType[0];
    }else if(values == Constant.emergencyPhoneNumberAdd){
      emergencyContactModelList.add(EmergencyContactModel());
      // emergencyContactModelList[emergencyContactModelList.length -1].givenNameList.add(GivenNameModel());
    }else if(values == Constant.gpAdd){
      generalPractitionerList.add(GeneralPractitionerModel());
    }else if(values ==Constant.firstNameAdd ){
      firstNameModelList.add(FirstNameModel());
    }
    update();
  }

  /*addGivenName(int index){
    emergencyContactModelList[index].givenNameList.add(GivenNameModel());
    update();
  }*/

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

  getListPractitioner({StateSetter? setStateDialog}) async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 1000), () async {
      practitionerProfileList.clear();
      onChangeProgressValue(true);
      var listData = await PaaProfiles.getPractitionerListTestUse(
          R4ResourceType.Practitioner,
          // searchIdControllersPractitioner.text
          "",
          searchProviderControllers.text);
      if (listData.resourceType == R4ResourceType.Bundle) {
        practitionerProfileList.clear();
        if (listData != null && listData.entry != null) {
          int length = listData.entry.length;
          for (int i = 0; i < length; i++) {
            if (listData.entry[i].resource.resourceType ==
                R4ResourceType.Practitioner) {
              var patientData = PatientDataModel();
              var data = listData.entry[i];
              var id;
              if (data.resource.id != null) {
                id = data.resource.id.toString();
              }

              var lName = "";
              try {
                lName = data.resource.name[0].family.toString();
              } catch (e) {
                Debug.printLog("lName...$e");
              }

            /*  var fName = "";
              try {
                fName = data.resource.name[0].given[0].toString();
              } catch (e) {
                Debug.printLog("lName...$e");
              }*/

              var fName = "";
              List<String> givenNameList = [];
              try {
                for(int i = 0; i<data.resource.name[0].given.length;i++){
                  givenNameList.add("${data.resource.name[0].given[i]} ");
                  fName += "${data.resource.name[0].given[i]} ";
                }
                // fName = data.resource.name[0].given[0].toString();
              } catch (e) {
                Debug.printLog("fName...$e");
              }

              var gender = "";
              try {
                gender = data.resource.gender.toString();
              } catch (e) {
                Debug.printLog("lName...$e");
              }

              var dob = "";
              try {
                dob = data.resource.birthDate.toString();
                DateTime dateTime = DateTime.parse(dob);
                String formattedDateTime = DateFormat(Constant.commonDateFormatMmmDdYyyy).format(dateTime);
                Debug.printLog('Formatted DateTime: $formattedDateTime');
                dob = formattedDateTime;
              } catch (e) {
                Debug.printLog("lName...$e");
              }

              patientData.patientId = id;
              patientData.fName = fName;
              patientData.lName = lName;
              patientData.dob = dob;
              patientData.gender = gender;
              if(practitionerProfileListSelected.where((element) => element.patientId == patientData.patientId).toList().isNotEmpty){
                patientData.isSelected = true;
              }
              practitionerProfileList.add(patientData);

              Debug.printLog(
                  "patient info....$fName  $lName  $gender  $dob  $id");
            }
          }
        }
      }
      onChangeProgressValue(false);
      update();
      if(setStateDialog != null){
        setStateDialog((){});
      }
      Debug.printLog("getPatientList....${practitionerProfileList.length}");
    });
  }

  onChangeProgressValue(bool value){
    isShowProgress = value;
    update();
  }

  onChangeSelectAndNotSelectedValue(int index){
    if(index != -1 && practitionerProfileList.isNotEmpty){
      practitionerProfileList[index].isSelected = !practitionerProfileList[index].isSelected;
      if(practitionerProfileList[index].isSelected){
        practitionerProfileListSelected.add(practitionerProfileList[index]);
      }else if(!practitionerProfileList[index].isSelected){
        int deletedIndex = practitionerProfileListSelected.indexWhere((element) => element.patientId == practitionerProfileList[index].patientId).toInt();
        Debug.printLog("Deleted Id Index log......$deletedIndex");
        practitionerProfileListSelected.removeAt(deletedIndex);
      }
    }
  }

  onChangeRemoveSelectedId(index){
    int listIndex = practitionerProfileList.indexWhere((element) =>element.patientId == practitionerProfileListSelected[index].patientId).toInt();
    if(listIndex != -1){
      practitionerProfileList[listIndex].isSelected = false;
    }
    practitionerProfileListSelected.removeAt(index);
    update();
  }



  removeInList(String values,int index){
    if(values == Constant.phoneNumberAdd){
      phoneNumberList.removeAt(index);
    }else if(values == Constant.emailIdAdd){
      emailIdModelList.removeAt(index);
    }else if(values == Constant.addAddressAdd) {
      addressModelList.removeAt(index);
    }else if(values == Constant.emergencyPhoneNumberAdd){
      emergencyContactModelList.removeAt(index);
    }else if(values == Constant.gpAdd){
      generalPractitionerList.removeAt(index);
    }else if(values ==Constant.firstNameAdd ){
      firstNameModelList.removeAt(index);
    }
    update();
  }


}
