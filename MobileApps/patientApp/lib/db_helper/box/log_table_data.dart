import 'package:hive/hive.dart';
part 'log_table_data.g.dart';

@HiveType(typeId: 6)
class LogTableData extends HiveObject {
  LogTableData(
      {
        this.resourceType,
        this.type,
      this.response,
      this.patientId,
      });


  @HiveField(0)
  String? resourceType;

  @HiveField(1)
  String? type;

  @HiveField(2)
  String? response;

  @HiveField(3)
  String? patientId;
}