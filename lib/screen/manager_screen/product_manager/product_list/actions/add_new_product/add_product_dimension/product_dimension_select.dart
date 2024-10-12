import 'package:destinymanager/data/otherData/Tool.dart';
import 'package:destinymanager/data/product/Product.dart';
import 'package:destinymanager/screen/manager_screen/product_manager/product_list/actions/add_new_product/add_product_dimension/add_product_dimension.dart';
import 'package:destinymanager/screen/manager_screen/product_manager/product_list/actions/add_new_product/add_product_dimension/item_dimension.dart';
import 'package:flutter/material.dart';

class product_dimension_select extends StatefulWidget {
  final Product product;
  const product_dimension_select({super.key, required this.product});

  @override
  State<product_dimension_select> createState() => _product_dimension_selectState();
}

class _product_dimension_selectState extends State<product_dimension_select> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 60;
    return Container(
      width: width/4,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), // màu của shadow
            spreadRadius: 5, // bán kính của shadow
            blurRadius: 7, // độ mờ của shadow
            offset: Offset(0, 3), // vị trí của shadow
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),

          Padding(
            padding: EdgeInsets.only(left: 20, right: 10),
            child: Text(
              'Kích cỡ sản phẩm',
              style: TextStyle(
                fontFamily: 'muli',
                fontSize: 17,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: 10,),

          widget.product.dimensionList.isNotEmpty ? Container(
            child: ListView.builder(
              itemCount: widget.product.dimensionList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: 20, right: 10),
                  child: item_dimension(dimension: widget.product.dimensionList[index], index: index, deleteEvent: () { widget.product.dimensionList.removeAt(index); setState(() {}); Navigator.of(context).pop(); }, editEvent: () {setState(() {

                  });  },),
                );
              },
            ),
          ) : Padding(
            padding: EdgeInsets.only(left: 20, right: 10),
            child: Text(
              'Chưa thêm kích cỡ sản phẩm',
              style: TextStyle(
                fontFamily: 'muli',
                fontSize: 14,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: 10,),

          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Container(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return add_product_dimension(product: widget.product, event: () {setState(() {});  },);
                    },
                  );
                },
                child: Text(
                  'Thêm kích cỡ sản phẩm',
                  style: TextStyle(
                    fontFamily: 'muli',
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 20,),
        ],
      ),
    );
  }
}
