import '../otherData/Time.dart';
import '../voucherData/UserUse.dart';

class Voucher {
  String id;
  String eventName;
  double Money;
  double mincost;
  double maxSale;
  Time startTime;
  Time endTime;
  int useCount;
  int maxCount;
  int type; //0: giảm theo tiền cứng , 1: giảm theo phần trăm
  int perCustom;
  List<UserUse> CustomList = [];

  Voucher({required this.id, required this.Money,required this.mincost,required this.startTime,required this.endTime,required this.useCount,required this.maxCount, required this.eventName, required this.type, required this.perCustom, required this.CustomList, required this.maxSale,});

  Map<dynamic, dynamic> toJson() => {
    'id' : id,
    'Money' : Money,
    'mincost' : mincost,
    'startTime' : startTime.toJson(),
    'endTime' : endTime.toJson(),
    'useCount' : useCount,
    'maxCount' : maxCount,
    'eventName' : eventName,
    'type' : type,
    'perCustom' : perCustom,
    'CustomList' : CustomList.map((e) => e.toJson()).toList(),
    'maxSale' : maxSale,
  };

  factory Voucher.fromJson(Map<dynamic, dynamic> json) {
    List<UserUse> userList = [];

    if (json["CustomList"] != null) {
      for (final result in json["CustomList"]) {
        userList.add(UserUse.fromJson(result));
      }
    }

    return Voucher(
      id: json['id'].toString(),
      Money: double.parse(json['Money'].toString()),
      mincost: double.parse(json['mincost'].toString()),
      startTime: Time.fromJson(json['startTime']),
      endTime: Time.fromJson(json['endTime']),
      useCount: int.parse(json['useCount'].toString()),
      maxCount: int.parse(json['maxCount'].toString()),
      eventName: json['eventName'].toString(),
      type: int.parse(json['type'].toString()),
      perCustom: int.parse(json['perCustom'].toString()),
      CustomList: userList,
      maxSale: double.parse(json['maxSale'].toString()),
    );
  }

  void Setdata(Voucher vouchers) {
    id = vouchers.id;
    Money = vouchers.Money;
    mincost = vouchers.mincost;
    startTime = vouchers.startTime;
    endTime = vouchers.endTime;
    useCount = vouchers.useCount;
    maxCount = vouchers.maxCount;
    eventName = vouchers.eventName;
    type = vouchers.type;
    perCustom = vouchers.perCustom;
    CustomList = vouchers.CustomList;
    maxSale = vouchers.maxSale;
  }

  void changeToDefault() {
    id = '';
    Money = 0;
    mincost = 0;
    startTime = Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0);
    endTime = Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0);
    useCount = 0;
    maxCount = 0;
    eventName = '';
    type = 0;
    perCustom = 0;
    CustomList = [];
    maxSale = 0;
  }
}