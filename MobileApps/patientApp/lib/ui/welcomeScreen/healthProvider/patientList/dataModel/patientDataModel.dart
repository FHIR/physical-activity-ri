import 'package:fhir/r4/general_types/general_types.dart';
import 'package:flutter/material.dart';

class PatientDataModel{
  String patientId = "";
  String fName = "";
  String lName = "";
  String dob = "";
  String gender = "";
  List<String> givenNameList = [];
  bool isSelected = false;
  List<PhoneNumberListModelLocal>  phoneNoList = [];
  List<EmailIdModelLocal>  emailIdList = [];
  List<AddressModelLocal>  addressModelList = [];
  List<EmergencyContactModelLocal>  emergencyContactModelLocalList = [];
  List<GeneralPractitioner>  generalPractitioner = [];
  List<QualificationDataClass>  qualificationDataList = [];
}
class PhoneNumberListModelLocal{
  // String phoneNumberType = "";
  late ContactPointSystem phoneSystemType;
  late ContactPointUse phoneUse;
  TextEditingController phoneNumberController = TextEditingController();
}

class EmailIdModelLocal{
  late ContactPointSystem emailIdType;
  TextEditingController emailIdControllers = TextEditingController();
}

class AddressModelLocal{
  AddressType? addressType;
  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController distinct = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController pinCode = TextEditingController();
}

class EmergencyContactModelLocal{
  TextEditingController phoneNumberController = TextEditingController();
  // List<GivenNameModel> givenNameList = [];
  TextEditingController patientNameController = TextEditingController();
}

class GeneralPractitioner{
  String providerId = "";
  String displayName = "";
}

class QualificationDataClass{
  String codeText = "";
}

