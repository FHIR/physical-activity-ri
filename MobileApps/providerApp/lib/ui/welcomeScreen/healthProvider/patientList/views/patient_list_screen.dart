import 'package:banny_table/ui/welcomeScreen/healthProvider/healthProvider/controllers/health_provider_controller.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/patientList/views/web_patient_list_screen.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/patient_list_controller.dart';
import 'mobile_patient_list_screen.dart';


class PatientListScreen extends StatelessWidget {
  HealthProviderController? healthProviderController;

  PatientListScreen({ this.healthProviderController,Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          useMaterial3: false
      ),
      child: Scaffold(
        /*appBar: AppBar(
          backgroundColor: CColor.primaryColor,
          title: const Text(Constant.headerPatientUserScreen),
        ),*/

        appBar: AppBar(
          backgroundColor: CColor.primaryColor,
          title: Text("Select Patient Profile"),
          leading: IconButton(
            onPressed: () {
              healthProviderController!.pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn);
              Debug.printLog("------back");
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        backgroundColor: CColor.white,
        body: SafeArea(
          child: GetBuilder<PatientListController>(builder: (logic) {
            return (kIsWeb)?const WebPatientListScreen(): MobilePatientListScreen();
          }),
        ),
      ),
    );
  }
}
