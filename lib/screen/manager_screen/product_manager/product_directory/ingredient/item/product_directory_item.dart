import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../../../../data/otherData/Tool.dart';
import '../../../../../../data/product/ProductDirectory.dart';
import '../../../../../../general_ingredient/text_line_in_item.dart';
import '../../actions/change_directory_name/change_directory_name.dart';
import '../view_product_list/directory_view_product_list.dart';

class product_directory_item extends StatefulWidget {
  final String id;
  final int index;
  final ProductDirectory directory;
  const product_directory_item({super.key, required this.id, required this.index, required this.directory,});

  @override
  State<product_directory_item> createState() => _product_directory_itemState();
}

class _product_directory_itemState extends State<product_directory_item> {
  ProductDirectory directory = ProductDirectory(id: '', name: '', createTime: getCurrentTime(), status: 1);

  void get_directory_data() {
    final reference = FirebaseDatabase.instance.ref();
    reference.child("productDirectory").child(widget.id).onValue.listen((event) {
      final dynamic data = event.snapshot.value;
      directory = ProductDirectory.fromJson(data);
      setState(() {

      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_directory_data();
  }
  
  @override
  Widget build(BuildContext context) {
    double height = 100;
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

                  text_line_in_item(color: Colors.black,title: 'Tên danh mục: ', content: directory.name),
                  
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
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: ListView(
                children: [
                  Container(height: 4,),

                  text_line_in_item(color: Colors.black,title: 'Thời gian tạo: ', content: getAllTimeString(directory.createTime)),

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
              padding: EdgeInsets.only(left: 5, right: 15),
              child: ListView(
                children: [
                  Container(height: 10,),

                  GestureDetector(
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          border: Border.all(width: 0.5, color: Colors.black)
                      ),
                      child: Center(
                        child: Text(
                          'Thay đổi tên',
                          style: TextStyle(
                            fontFamily: 'muli',
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return change_directory_name(directory: directory);
                        },
                      );
                    },
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
