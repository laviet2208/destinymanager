import 'package:auto_size_text/auto_size_text.dart';
import 'package:destinymanager/general_ingredient/textfield_type_1.dart';
import 'package:destinymanager/screen/main_screen/main_manager_screen.dart';
import 'package:flutter/material.dart';

import '../../general_ingredient/utils.dart';

class enter_pass extends StatefulWidget {
  const enter_pass({super.key});

  @override
  State<enter_pass> createState() => _enter_passState();
}

class _enter_passState extends State<enter_pass> {
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: height/3,
              bottom: height/3,
              left: (width - 400)/2,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4), // màu của shadow
                      spreadRadius: 5, // bán kính của shadow
                      blurRadius: 7, // độ mờ của shadow
                      offset: Offset(0, 3), // vị trí của shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10,),

                    Container(
                      height: 25,
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        'Mật khẩu hệ thống Destiny USA',
                        style: TextStyle(
                          fontFamily: 'muli',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 100,
                        ),
                      ),
                    ),

                    SizedBox(height: 10,),

                    Padding(
                      padding: EdgeInsets.only(left: 30, right: 30,),
                      child: textfield_type_1(title: 'Mật khẩu', hint: 'Nhập mật khẩu', controller: passController),
                    ),

                    SizedBox(height: 10,),

                    Padding(
                      padding: EdgeInsets.only(left: 30, right: 30,),
                      child: GestureDetector(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(width: 1),
                          ),
                          child: Center(
                            child: Text(
                              'Đăng nhập',
                              style: TextStyle(
                                fontFamily: 'muli',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          if (passController.text.toString() == 'namluc87') {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => main_manager_screen()),);
                          } else {
                            toastMessage('Vui lòng kiểm tra lại mật khẩu');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
