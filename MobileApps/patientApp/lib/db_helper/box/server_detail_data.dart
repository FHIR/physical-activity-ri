import 'package:hive/hive.dart';
part 'server_detail_data.g.dart';

@HiveType(typeId: 11)
class ServerDetailDataTable extends HiveObject {
  ServerDetailDataTable();

  @HiveField(0)
  String? serverUrl;

  @HiveField(1)
  String? patientId;

  @HiveField(2)
  String? clientId;

  @HiveField(3)
  String? patientName;

  @HiveField(4)
  String? serverToken;

  @HiveField(5)
  String? objectId;

  @HiveField(6)
  bool? dataSyncServerWise;

}