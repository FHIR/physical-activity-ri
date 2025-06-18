class ConfigurationClass {
  String title = "";
  String iconImage = "";
  String activityCode = "";
  bool isEnabled = true;
  bool isModerate = true;
  bool isVigorous = true;
  bool isTotal = true;
  bool isDaysStr = true;
  bool isCalories = true;
  bool isSteps = true;
  bool isRest = true;
  bool isPeck = true;
  bool isNotes = true;
  bool isExperience = true;

  // ConfigurationClass(this.title, this.iconImage);

  ConfigurationClass({
    required this.title,
    required this.iconImage,
    required this.activityCode,
  });

  ConfigurationClass.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    iconImage = json['iconImage'];
    isEnabled = json['isEnabled'];
    isModerate = json['isModerate'];
    isVigorous = json['isVigorous'];
    isTotal = json['isTotal'];
    isDaysStr = json['isDaysStr'];
    isCalories = json['isCalories'];
    isSteps = json['isSteps'];
    isRest = json['isRest'];
    isPeck = json['isPeck'];
    isNotes = json['isNotes'];
    isExperience = json['isExperience'];
    activityCode = json['activityCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['iconImage'] = iconImage;
    data['isEnabled'] = isEnabled;
    data['isModerate'] = isModerate;
    data['isVigorous'] = isVigorous;
    data['isTotal'] = isTotal;
    data['isDaysStr'] = isDaysStr;
    data['isCalories'] = isCalories;
    data['isSteps'] = isSteps;
    data['isRest'] = isRest;
    data['isPeck'] = isPeck;
    data['isNotes'] = isNotes;
    data['isExperience'] = isExperience;
    data['activityCode'] = activityCode;
    return data;
  }
}
