
import '../otherData/Time.dart';

class AdsData {
  String id;
  String productId;
  String image;
  Time createTime;
  int status;

  AdsData({required this.id, required this.productId, required this.createTime, required this.status, required this.image});

  Map<dynamic, dynamic> toJson() => {
    'id': id,
    'createTime': createTime.toJson(),
    'productId': productId,
    'status': status,
    'image': image,
  };

  factory AdsData.fromJson(Map<dynamic, dynamic> json) {
    return AdsData(
      id: json['id'].toString(),
      createTime: Time.fromJson(json['createTime']),
      productId: json['productId'].toString(),
      status: int.parse(json['status'].toString()),
      image: json['image'].toString(),
    );
  }
}