import 'package:fhir/r4/special_types/special_types.dart';

import '../../../db_helper/box/notes_data.dart';

class ToDoDataListModel {
  String? objectId;

  String? status;

  String? statusReason;

  String? patientId;

  bool isSync = true;

  String? priority;

  String? code;

  String? display;

  bool? isCreated = true;

  String? businessStatus;

  String providerId = "";

  String forReference = "";

  String forDisplay = "";

  String requesterReference = "";

  String requesterDisplay = "";

  String ownerReference = "";

  String ownerDisplay = "";

  String tag = "";

  DateTime? lastUpdatedDate;

  DateTime? createdDate;

  bool needDisplay = true;

  String text = "";

  String focusReference = "";

  String qrUrl = "";

  String token = "";

  String clientId = "";

  String patientName = "";

  String providerName = "";

  List<NoteTableData> noteList = [];

  String? performerId = "";

  String performerName = "";

  String makeContactDescription = "";

  String reviewMaterialURL = "";

  String reviewMaterialTitle = "";

  String generalDescription = "";
  String referralTypeDisplay = "";
  String referralTypeCode = "";
  String? generalResponseText;
  String? chosenContactText;
  bool isPeriodDate = false;
  DateTime? startDate;
  DateTime? endDate;

  Reference? forReferences;
  Reference? requesterReferences;
  Reference? ownerReferences;
  Reference? focusReferences;

}
