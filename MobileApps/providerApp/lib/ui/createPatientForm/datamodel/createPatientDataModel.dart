import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:fhir/primitive_types/decimal.dart';
import 'package:fhir/r4.dart';
import 'package:fhir/r4/general_types/general_types.dart';
import 'package:fhir/r4/special_types/special_types.dart';
import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class CreatePatientDataModel{
  String patientId = "";
  String fName = "";
  String lName = "";
  String dob = "";
  String gender = "";
  // String communication = "";
  List<String> firstNameList = [];
  List<PractitionerQualification> qualificationList = [];
  List<ContactPoint> phoneNumbersList = [];
  List<Address> addressList = [];
  List<PatientContact> emergencyContactList = [];
  List<Reference> referenceList = [];

}

class PhoneNumberListModel{
  String phoneNumber = "";
  TextEditingController phoneNumberController = TextEditingController();
}

class EmailIdModel{
  String emailId = "";
  TextEditingController emailIdControllers = TextEditingController();
}

class AddressModel{
  String addressType = "";
  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController distinct = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController pinCode = TextEditingController();
}
class GeneralPractitionerModel{
  TextEditingController gpNameController = TextEditingController();
  TextEditingController gpPhoneController = TextEditingController();
  TextEditingController gpFaxController = TextEditingController();
  TextEditingController gpEmailController = TextEditingController();
}

class FirstNameModel{
  String firstName = "";
  TextEditingController firstNameController = TextEditingController();
}

class EmergencyContactModel{
  TextEditingController phoneNumberController = TextEditingController();
  // List<GivenNameModel> givenNameList = [];
  TextEditingController patientNameController = TextEditingController();
}

class GivenNameModel{
  String providerId = "";
  String displayName = "";
}

class QualificationIdModel{
  String qualificationId = "";
  TextEditingController qualificationIdControllers = TextEditingController();
}
