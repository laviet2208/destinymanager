import 'dart:convert';
import 'dart:typed_data';

import 'package:destinymanager/data/product/Product.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../../../data/otherData/Tool.dart';
import '../../../../../data/product/ProductDirectory.dart';
import '../../../../../general_ingredient/text_line_in_item.dart';
import '../../../../../general_ingredient/utils.dart';

class item_top_product extends StatefulWidget {
  final String id;
  final int index;
  final List<Product> productList;
  final VoidCallback event;
  const item_top_product({super.key, required this.id, required this.index, required this.productList, required this.event});

  @override
  State<item_top_product> createState() => _item_top_productState();
}

class _item_top_productState extends State<item_top_product> {
  Product product = Product(id: '', name: '', productType: '', showStatus: 0, createTime: getCurrentTime(), description: '', productDirectory: '', dimensionList: [], imageList: []);

  void get_product_data() {
    final reference = FirebaseDatabase.instance.ref();
    reference.child("productList").child(widget.id).onValue.listen((event) {
      final dynamic data = event.snapshot.value;
      product = Product.fromJson(data);
      Product product1 = Product(id: product.id, name: product.name, productType: '', showStatus: 1, createTime: product.createTime, description: '', productDirectory: '', dimensionList: [], imageList: [product.imageList[0]]);
      final reference1 = FirebaseDatabase.instance.ref();
      reference1.child('UI').child('productTop').child(widget.index.toString()).set(product1.toJson());
      setState(() {

      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_product_data();
  }

  @override
  Widget build(BuildContext context) {
    double height = 120;
    double width = MediaQuery.of(context).size.width - 20;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: widget.index % 2 == 0 ? Colors.white : Color.fromARGB(255, 247, 250, 255),
        border: Border.all(
          color: Color.fromARGB(255, 240, 240, 240),
          width: 1.0,
        ),
      ),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            width: 49,
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
              child: Center(
                child: Text(
                  (widget.index + 1).toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'muli',
                    color: Colors.black,
                    fontWeight: FontWeight.bold, // Để in đậm
                  ),
                ),
              ),
            ),
          ),

          Container(
            width: 1,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 240, 240, 240)
            ),
          ),

          Container(
            width: (width - 50)/3-1,
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: ListView(
                children: [
                  Container(height: 4,),

                  text_line_in_item(color: Colors.black,title: 'Mã sản phẩm: ', content: product.id),

                  Container(height: 4,),

                  text_line_in_item(color: Colors.black,title: 'Tên sản phẩm: ', content: product.name),

                  Container(height: 10,),
                ],
              ),
            ),
          ),

          Container(
            width: 1,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 240, 240, 240)
            ),
          ),

          Container(
            width: (width - 50)/3-1,
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5,),
                ),
                alignment: Alignment.center,
                child: Image.network(product.imageList[0]),
              ),
            ),
          ),

          Container(
            width: 1,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 240, 240, 240)
            ),
          ),

          Container(
            width: (width - 50)/3-1,
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 5),
              child: ListView(
                children: [
                  Container(height: 10,),

                  TextButton(
                    onPressed: () async {
                      if (widget.productList.length == 1) {
                        toastMessage('Phải có tối thiểu 1 sản phẩm');
                      } else {
                        widget.productList.removeAt(widget.index);
                        DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
                        await databaseRef.child('UI').child('productTop').set(widget.productList.map((e) => e.toJson()).toList());
                        toastMessage('Xóa thành công');
                        widget.event();
                      }
                    },
                    child: Text(
                      'Bỏ hiển thị',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),

                  Container(height: 10,),
                ],
              ),
            ),
          ),

          Container(
            width: 1,
            decoration: BoxDecoration(
              // color: Colors.redAccent,
              color: Color.fromARGB(255, 240, 240, 240),
            ),
          ),
        ],
      ),
    );
  }
}
