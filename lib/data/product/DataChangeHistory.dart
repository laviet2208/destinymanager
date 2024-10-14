import '../otherData/Time.dart';

class DataChangeHistory {
  int id;
  Time timeHappend;
  int changeType; //1:add, 2:update, 3:delete
  String productIdChange;

  DataChangeHistory({required this.id, required this.timeHappend, required this.changeType, required this.productIdChange});

  Map<dynamic, dynamic> toJson() => {
    'id': id,
    'timeHappend': timeHappend.toJson(),
    'changeType': changeType,
    'productIdChange': productIdChange,
  };

  factory DataChangeHistory.fromJson(Map<dynamic, dynamic> json) {
    return DataChangeHistory(
      id: int.parse(json['id'].toString()),
      timeHappend: Time.fromJson(json['timeHappend']),
      changeType: int.parse(json['changeType'].toString()),
      productIdChange: json['productIdChange'].toString(),
    );
  }
}