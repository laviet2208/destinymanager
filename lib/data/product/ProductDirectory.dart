import '../otherData/Time.dart';

class ProductDirectory {
  String id;
  String name;
  int status; //0: đang ẩn, 1: đang hiện
  String image;
  Time createTime;

  ProductDirectory({required this.id, required this.status, required this.name, required this.createTime, required this.image});

  Map<dynamic, dynamic> toJson() => {
    'id': id,
    'createTime': createTime.toJson(),
    'image': image,
    'name': name,
    'status': status,
  };

  factory ProductDirectory.fromJson(Map<dynamic, dynamic> json) {
    return ProductDirectory(
      id: json['id'].toString(),
      createTime: Time.fromJson(json['createTime']),
      name: json['name'].toString(),
      status: int.parse(json['status'].toString()),
      image: json['image'].toString(),
    );
  }
}