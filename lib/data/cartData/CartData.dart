import '../product/Dimension.dart';
import '../product/Product.dart';

class Cartdata {
  Product product;
  Dimension dimension;
  int number;

  Cartdata({required this.product, required this.dimension, required this.number});

  Map<dynamic, dynamic> toJson() => {
    'product': product.toJson(),
    'number': number,
    'dimension': dimension.toJson(),
  };

  factory Cartdata.fromJson(Map<dynamic, dynamic> json) {
    return Cartdata(
      product: Product.fromJson(json['product']),
      number: int.parse(json['number'].toString()),
      dimension: Dimension.fromJson(json['dimension']),
    );
  }
}