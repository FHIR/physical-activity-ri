import 'package:hive/hive.dart';
part 'to_do_form_data.g.dart';

@HiveType(typeId: 14)
class ToDoTableData extends HiveObject {
  ToDoTableData(
      {
      this.objectId,
      this.status,
      this.statusReason,
      this.patientId,
          this.priority,
        this.code
      });


  @HiveField(0)
  String? objectId;

  @HiveField(1)
  String? status;

  @HiveField(2)
  String? statusReason;

  @HiveField(3)
  String? patientId;

  @HiveField(4)
  bool isSync = true;


  @HiveField(5)
  String? priority;

  @HiveField(6)
  String? code;

  @HiveField(7)
  String? display;

  @HiveField(8)
  String qrUrl = "";

  @HiveField(9)
  String token = "";

  @HiveField(10)
  String clientId = "";

  @HiveField(11)
  String patientName = "";

  @HiveField(12)
  String forReference = "";
  @HiveField(13)
  String forDisplay = "";

  @HiveField(14)
  String requesterReference = "";
  @HiveField(15)
  String requesterDisplay = "";

  @HiveField(16)
  String ownerReference = "";
  @HiveField(17)
  String ownerDisplay = "";

  @HiveField(18)
  String tag = "";

  @HiveField(19)
  DateTime? lastUpdatedDate;

  @HiveField(20)
  DateTime? createdDate;

  @HiveField(21)
  String? businessStatus;

}