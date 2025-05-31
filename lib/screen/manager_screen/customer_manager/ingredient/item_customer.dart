import 'package:destinymanager/general_ingredient/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../../data/Account/Account.dart';
import '../../../../data/chatData/messenger.dart';
import '../../../../data/otherData/Time.dart';
import '../../../../data/otherData/Tool.dart';
import '../../../../general_ingredient/text_line_in_item.dart';
import '../actions/change_account_money.dart';
import '../actions/view_account_info.dart';
import 'chat_manager/chat_room/chat_room.dart';
import 'delete_customer/delete_account.dart';
import 'voucher_manager/voucher_manager.dart';

class item_customer extends StatefulWidget {
  final String id;
  final List<String> list;
  final int index;
  const item_customer({super.key, required this.id, required this.index, required this.list});

  @override
  State<item_customer> createState() => _item_customerState();
}

class _item_customerState extends State<item_customer> {
  Account account = Account(id: '', username: '', password: '', address: '', createTime: Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0), money: 0, firstName: '', lastName: '', phoneNum: '', lockstatus: 0, voucherList: [], referralCode: '');
  bool haveMes = false;
  void get_account() {
    if (widget.id != '') {
      final reference = FirebaseDatabase.instance.ref();
      reference.child("Account").child(widget.id).onValue.listen((event) {
        final dynamic data = event.snapshot.value;
        print(data.toString());
        account = Account.fromJson(data);
        setState(() {

        });
      });
    }
  }

  void getMes() {
    if (widget.id.isEmpty) return;

    final ref = FirebaseDatabase.instance
        .ref('Chatrooms/${widget.id}/messengerList')
        .orderByKey()
        .limitToLast(1);

    ref.onValue.listen((event) {
      final children = event.snapshot.children.toList();

      if (children.isEmpty) {
        setState(() => haveMes = false);
        return;
      }

      // children.first vì limitToLast(1) chỉ trả về 1 phần tử
      final lastSnap = children.first;
      // ép về Map<String, dynamic> cho fromJson xài
      final json = Map<String, dynamic>.from(lastSnap.value as Map);
      final mes = messenger.fromJson(json);

      print('Nội dung: ${mes.content}');
      setState(() {
        haveMes = mes.type == 1;
      });
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_account();
    getMes();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 20;
    double height = 130;
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

                  text_line_in_item(color: Colors.black,title: 'Mã KH: ', content: account.id),

                  Container(height: 4,),

                  text_line_in_item(color: Colors.black,title: 'Email : ', content: account.username),

                  Container(height: 4,),

                  text_line_in_item(color: Colors.black, title: 'Mật khẩu: ', content: account.password),

                  Container(height: 4,),

                  text_line_in_item(color: Colors.black,title: 'Số dư: ', content: getStringNumber(account.money) + '.usd'),

                  Container(height: 4,),
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

                  text_line_in_item(color: Colors.black,title: 'Mã GT : ', content: account.referralCode),

                  Container(height: 8,),

                  text_line_in_item(color: Colors.black,title: 'Tên KH : ', content: account.firstName + ' ' + account.lastName),

                  Container(height: 8,),

                  text_line_in_item(color: Colors.black, title: 'Địa chỉ: ', content: account.address != '' ? account.address : 'Chưa nhập'),

                  Container(height: 8,),

                  text_line_in_item(color: Colors.black,title: 'Sđt: ', content: account.phoneNum != '' ? account.phoneNum : 'Chưa nhập'),

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

                  text_line_in_item(color: account.lockstatus == 2 ? Colors.green : Colors.red, title: 'Trạng thái : ', content: account.lockstatus == 0 ? 'Tài khoản đang khóa' : (account.lockstatus == 1 ? 'Chưa nhập mã' : 'Tài khoản đang mở')),

                  Container(height: 8,),

                  TextButton(
                    onPressed: () async {
                      if (account.lockstatus == 1) {
                        toastMessage('Không thể khóa tài khoản chưa kích hoạt');
                      }
                      if (account.lockstatus == 2) {
                        final reference = FirebaseDatabase.instance.ref();
                        await reference.child('Account').child(account.id).child('lockstatus').set(0);
                        toastMessage('Khóa thành công');
                        setState(() {

                        });
                      } else {
                        final reference = FirebaseDatabase.instance.ref();
                        await reference.child('Account').child(account.id).child('lockstatus').set(2);
                        toastMessage('Mở thành công');
                        setState(() {

                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Khóa, mở tài khoản',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return change_account_money(account: account);
                        },
                      );
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Cộng, trừ tiền',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
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
                          color: Colors.white,
                          border: Border.all(
                              width: 1,
                              color: Colors.black
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Thông tin chi tiết',
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
                            return view_account_info(account: account);
                          },
                        );
                      },
                    ),
                  ),

                  Container(height: 4,),

                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: GestureDetector(
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(
                              width: 1,
                              color: Colors.black
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Quản lý voucher',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return voucher_manager(account: account);
                          },
                        );
                      },
                    ),
                  ),

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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Chat với KH',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),

                              SizedBox(width: 10,),

                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: haveMes ? Colors.red : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Container(
                                width: 400,
                                height: 800,
                                child: chatRoomScreen(account: account),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {Navigator.of(context).pop();},
                                  child: Text('Đóng'),
                                ),

                                TextButton(
                                  onPressed: () async {
                                    final reference = FirebaseDatabase.instance.ref('Chatrooms/${widget.id}');
                                    await reference.remove();
                                    toastMessage('Xóa thành công');
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Xóa tin nhắn'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),

                  Container(height: 4,),

                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: GestureDetector(
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border.all(
                              width: 1,
                              color: Colors.red
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Xoá tài khoản',
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
                                    await databaseRef.child('Account').child(widget.id).remove();
                                    widget.list.remove(widget.id);
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

                  Container(height: 4,),
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
