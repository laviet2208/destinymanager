import 'package:destinymanager/data/product/Product.dart';
import 'package:destinymanager/screen/manager_screen/product_manager/product_list/controller.dart';
import 'package:flutter/material.dart';

class delete_dimension extends StatefulWidget {
  final int index;
  final Product product;
  const delete_dimension({super.key, required this.index, required this.product});

  @override
  State<delete_dimension> createState() => _delete_dimensionState();
}

class _delete_dimensionState extends State<delete_dimension> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Xác nhận xóa'),
      content: Text('Xác nhận xóa kích cỡ này?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Không', style: TextStyle(color: Colors.red,),),
        ),
        TextButton(
          onPressed: () async {
            setState(() {
              loading = true;
            });
            widget.product.dimensionList.removeAt(widget.index);
            await product_manager_controller.change_productDimension(widget.product);
            setState(() {
              loading = false;
            });
            Navigator.of(context).pop();
          },
          child: !loading ? Text('Có', style: TextStyle(color: Colors.blueAccent,),) : CircularProgressIndicator(color: Colors.blueAccent,),
        ),
      ],
    );
  }
}
