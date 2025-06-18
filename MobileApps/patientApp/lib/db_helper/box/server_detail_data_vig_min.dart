import 'package:hive/hive.dart';
part 'server_detail_data_vig_min.g.dart';

@HiveType(typeId: 13)
class ServerDetailDataVigMinTable extends HiveObject {
  ServerDetailDataVigMinTable();

  @HiveField(0)
  String? vigServerUrl;

  @HiveField(1)
  String? vigPatientId;

  @HiveField(2)
  String? vigClientId;

  @HiveField(3)
  String? vigPatientName;

  @HiveField(4)
  String? vigServerToken;

  @HiveField(5)
  String? vigObjectId;

  @HiveField(6)
  bool? vigDataSyncServerWise;
}