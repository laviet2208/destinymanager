import 'package:destinymanager/general_ingredient/heading_title.dart';
import 'package:destinymanager/screen/manager_screen/history_transaction_manager/item_transaction.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class history_transaction_manager extends StatefulWidget {
  const history_transaction_manager({super.key});

  @override
  State<history_transaction_manager> createState() => _history_transaction_managerState();
}

class _history_transaction_managerState extends State<history_transaction_manager> {
  List<String> keyList = [];

  void getData() {
    final reference = FirebaseDatabase.instance.ref();
    reference.child("Transaction").onChildAdded.listen((event) {
      final dynamic key = event.snapshot.key;
      if (key != null && !keyList.contains(key)) {
        keyList.add(key.toString());
        setState(() {});
      }
    });
    reference.child("Transaction").onChildRemoved.listen((event) {
      final dynamic key = event.snapshot.key;
      if (key != null && keyList.contains(key)) {
        keyList.remove(key);
        setState(() {});
      }
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
            right: 0,
            child: heading_title(numberColumn: 4, listTitle: ['Thông tin khách hàng','Thông tin yêu cầu','Trạng thái','Thao tác'], width: width, height: 50,),
          ),

          Positioned(
            top: 50,
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
                  return item_transaction(id: keyList.reversed.toList()[index], index: index, idList: keyList,);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
