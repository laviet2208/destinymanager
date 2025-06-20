import 'package:destinymanager/general_ingredient/utils.dart';
import 'package:destinymanager/screen/manager_screen/product_manager/product_list/actions/add_new_product/select_product_type_and_directory/product_type_search.dart';
import 'package:destinymanager/screen/manager_screen/product_manager/product_list/actions/dimension_actions/delete_dimension.dart';
import 'package:destinymanager/screen/manager_screen/product_manager/product_list/actions/dimension_actions/update_dimension.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../../../data/otherData/Tool.dart';
import '../../../../../data/otherdata/Time.dart';
import '../../../../../data/product/DataChangeHistory.dart';
import '../../../../../data/product/Product.dart';
import '../../../../../general_ingredient/text_line_in_item.dart';
import '../actions/add_new_product/select_product_type_and_directory/product_directory_search.dart';
import '../actions/change_name_and_description/change_name_and_description.dart';
import '../controller.dart';

class item_product extends StatefulWidget {
  final String id;
  final int index;
  final VoidCallback voidCallback;
  final List<Product> productList;
  const item_product({super.key, required this.index, required this.id, required this.voidCallback, required this.productList});

  @override
  State<item_product> createState() => _item_productState();
}

class _item_productState extends State<item_product> {
  String productType = 'Lỗi tên phân loại';
  String productDirect = 'Lỗi tên phân loại';
  Product product = Product(id: generateID(15), name: '', productType: '', showStatus: 0, createTime: getCurrentTime(), description: '', productDirectory: '', dimensionList: [], imageList: [],);

  void get_product() {
    if (widget.id != '') {
      final reference = FirebaseDatabase.instance.ref();

      reference.child("productList").child(widget.id).onValue.listen((event) {
        final dynamic data = event.snapshot.value;
        product = Product.fromJson(data);
        get_type_name();
        setState(() {

        });
      });
    }
  }

  void get_type_name() {
    if (product.productType != '') {
      final reference = FirebaseDatabase.instance.ref();
      reference.child("productType").child(product.productType).child('name').onValue.listen((event) {
        final dynamic data = event.snapshot.value;
        productType = data.toString();
        setState(() {

        });
      });
    }
  }

  void get_direct_name() {
    if (product.productType != '') {
      final reference = FirebaseDatabase.instance.ref();
      reference.child("productDirectory").child(product.productDirectory).child('name').onValue.listen((event) {
        final dynamic data = event.snapshot.value;
        productDirect = data.toString();
        setState(() {

        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_product();
    get_type_name();
    get_direct_name();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 20;
    double height = 150;
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
            width: (width - 50)/5-1,
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: ListView(
                children: [
                  Container(height: 4,),

                  text_line_in_item(color: Colors.black,title: 'Mã sản phẩm: ', content: product.id),

                  Container(height: 8,),

                  text_line_in_item(color: Colors.black,title: 'Tên sản phẩm: ', content: product.name),

                  Container(height: 8,),

                  text_line_in_item(color: product.showStatus == 0 ? Colors.redAccent : Colors.blueAccent, title: 'Trạng thái hiển thị: ', content: product.showStatus == 0 ? 'Đang ẩn' : 'Đang hiện'),

                  Container(height: 8,),

                  text_line_in_item(color: Colors.black, title: 'Tạo lúc: ', content: getAllTimeString(product.createTime)),

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
            width: ((width - 50)/5)*2-1-200,
            child: Padding(
              padding: EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 10,),
              child: ListView.builder(
                itemCount: product.dimensionList.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 0.5,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Tên phân loại: ',
                                      style: TextStyle(
                                        fontFamily: 'muli',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),

                                    TextSpan(
                                      text: product.dimensionList[index].name + ' ,',
                                      style: TextStyle(
                                        fontFamily: 'muli',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                      ),
                                    ),

                                    TextSpan(
                                      text: 'Giá tiền thực: ',
                                      style: TextStyle(
                                        fontFamily: 'muli',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),

                                    TextSpan(
                                      text: getStringNumber(product.dimensionList[index].cost) + '.USDT, ',
                                      style: TextStyle(
                                        fontFamily: 'muli',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                      ),
                                    ),

                                    TextSpan(
                                      text: 'Tồn kho: ',
                                      style: TextStyle(
                                        fontFamily: 'muli',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),

                                    TextSpan(
                                      text: product.dimensionList[index].inventory.toString(),
                                      style: TextStyle(
                                        fontFamily: 'muli',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                              ),
                            ),
                          ),
                        ),

                        Container(width: 0.5,),

                        GestureDetector(
                          child: Container(
                            width: 39.5,
                            child: Icon(
                              Icons.delete_outline_sharp,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return delete_dimension(index: index, product: product);
                              },
                            );
                          },
                        ),

                        Container(width: 0.5,),

                        GestureDetector(
                          child: Container(
                            width: 39.5,
                            child: Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return update_dimension(index: index, product: product);
                              },
                            );
                          },
                        )
                      ],
                    ),
                  );
                },
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
            width: 199,
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Image.network(product.imageList.first, fit: BoxFit.fitHeight,),
            ),
          ),

          Container(
            width: 1,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 240, 240, 240)
            ),
          ),

          Container(
            width: (width - 50)/5-1,
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: ListView(
                children: [
                  Container(height: 4,),

                  text_line_in_item(color: Colors.black,title: 'Danh mục: ', content: productDirect),

                  text_line_in_item(color: Colors.black,title: 'Phân loại: ', content: productType),

                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      child: Text(
                        'Sửa phân loại',
                        style: TextStyle(
                          fontFamily: 'muli',
                          color: Colors.blueAccent,
                          fontSize: 14,
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Sửa phân loại sp'),
                              content: Container(
                                width: 400,
                                height: 300,
                                child: product_type_search(product: product, event: () async {
                                  await product_manager_controller.change_productType(product);
                                  setState(() {get_type_name();});
                                  Navigator.of(context).pop();},
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      child: Text(
                        'Sửa danh mục',
                        style: TextStyle(
                          fontFamily: 'muli',
                          color: Colors.blueAccent,
                          fontSize: 14,
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Sửa danh mục sp'),
                              content: Container(
                                width: 400,
                                height: 300,
                                child: product_directory_search(product: product, event: () async {
                                  await product_manager_controller.change_productDirectory(product);
                                  setState(() {get_direct_name();});
                                  Navigator.of(context).pop();},
                                ),
                              ),
                            );
                          },
                        );
                      },
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
                color: Color.fromARGB(255, 240, 240, 240)
            ),
          ),

          Container(
            width: (width - 50)/5 - 10,
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: ListView(
                children: [
                  Container(height: 4,),

                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: GestureDetector(
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: Colors.black
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Cập nhật nội dung',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return change_name_and_description(product: product);
                          },
                        );
                      },
                    ),
                  ),

                  Container(height: 8,),

                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: GestureDetector(
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 1,
                              color: Colors.black
                          ),
                        ),
                        child: Center(
                          child: Text(
                            product.showStatus == 0 ? 'Hiện sản phẩm' : 'Ẩn sản phẩm',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (product.showStatus == 0) {
                          product.showStatus = 1;
                          await product_manager_controller.change_productShowStatus(product);
                        } else {
                          product.showStatus = 0;
                          await product_manager_controller.change_productShowStatus(product);
                        }
                      },
                    ),
                  ),

                  Container(height: 8,),

                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: GestureDetector(
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border.all(
                              width: 1,
                              color: Colors.black
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Xóa sản phẩm',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
                        await databaseRef.child('productList').child(product.id).remove();
                        toastMessage("xóa thành công");
                        widget.productList.remove(product);
                        widget.voidCallback();
                      },
                    ),
                  ),

                  Container(height: 8,),
                ],
              ),
            ),
          ),

          Container(
            width: 1,
            decoration: BoxDecoration(
                color: Colors.red
            ),
          ),
        ],
      ),
    );
  }
}
