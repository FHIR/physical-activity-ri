import 'package:hive/hive.dart';
part 'identifier_data.g.dart';

@HiveType(typeId: 5)
class IdentifierTable extends HiveObject {
  IdentifierTable(
      {this.objectId,
      this.url,
      });

  @HiveField(0)
  String? objectId;

  @HiveField(1)
  String? url;

}