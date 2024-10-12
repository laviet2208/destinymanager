
import '../otherData/Time.dart';
import 'Dimension.dart';

class Product {
  String id;
  Time createTime;
  String name;
  String description;
  int showStatus; //trạng thái hiển thị
  String productType; //phân loại sản phẩm
  String productDirectory;
  List<Dimension> dimensionList;
  List<String> imageList;

  Product({required this.id, required this.name, required this.productType, required this.showStatus, required this.createTime, required this.description, required this.productDirectory, required this.dimensionList, required this.imageList});

  Map<dynamic, dynamic> toJson() => {
    'id': id,
    'createTime': createTime.toJson(),
    'name': name,
    'description': description,
    'dimensionList': dimensionList.map((e) => e.toJson()).toList(),
    'showStatus': showStatus,
    'productType': productType,
    'productDirectory': productDirectory,
    'imageList': imageList.map((e) => e).toList(),
  };

  factory Product.fromJson(Map<dynamic, dynamic> json) {
    List<String> imageList = [];
    List<Dimension> dimensionList = [];

    if (json["imageList"] != null) {
      for (final result in json["imageList"]) {
        imageList.add(result.toString());
      }
    }

    if (json["dimensionList"] != null) {
      for (final result in json["dimensionList"]) {
        dimensionList.add(Dimension.fromJson(result));
      }
    }

    return Product(
      id: json['id'].toString(),
      createTime: Time.fromJson(json['createTime']),
      name: json['name'].toString(),
      showStatus: int.parse(json['showStatus'].toString()),
      productType: json['productType'].toString(),
      description: json['description'].toString(),
      productDirectory: json['productDirectory'].toString(),
      dimensionList: dimensionList,
      imageList: imageList,
    );
  }
}