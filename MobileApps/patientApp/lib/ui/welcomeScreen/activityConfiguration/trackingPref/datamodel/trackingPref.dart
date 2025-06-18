class TrackingPref {
  String titleName = "";
  int pos = 0;
  bool isSelected = true;
  // String toolTipText = "";

  TrackingPref({
    required this.titleName,
    required this.pos,
    required this.isSelected,
    // required this.toolTipText,
  });

  TrackingPref.fromJson(Map<String, dynamic> json) {
    titleName = json['titleName'];
    pos = json['pos'];
    isSelected = json['isSelected'];
    // toolTipText = json['toolTipText'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['titleName'] = titleName;
    data['pos'] = pos;
    data['isSelected'] = isSelected;
    // data['toolTipText'] = toolTipText;
    return data;
  }
}
