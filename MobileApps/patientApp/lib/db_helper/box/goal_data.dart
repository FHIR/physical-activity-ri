import 'package:banny_table/fhir_auth/fhir_client/fhir_client.dart';
import 'package:banny_table/fhir_auth/fhir_client/smart_fhir_client.dart';
import 'package:hive/hive.dart';
part 'goal_data.g.dart';

@HiveType(typeId: 4)
class GoalTableData extends HiveObject {
  GoalTableData(
      {this.goalId,
      this.notes,
      this.description,
      this.target,
      this.dueDate,
      this.lifeCycleStatus,
      this.achievementStatus,
        this.multipleGoals,
        this.patientId
      });

  @HiveField(0)
  String? goalId;

  @HiveField(1)
  String? notes;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String? target;

  @HiveField(4)
  DateTime? dueDate;

  @HiveField(5)
  String? lifeCycleStatus;

  @HiveField(6)
  String? achievementStatus;

  @HiveField(7)
  DateTime? createdDate;

  @HiveField(8)
  DateTime? updatedDate;

  @HiveField(9)
  String? multipleGoals;

/*  @HiveField(10)
  List<NoteTableData>? notesList;*/

  @HiveField(10)
  String? objectId = "";

  @HiveField(11)
  bool isSync = true;

  @HiveField(12)
  bool readOnly = false;

  @HiveField(13)
  bool isDelete = false;

  @HiveField(14)
  String code = "";

  @HiveField(15)
  String system = "";

  @HiveField(16)
  String actualDescription = "";

  @HiveField(17)
  String? patientId;

  bool isSelected = false;

  @HiveField(18)
  bool isEditable = true;

  @HiveField(19)
  String expressedBy = "";

  @HiveField(20)
  String expressedByDisplay = "";

  @HiveField(21)
  String qrUrl = "";

  @HiveField(22)
  String token = "";

  @HiveField(23)
  String clientId = "";

  @HiveField(24)
  String patientName = "";

}