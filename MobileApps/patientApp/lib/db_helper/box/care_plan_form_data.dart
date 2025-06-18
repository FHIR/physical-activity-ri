import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:hive/hive.dart';
part 'care_plan_form_data.g.dart';

@HiveType(typeId: 2)
class CarePlanTableData extends HiveObject {
  CarePlanTableData(
      {this.carePlanId,
        this.text,
        this.statusDropDown,
        this.status,
        this.startDate,
        this.endDate,
        this.goal,
        this.patientId,
      });

  @HiveField(0)
  String? carePlanId;

  @HiveField(1)
  String? text;

  @HiveField(2)
  String? statusDropDown;

  @HiveField(3)
  String? status;

  @HiveField(4)
  DateTime? startDate;

  @HiveField(5)
  DateTime? endDate;

  @HiveField(6)
  String? goal;

  @HiveField(7)
  bool isSync = true;

  @HiveField(8)
  bool readOnly = false;

  @HiveField(9)
  bool isDelete = false;

  @HiveField(10)
  String? patientId;

  @HiveField(11)
  List<String>? goalObjectId;

  @HiveField(12)
  String qrUrl = "";

  @HiveField(13)
  String token = "";

  @HiveField(14)
  String clientId = "";

  @HiveField(24)
  String patientName = "";

  List<NoteTableData> notesData = [];
}