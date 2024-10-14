import 'package:firebase_database/firebase_database.dart';

import '../../data/product/Product.dart';

class ProductDataInteractFb {
  /// This class was born only contain functions for interact between firebase realtime database with product's data
  /// GetAllProductData
  static Future<List<Product>> GetAllProductData() async {
    final reference = FirebaseDatabase.instance.ref();
    DatabaseEvent snapshot = await reference.child("productList").once();
    print('Gọi hàm lấy type thành công');
    final dynamic data = snapshot.snapshot.value;
    List<Product> dataList = [];
    if (data != null) {
      data.forEach((key, value) {
        Product product = Product.fromJson(value);
        if (product.showStatus != 0) {
          dataList.add(product);
        }
      });
    }
    return dataList;
  }
}