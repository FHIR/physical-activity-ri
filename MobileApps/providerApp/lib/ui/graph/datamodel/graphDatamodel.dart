class ListOfMeaSure{
  String titleName = "";
  bool isSelected = false;
  List<SubListOfMeaSure> subList = [];

  ListOfMeaSure(this.titleName,this.subList,this.isSelected);
}

class SubListOfMeaSure{
  String subTitleName = "";
  bool isSelected = false;

  SubListOfMeaSure(this.subTitleName,this.isSelected);
}