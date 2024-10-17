import 'package:destinymanager/data/product/Product.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../../../general_ingredient/utils.dart';

class add_top_product extends StatefulWidget {
  final List<Product> productList;
  const add_top_product({super.key, required this.productList});

  @override
  State<add_top_product> createState() => _add_top_productState();
}

class _add_top_productState extends State<add_top_product> {
  String query = '';
  final control = TextEditingController();
  List<Product> filteredList = [];
  final List<Product> product_list = [];

  void get_directory_data() {
    final reference = FirebaseDatabase.instance.ref();
    reference.child("productList").onValue.listen((event) {
      product_list.clear();
      final dynamic orders = event.snapshot.value;
      orders.forEach((key, value) {
        Product product = Product.fromJson(value);
        if (!widget.productList.contains(product) && product.showStatus != 0) {
          product_list.add(product);
          filteredList = product_list.where((product) => product.name.toLowerCase().contains(query.toLowerCase())).toList();
        }
      });
      setState(() {

      });
    });
  }

  Future<void> push_new_list() async{
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
      await databaseRef.child('UI').child('productTop').set(widget.productList.map((e) => e.toJson()).toList());
      toastMessage('Cập nhật thành công');
    } catch (error) {
      print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
      throw error;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_directory_data();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Column(
          children: [
            TextField(
              controller: control,
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Tìm kiếm danh mục sản phẩm',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: ListTile(
                      title: Text(filteredList[index].name),
                      onTap: () async {
                        if (widget.productList.length == 5) {
                          toastMessage('Chỉ tối đa 5 top products');
                        } else {
                          toastMessage('Vui lòng đợi');
                          control.text = filteredList[index].name;
                          widget.productList.add(filteredList[index]);
                          await push_new_list();
                          setState(() {

                          });
                          toastMessage('Thêm thành công');
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}