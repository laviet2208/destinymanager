import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import '../../../../../../data/product/ProductType.dart';
import '../../../../../../general_ingredient/textfield_type_1.dart';
import '../../../../../../general_ingredient/utils.dart';

class edit_product_type extends StatefulWidget {
  final ProductType type;
  final VoidCallback event;
  const edit_product_type({super.key, required this.type, required this.event});

  @override
  State<edit_product_type> createState() => _edit_product_typeState();
}

class _edit_product_typeState extends State<edit_product_type> {
  bool loading = false;
  final nameController = TextEditingController();
  Uint8List? registrationImage;

  Future<Uint8List?> galleryImagePicker() async {
    Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
    return bytesFromPicker;
  }

  Future<void> push_new_producttype(ProductType type) async{
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
      await databaseRef.child('productType').child(type.id).set(type.toJson());
      setState(() {
        loading = false;
      });
      toastMessage('Thêm loại sản phẩm thành công');
    } catch (error) {
      print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
      throw error;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.type.name;
    registrationImage =  Uint8List.fromList(base64Decode(widget.type.image));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cập nhật', style: TextStyle(fontFamily: 'muli'),),
      content: Container(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            textfield_type_1(title: 'Nhập tên phân loại sản phẩm mới', hint: 'Tên phân loại sản phẩm', controller: nameController),

            SizedBox(height: 10,),

            Padding(
              padding: EdgeInsets.only(left: 80, right: 80),
              child: GestureDetector(
                child: Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child:registrationImage == null
                        ? Icon(Icons.image_outlined, size: 20.0, color: Colors.black,)
                        : Image.memory(registrationImage!, fit: BoxFit.fitHeight,),
                  ),
                ),
                onTap: () async {
                  final Uint8List? image = await galleryImagePicker();

                  if (image != null) {
                    registrationImage = image;
                    toastMessage('Thêm ảnh thành công');
                    setState(() {});
                  }
                },
              ),
            ),

            SizedBox(height: 10,),

            Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Lưu ý: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'muli',
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    TextSpan(
                      text: 'Nên chọn ảnh phân loại là ảnh tỉ lệ 1-1 và đã được xóa background để hiển thị trong app được đẹp nhất',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'muli',
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10,),
          ],
        ),
      ),
      actions: <Widget>[
        if (!loading) TextButton(
          child: Text('Đồng ý', style: TextStyle(color: Colors.blue),),
          onPressed: () async {
            if (!loading) {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  loading = true;
                });
                ProductType type = ProductType(id: widget.type.id, createTime: widget.type.createTime, name: nameController.text.toString(), image: '',);
                type.image = base64Encode(registrationImage!);
                await push_new_producttype(type);
                setState(() {
                  loading = false;
                });
                toastMessage('Sửa thành công');
                widget.event();
                Navigator.of(context).pop();
              } else {
                toastMessage('Bạn chưa điền loại sản phẩm');
              }
            } else {

            }
          },
        ) else CircularProgressIndicator(color: Colors.blue,),

        !loading ? TextButton(
          child: Text('Hủy', style: TextStyle(color: Colors.red),),
          onPressed: () async {
            if (!loading) {
              Navigator.of(context).pop();
            } else {

            }
          },
        ) : CircularProgressIndicator(color: Colors.red,),
      ],
    );
  }
}
