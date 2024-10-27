import 'package:destinymanager/general_ingredient/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class start_stop_flashsale extends StatefulWidget {
  final int voucherNum;
  const start_stop_flashsale({super.key, required this.voucherNum});

  @override
  State<start_stop_flashsale> createState() => _start_stop_flashsaleState();
}

class _start_stop_flashsaleState extends State<start_stop_flashsale> {
  List<String> productList = [];
  bool loading = false;
  int status = 0;

  Future<void> get_top_product_ui() async {
    final reference = FirebaseDatabase.instance.ref();
    DatabaseEvent snapshot = await reference.child('Flashsale').child('product').once();
    final dynamic data = snapshot.snapshot.value;
    productList.clear();
    for (final result in data) {
      productList.add(result.toString());
    }
    setState(() {

    });
  }

  void flash_sale_status() {
    final reference = FirebaseDatabase.instance.ref();
    reference.child('Flashsale').child('isStart').onValue.listen((event) {
      final dynamic orders = event.snapshot.value;
      status = int.parse(orders.toString());
      setState(() {

      });
    });
  }

  Future<void> check_if_can_start() async {
    setState(() {
      loading = true;
    });
    if (widget.voucherNum > 0) {
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
      await databaseRef.child('Flashsale').child('isStart').set(1);
      setState(() {
        loading = false;
      });
      toastMessage('Đã bắt đầu sale');
      Navigator.of(context).pop();
    } else {
      setState(() {
        loading = false;
      });
      toastMessage('Phải có tối thiếu 1 voucher và 1 sản phẩm');
    }
  }

  @override
  void initState() {
    flash_sale_status();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(status == 0 ? 'Xác nhận bắt đầu flash sale không?' : 'Xác nhận dừng flash sale không?'),
      actions: <Widget>[
        !loading ? TextButton(
          onPressed: () async {
            if (status == 1) {
              setState(() {
                loading = true;
              });
              DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
              await databaseRef.child('Flashsale').child('isStart').set(0);
              setState(() {
                loading = false;
              });
              toastMessage('Dừng flash sale thành công');
              Navigator.of(context).pop();
            } else {
              await check_if_can_start();
            }
          },
          child: Text('Xác nhận', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),),
        ) : CircularProgressIndicator(color: Colors.blueAccent,),

        !loading ? TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Hủy', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),),
        ) : CircularProgressIndicator(color: Colors.redAccent,),
      ],
    );
  }
}
