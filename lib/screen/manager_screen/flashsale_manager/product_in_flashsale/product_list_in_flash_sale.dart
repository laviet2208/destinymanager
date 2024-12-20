import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../../data/product/Product.dart';
import '../../../../general_ingredient/heading_title.dart';
import 'actions/add_product_flashsale.dart';
import 'ingredient/item_product_flashsale.dart';

class product_list_in_flash_sale extends StatefulWidget {
  const product_list_in_flash_sale({super.key});

  @override
  State<product_list_in_flash_sale> createState() => _product_list_in_flash_saleState();
}

class _product_list_in_flash_saleState extends State<product_list_in_flash_sale> {
  List<String> productList = [];

  void get_top_product_ui() {
    final reference = FirebaseDatabase.instance.ref();
    reference.child('Flashsale').child('product').onValue.listen((event) {
      productList.clear();
      final dynamic orders = event.snapshot.value;
      for (final result in orders) {
        productList.add(result.toString());
      }
      setState(() {

      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_top_product_ui();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 20;
    double height = MediaQuery.of(context).size.height - 80;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: GestureDetector(
              child: Container(
                height: 40,
                width: 180,
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    border: Border.all()
                ),
                child: Center(
                  child: Text(
                    '+ Thêm flash products',
                    style: TextStyle(
                        fontFamily: 'muli',
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(content: add_product_flashsale(productList: productList,), title: Text('Chọn sản phẩm'),);
                  },
                );
              },
            ),
          ),

          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Container(
              width: width,
              height: 50,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 247, 250, 255),
                  border: Border.all(
                      width: 1,
                      color: Color.fromARGB(255, 225, 225, 226)
                  )
              ),
              child: heading_title(numberColumn: 3, listTitle: ['Thông tin sản phẩm', 'Hình ảnh', 'Thao tác'], width: width, height: 50),
            ),
          ),

          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255)
              ),
              child: ListView.builder(
                itemCount: productList.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return item_product_flashsale(index: index, id: productList[index], productList: productList, event: () { setState(() {}); },);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
