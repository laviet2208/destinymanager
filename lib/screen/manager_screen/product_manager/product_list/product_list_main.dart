import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:destinymanager/screen/manager_screen/product_manager/product_list/actions/add_new_product/add_new_product.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../../data/product/Product.dart';
import '../../../../general_ingredient/heading_title.dart';
import 'ingredient/item_product.dart';

class product_list_main extends StatefulWidget {
  const product_list_main({super.key});

  @override
  State<product_list_main> createState() => _product_list_mainState();
}

class _product_list_mainState extends State<product_list_main> {
  List<Product> productList = [];
  List<Product> chosenList = [];
  List<String> keyList = [];
  List<String> title = ['Tên sản phẩm', 'Kích cỡ và hình ảnh', 'Danh mục và phân loại', 'Thao tác'];

  void getData() {
    final reference = FirebaseDatabase.instance.ref();
    int totalDataSize = 0;

    reference.child("productList").onChildAdded.listen((event) {
      final dynamic key = event.snapshot.key;

      if (key != null && !keyList.contains(key)) {
        keyList.add(key.toString());

        // Tính kích thước dữ liệu
        String jsonString = jsonEncode(key.toString());
        totalDataSize += utf8.encode(jsonString).length;

        setState(() {});
      }
    });

    reference.child("productList").onChildRemoved.listen((event) {
      final dynamic key = event.snapshot.key;

      if (key != null && keyList.contains(key)) {
        keyList.remove(key);

        // Tính kích thước dữ liệu
        String jsonString = jsonEncode(key.toString());
        totalDataSize += utf8.encode(jsonString).length;

        setState(() {});
      }
    });
  }

  void sortChosenListByCreateTime(List<Product> chosenList) {
    chosenList.sort((a, b) {
      // Sắp xếp theo thời gian tạo giảm dần (mới nhất lên đầu)
      return b.createTime.year.compareTo(a.createTime.year) != 0
          ? b.createTime.year.compareTo(a.createTime.year)
          : (b.createTime.month.compareTo(a.createTime.month) != 0
          ? b.createTime.month.compareTo(a.createTime.month)
          : (b.createTime.day.compareTo(a.createTime.day) != 0
          ? b.createTime.day.compareTo(a.createTime.day)
          : (b.createTime.hour.compareTo(a.createTime.hour) != 0
          ? b.createTime.hour.compareTo(a.createTime.hour)
          : (b.createTime.minute.compareTo(a.createTime.minute) != 0
          ? b.createTime.minute.compareTo(a.createTime.minute)
          : b.createTime.second.compareTo(a.createTime.second)))));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
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
                    '+ Thêm sản phẩm',
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
                // Navigator.pushNamed(context, 'admin/addproduct');
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => add_new_product()),);

              },
            ),
          ),

          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Container(
              width: width - 20,
              height: 50,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 247, 250, 255),
                  border: Border.all(
                      width: 1,
                      color: Color.fromARGB(255, 225, 225, 226)
                  )
              ),
              child: Container(
                width: width,
                height: 50,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 247, 250, 255),
                    border: Border.all(
                        width: 0.5,
                        color: Color.fromARGB(255, 225, 225, 226)
                    )
                ),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: 49,
                    ),

                    Container(
                      width: 1,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 225, 225, 226)
                      ),
                    ),

                    Container(
                      width: width - 50,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Container(
                            width: index != 1 ? ((width - 50)/(title.length.toDouble()+1)) : (((width - 50)/(title.length.toDouble()+1))*2),
                            child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              children: [
                                Container(
                                  width: index != 1 ? ((width - 50)/(title.length.toDouble()+1) - 1) : (((width - 50)/(title.length.toDouble()+1))*2 - 1),
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 10, right: 10, top: 13, bottom: 13),
                                      child: AutoSizeText(
                                        title[index],
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'muli',
                                          color: Colors.black,
                                          fontSize: 100,
                                        ),
                                      ),
                                  ),
                                  alignment: Alignment.center,
                                ),

                                Container(
                                  width: 1,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 225, 225, 226),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
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
                itemCount: keyList.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return item_product(id: keyList.reversed.toList()[index], index: index, voidCallback: () {setState(() {

                  });  }, productList: productList,);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
