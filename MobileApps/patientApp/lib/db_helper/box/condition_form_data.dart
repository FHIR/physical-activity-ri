
import 'package:hive/hive.dart';
part 'condition_form_data.g.dart';

@HiveType(typeId: 3)
class ConditionTableData extends HiveObject {
  ConditionTableData(
      {this.conditionID,
      this.verificationStatus,
      this.onset,
      this.abatement,
      this.patientId,
      });

  @HiveField(0)
  String? conditionID;

  @HiveField(1)
  String? verificationStatus;

  @HiveField(2)
  DateTime? onset;

  @HiveField(3)
  DateTime? abatement;

  @HiveField(4)
  bool isSync = true;

  @HiveField(5)
  bool readOnly = false;

  @HiveField(6)
  bool isDelete = false;

  @HiveField(7)
  String? patientId;

  @HiveField(8)
  String providerId = "";

  @HiveField(9)
  String? code;

  @HiveField(10)
  String? display;

  @HiveField(11)
  String? text;

  @HiveField(12)
  String qrUrl = "";

  @HiveField(13)
  String token = "";

  @HiveField(14)
  String clientId = "";

  @HiveField(15)
  String patientName = "";

  @HiveField(16)
  String providerName = "";

  ///THis Is Only For Local
  bool isSelected = false;

  @HiveField(17)
  String detalis = "";


}