import 'package:hive/hive.dart';
part 'server_detail_data_mod_min.g.dart';

@HiveType(typeId: 12)
class ServerDetailDataModMinTable extends HiveObject {
  ServerDetailDataModMinTable();

  @HiveField(0)
  String? modServerUrl;

  @HiveField(1)
  String? modPatientId;

  @HiveField(2)
  String? modClientId;

  @HiveField(3)
  String? modPatientName;

  @HiveField(4)
  String? modServerToken;

  @HiveField(5)
  String? modObjectId;

  @HiveField(6)
  bool? modDataSyncServerWise;
}