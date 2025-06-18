class TrackingPref {
  String titleName = "";
  int pos = 0;
  bool isSelected = true;

  TrackingPref({
    required this.titleName,
    required this.pos,
    required this.isSelected,
  });

  TrackingPref.fromJson(Map<String, dynamic> json) {
    titleName = json['titleName'];
    pos = json['pos'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['titleName'] = titleName;
    data['pos'] = pos;
    data['isSelected'] = isSelected;
    return data;
  }
}
