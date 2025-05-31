import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../../../../data/Account/Account.dart';
import '../../../../../../data/chatData/chatRoom.dart';
import '../../../../../../data/chatData/messenger.dart';
import '../../../../../../data/otherData/Tool.dart';
import 'ingredient/Item_messenger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class chatRoomScreen extends StatefulWidget {
  final Account account;
  const chatRoomScreen({Key? key, required this.account}) : super(key: key);

  @override
  State<chatRoomScreen> createState() => _chatRoomScreenState();
}

class _chatRoomScreenState extends State<chatRoomScreen> {
  chatRoom room = chatRoom(account: Account(id: '', username: '', password: '', address: '', createTime: getCurrentTime(), money: 0, firstName: '', lastName: '', phoneNum: '', lockstatus: 0, voucherList: [], referralCode: ''), messengerList: []);

  String base64image = '';
  final ImagePicker _picker = ImagePicker();

  Future<String> uploadBase64Image({required String base64Data, String bucket = 'destinyusa', String folder = '',}) async {
    final bytes = base64Decode(base64Data);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final path = folder.isNotEmpty ? '$folder/$fileName' : fileName;
    print('đây là path: ' + path);
    try {
      final String storedPath = await Supabase.instance.client.storage.from(bucket).uploadBinary(path, bytes);
      print('đây là storedpath: ' + storedPath);
      final String publicUrl = Supabase.instance.client.storage.from(bucket).getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      throw Exception('Upload thất bại: $e');
    }
  }

  Future<void> _pickImageAndConvert() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final bytes = await image.readAsBytes();
      final base64Str = base64Encode(bytes);
      setState(() {
        base64image = base64Str;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi chọn ảnh: $e')),
      );
    }
  }

  bool Loading = false;
  void getChatRoom() {
    final reference = FirebaseDatabase.instance.ref();
    reference.child("Chatrooms").child(widget.account.id).onValue.listen((event) async {
      final dynamic Chatrooms = event.snapshot.value;
      room = chatRoom.fromJson(Chatrooms);
      setState(() {

      });
    });
  }

  Future<void> pushChatRooms(chatRoom room) async {
    final reference = FirebaseDatabase.instance.ref();
    await reference.child("Chatrooms").child(widget.account.id).set(room.toJson());
  }

  final messengerText = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChatRoom();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              color: Colors.white
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              width: 1,
                              color: Colors.grey.withOpacity(0.5)
                          )
                      )
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          top: 20,
                          bottom: 20,
                          right: 5,
                          child: GestureDetector(
                            child: Container(
                              width: 40,
                              child:!Loading ? Icon(
                                Icons.send,
                                color: messengerText.text.isNotEmpty ? Colors.blue : Colors.grey,
                              ) : CircularProgressIndicator(color: Colors.blue,),
                            ),
                            onTap: () async {
                              if (messengerText.text.isNotEmpty) {
                                messenger mes = messenger(type: 2, content: messengerText.text.toString());
                                room.messengerList.add(mes);
                                setState(() {
                                  Loading = true;
                                });
                                await pushChatRooms(room);

                                setState(() {
                                  Loading = false;
                                  messengerText.clear();
                                });
                              }
                            },
                          )
                      ),

                      Positioned(
                        top: 20,
                        bottom: 20,
                        left: 10,
                        right: 70,
                        child: Container(
                          child: TextFormField(
                            controller: messengerText,
                            onChanged: (newValue) => setState(() {}),
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'roboto',
                            ),
                            decoration: InputDecoration(
                              // Đổi Icon thành InkWell để bắt tap
                              prefixIcon: IconButton(
                                icon: Icon(Icons.image_outlined),
                                onPressed: () async {
                                  await _pickImageAndConvert();
                                  if (base64image != '') {
                                    setState(() {
                                      Loading = true;
                                    });
                                    String uploadURL = await uploadBase64Image(base64Data: base64image, folder: 'chatRooms/' + widget.account.id);
                                    messenger mes = messenger(type: 2, content: uploadURL);
                                    room.messengerList.add(mes);
                                    await pushChatRooms(room);
                                    setState(() {
                                      Loading = false;
                                    });
                                  }
                                },
                              ),
                              prefixIconConstraints: BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                              hintText: 'Enter text here',
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'roboto',
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 10,
                bottom: 85,
                left: 10,
                right: 10,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: room.messengerList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Item_messenger(mes: room.messengerList[index]),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}