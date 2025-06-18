import 'package:hive/hive.dart';
part 'routing_referral_data.g.dart';

@HiveType(typeId: 10)
class RoutingReferralData extends HiveObject {
  RoutingReferralData(
      {this.referralId,
        this.status,
        this.statusReason,
        this.priority,
        this.owner,
        this.patientId,
      });

  @HiveField(0)
  int? referralId;

  @HiveField(1)
  String? status;

  @HiveField(2)
  String? statusReason;

  @HiveField(3)
  String? priority;

  @HiveField(4)
  String? owner;

  @HiveField(5)
  bool readonly = false;

  @HiveField(6)
  String? patientId;

}