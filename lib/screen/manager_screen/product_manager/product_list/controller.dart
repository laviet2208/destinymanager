import 'package:firebase_database/firebase_database.dart';

import '../../../../data/otherData/Tool.dart';
import '../../../../data/product/DataChangeHistory.dart';
import '../../../../data/product/Product.dart';

class product_manager_controller {
  static Future<void> push_history(DataChangeHistory datachange) async{
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref().child('DataChange');
      final snapshot = await databaseRef.limitToLast(1).get();
      print('data:  ' + snapshot.value.toString());
      if (snapshot.exists) {
        final dynamic data = snapshot.value;
        DataChangeHistory dataChangeHistory = DataChangeHistory(id: 0, timeHappend: getCurrentTime(), changeType: 0, productIdChange: '');
        data.forEach((key, value) {
          dataChangeHistory = DataChangeHistory.fromJson(value);
        });
        datachange.id = dataChangeHistory.id + 1;
      } else {
        datachange.id = 0;
      }
      databaseRef = FirebaseDatabase.instance.ref();
      await databaseRef.child('DataChange').child(datachange.id.toString()).set(datachange.toJson());
    } catch (error) {
      print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
      throw error;
    }
  }

  static Future<void> change_productType(Product product) async{
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
      DataChangeHistory dataChangeHistory = DataChangeHistory(id: 0, timeHappend: getCurrentTime(), changeType: 2, productIdChange: product.id);
      await push_history(dataChangeHistory);
      await databaseRef.child('productList').child(product.id).child('productType').set(product.productType);
    } catch (error) {
      print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
      throw error;
    }
  }

  static Future<void> change_productDimension(Product product) async{
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
      DataChangeHistory dataChangeHistory = DataChangeHistory(id: 0, timeHappend: getCurrentTime(), changeType: 2, productIdChange: product.id);
      await push_history(dataChangeHistory);
      await databaseRef.child('productList').child(product.id).child('dimensionList').set(product.dimensionList.map((e) => e.toJson()).toList());
    } catch (error) {
      print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
      throw error;
    }
  }

  static Future<void> change_productName(Product product) async {
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
      DataChangeHistory dataChangeHistory = DataChangeHistory(id: 0, timeHappend: getCurrentTime(), changeType: 2, productIdChange: product.id);
      await push_history(dataChangeHistory);
      await databaseRef.child('productList').child(product.id).child('name').set(product.name);
    } catch (error) {
      print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
      throw error;
    }
  }

  static Future<void> change_productDescription(Product product) async {
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
      DataChangeHistory dataChangeHistory = DataChangeHistory(id: 0, timeHappend: getCurrentTime(), changeType: 2, productIdChange: product.id);
      await push_history(dataChangeHistory);
      await databaseRef.child('productList').child(product.id).child('description').set(product.description);
    } catch (error) {
      print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
      throw error;
    }
  }

  static Future<void> change_productDirectory(Product product) async {
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
      DataChangeHistory dataChangeHistory = DataChangeHistory(id: 0, timeHappend: getCurrentTime(), changeType: 2, productIdChange: product.id);
      await push_history(dataChangeHistory);
      await databaseRef.child('productList').child(product.id).child('productDirectory').set(product.productDirectory);
    } catch (error) {
      print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
      throw error;
    }
  }

  static Future<void> change_productShowStatus(Product product) async {
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
      DataChangeHistory dataChangeHistory = DataChangeHistory(id: 0, timeHappend: getCurrentTime(), changeType: 2, productIdChange: product.id);
      await push_history(dataChangeHistory);
      await databaseRef.child('productList').child(product.id).child('showStatus').set(product.showStatus);
    } catch (error) {
      print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
      throw error;
    }
  }
}