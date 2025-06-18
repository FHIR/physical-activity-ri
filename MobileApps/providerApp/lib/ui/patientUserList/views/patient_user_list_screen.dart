import 'package:banny_table/ui/patientUserList/controllers/patient_user_list_controller.dart';
import 'package:banny_table/ui/patientUserList/views/mobile_patient_user_list_screen.dart';
import 'package:banny_table/ui/patientUserList/views/web_patient_user_list_screen.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PatientUserListScreen extends StatelessWidget {
   PatientUserListScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          useMaterial3: false
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CColor.primaryColor,
          title: const Text(Constant.headerPatientUserScreen),
        ),
        backgroundColor: CColor.white,
        body: SafeArea(
          child: GetBuilder<PatientUserListController>(builder: (logic) {
            return (kIsWeb)?const WebPatientUserListScreen(): MobilePatientUserListScreen();
          }),
        ),
      ),
    );
  }
}
