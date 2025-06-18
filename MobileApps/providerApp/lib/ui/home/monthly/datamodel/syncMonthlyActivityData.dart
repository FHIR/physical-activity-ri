class SyncMonthlyActivityData{
  var monthName = "";
  // var type = "";
  var value = 0.0;
  DateTime? startDate;
  DateTime? endDate;
  int keyId = 0;

  var headerType = "";
  var isDay = false;
  var objectId = "";

  SyncMonthlyActivityData(this.monthName,this.value,this.startDate,this.endDate,this.keyId,this.headerType,this.isDay, this.objectId);
}