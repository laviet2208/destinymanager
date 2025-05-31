import 'package:destinymanager/data/historyData/Transaction.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../../data/Account/Account.dart';
import '../../../../data/MoneyRequest/MoneyRequest.dart';
import '../../../../data/otherData/Tool.dart';
import '../../../../general_ingredient/text_line_in_item.dart';

class item_transaction extends StatefulWidget {
  final String id;
  final int index;
  final List<String> idList;
  const item_transaction({super.key, required this.id, required this.index, required this.idList});

  @override
  State<item_transaction> createState() => _item_transactionState();
}

class _item_transactionState extends State<item_transaction> {
  TransactionHis transaction = TransactionHis(id: '', content: '', money: 0, owner: '' , type: 0);
  String status = '';
  Color statusColor = Colors.white;

  void get_transaction() {
    if (widget.id != '') {
      final reference = FirebaseDatabase.instance.ref();
      reference.child("Transaction").child(widget.id).onValue.listen((event) {
        final dynamic data = event.snapshot.value;
        transaction = TransactionHis.fromJson(data);
        setState(() {

        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_transaction();
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
            width: (width - 50)/4-1,
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: ListView(
                children: [
                  Container(height: 4,),

                  text_line_in_item(color: Colors.black,title: 'Mã tài khoản : ', content: transaction.owner),

                  Container(height: 4,),

                  text_line_in_item(color: transaction.type == 0 ? Colors.red : Colors.green, title: 'Loại giao dịch: ', content: transaction.type == 0 ? 'Trừ tiền' : 'Cộng tiền'),

                  Container(height: 4,),

                  text_line_in_item(color: Colors.black,title: 'Số tiền: ', content: getStringNumber(transaction.money)),

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
            width: (width - 50)/4-1,
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: ListView(
                children: [
                  Container(height: 4,),

                  text_line_in_item(color: Colors.black,title: 'Mã yêu cầu : ', content: transaction.id),

                  Container(height: 8,),

                  text_line_in_item(color: Colors.black, title: 'Nội dung: ', content: transaction.content),

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
            width: (width - 50)/4-1,
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: statusColor,
                    width: 2
                  ),
                ),
                child: Center(
                  child: Text(
                    status,
                    style: TextStyle(
                      fontFamily: 'muli',
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
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
            width: (width - 50)/4-1,
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
                          color: Colors.redAccent,
                        ),
                        child: Center(
                          child: Text(
                            'Xóa yêu cầu',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Xác Nhận Xóa'),
                              content: Text('Bạn có chắc chắn muốn xóa không?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Hủy'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Xóa'),
                                  onPressed: () async {
                                    DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
                                    await databaseRef.child('Transaction').child(widget.id).remove();
                                    widget.idList.remove(widget.id);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
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
        ],
      ),
    );
  }
}
