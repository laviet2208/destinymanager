import '../otherData/Time.dart';

class ProductType {
  String id;
  Time createTime;
  String name;
  String image;

  ProductType({
    required this.id,
    required this.createTime,
    required this.name,
    required this.image,
  });

  Map<dynamic, dynamic> toJson() => {
    'id': id,
    'createTime': createTime.toJson(),
    'name': name,
    'image': image,
  };

  factory ProductType.fromJson(Map<dynamic, dynamic> json) {
    return ProductType(
      id: json['id'].toString(),
      createTime: Time.fromJson(json['createTime']),
      name: json['name'].toString(),
      image: json['image'].toString(),
    );
  }
}