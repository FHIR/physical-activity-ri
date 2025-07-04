import 'package:hive/hive.dart';
part 'notes_data.g.dart';

@HiveType(typeId: 20)
class NoteTableData extends HiveObject {
  NoteTableData(
      {this.author,
        this.date,
      this.notes,
      this.patientId,
      });

  @HiveField(0)
  String? author;
  String? authorReference;

  @HiveField(1)
  DateTime? date;

  @HiveField(2)
  String? notes;

  @HiveField(3)
  bool readOnly = false;

  @HiveField(4)
  bool isDelete = false;

  @HiveField(5)
  int? goalId;

  @HiveField(6)
  int? referralId;

  @HiveField(7)
  int? routingId;

  @HiveField(8)
  int? carePlanId;

  @HiveField(9)
  String? patientId;

  @HiveField(10)
  String? referralTaskId;

  @HiveField(11)
  int? exerciseId;

  @HiveField(12)
  int? createdReferralId;

  @HiveField(13)
  int? assignedReferralId;

  @HiveField(14)
  bool? isCreatedNote = false;

  @HiveField(15)
  bool? isAssignedNote = false;

  @HiveField(16)
  String providerId = "";

  @HiveField(17)
  bool? isTaskNote = false;

  @HiveField(18)
  int? createdTaskId;
}