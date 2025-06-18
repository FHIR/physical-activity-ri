import 'package:hive/hive.dart';
part 'to_do_form_data.g.dart';

@HiveType(typeId: 99)
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
  bool? isCreated = true;

  @HiveField(9)
  String? businessStatus;

  @HiveField(10)
  String providerId = "";

  @HiveField(11)
  String forReference = "";
  @HiveField(12)
  String forDisplay = "";

  @HiveField(13)
  String requesterReference = "";
  @HiveField(14)
  String requesterDisplay = "";

  @HiveField(15)
  String ownerReference = "";
  @HiveField(16)
  String ownerDisplay = "";

  @HiveField(17)
  String tag = "";

  @HiveField(18)
  DateTime? lastUpdatedDate;

  @HiveField(19)
  DateTime? createdDate;

  @HiveField(20)
  bool needDisplay = true;

  @HiveField(21)
  String text = "";

  @HiveField(22)
  String focusReference = "";


  @HiveField(23)
  String qrUrl = "";

  @HiveField(24)
  String token = "";

  @HiveField(25)
  String clientId = "";

  @HiveField(26)
  String patientName = "";

  @HiveField(27)
  String providerName = "";

}