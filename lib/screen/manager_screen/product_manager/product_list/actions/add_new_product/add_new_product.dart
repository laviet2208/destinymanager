import 'dart:convert';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:destinymanager/data/product/DataChangeHistory.dart';
import 'package:destinymanager/screen/main_screen/main_manager_screen.dart';
import 'package:destinymanager/screen/manager_screen/product_manager/product_list/actions/add_new_product/add_product_dimension/add_product_dimension.dart';
import 'package:destinymanager/screen/manager_screen/product_manager/product_list/actions/add_new_product/add_product_dimension/item_dimension.dart';
import 'package:destinymanager/screen/manager_screen/product_manager/product_list/actions/add_new_product/add_product_dimension/product_dimension_select.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import '../../../../../../data/otherData/Tool.dart';
import '../../../../../../data/product/Product.dart';
import '../../../../../../general_ingredient/rich_text_editor_type_1.dart';
import '../../../../../../general_ingredient/textfield_type_1.dart';
import '../../../../../../general_ingredient/utils.dart';
import 'add_product_image/select_product_image.dart';
import 'select_product_type_and_directory/select_product_directory.dart';
import 'select_product_type_and_directory/select_product_type.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class add_new_product extends StatefulWidget {
  const add_new_product({super.key,});

  @override
  State<add_new_product> createState() => _add_new_productState();
}

class _add_new_productState extends State<add_new_product> {
  bool showStatus = false;

  QuillEditorController controller = QuillEditorController();
  final nameController = TextEditingController();
  bool loading = false;
  final List<Uint8List> imageList = [];
  Product product = Product(id: '', name: '', productType: '', showStatus: 1, createTime: getCurrentTime(), description: '', productDirectory: '', dimensionList: [], imageList: []);

  bool check_if_fill_all() {
    if (nameController.text.isNotEmpty && product.imageList.isNotEmpty && product.productType != '' && product.productDirectory != '' && product.dimensionList.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<String> uploadBase64Image({required String base64Data, String bucket = 'destinyusa', String folder = '',}) async {
    final bytes = base64Decode(base64Data);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final path = folder.isNotEmpty ? '$folder/$fileName' : fileName;
    print('đây là path: ' + path);
    try {
      // uploadBinary trả về path lưu lên bucket dưới dạng String
      final String storedPath = await Supabase.instance.client.storage.from(bucket).uploadBinary(path, bytes);
      print('đây là storedpath: ' + storedPath);
      // getPublicUrl giờ cũng trả về String rồi, không có .data
      final String publicUrl = Supabase.instance.client.storage.from(bucket).getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      throw Exception('Upload thất bại: $e');
    }
  }

  Future<void> push_new_product(Product product) async{
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
      await databaseRef.child('productList').child(product.id).set(product.toJson());
    } catch (error) {
      print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
      throw error;
    }
  }

  Future<void> push_history(DataChangeHistory datachange) async{
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref().child('DataChange');
      final snapshot = await databaseRef.limitToLast(1).get();
      if (snapshot.exists) {
        final dynamic data = snapshot.value;
        DataChangeHistory dataChangeHistory = DataChangeHistory(id: 0, timeHappend: getCurrentTime(), changeType: 0, productIdChange: '');
        data.forEach((key, value) {
          dataChangeHistory = DataChangeHistory.fromJson(value);
        });
        datachange.id = dataChangeHistory.id + 1;
      } else {
        datachange.id = 0;
      }
      databaseRef = FirebaseDatabase.instance.ref();
      await databaseRef.child('DataChange').child(datachange.id.toString()).set(datachange.toJson());
    } catch (error) {
      print('Đã xảy ra lỗi khi đẩy catchOrder: $error');
      throw error;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String id = (DateTime.now().day >= 10 ? DateTime.now().day.toString() : ('0' + DateTime.now().day.toString())) + (DateTime.now().month >= 10 ? DateTime.now().month.toString() : ('0' + DateTime.now().month.toString())) + (DateTime.now().year >= 10 ? DateTime.now().year.toString() : ('0' + DateTime.now().year.toString())) + (DateTime.now().hour >= 10 ? DateTime.now().hour.toString() : ('0' + DateTime.now().hour.toString())) + (DateTime.now().minute >= 10 ? DateTime.now().minute.toString() : ('0' + DateTime.now().minute.toString())) + (DateTime.now().second >= 10 ? DateTime.now().second.toString() : ('0' + DateTime.now().second.toString()));
    product.id = 'SP' + id;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double width1 = MediaQuery.of(context).size.width - 60;
    double height = MediaQuery.of(context).size.height;
    double height1 = MediaQuery.of(context).size.height - 110;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 240, 242, 245),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: GestureDetector(
                  child: Container(
                    height: 15,
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(
                      '< Quay về trang chính',
                      style: TextStyle(
                        fontFamily: 'muli',
                        fontSize: 140,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => main_manager_screen()),);
                  },
                ),
              ),

              Positioned(
                top: 25,
                left: 0,
                child: GestureDetector(
                  child: Container(
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(
                      'Tạo mới sản phẩm',
                      style: TextStyle(
                        fontFamily: 'muli',
                        fontSize: 100,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  onTap: () {
                    // Navigator.pushNamed(context, 'admin/mainscreen');
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => main_manager_screen()),);

                  },
                ),
              ),

              Positioned(
                top: 75,
                bottom: 0,
                left: 0,
                child: Container(
                  width: width1/4,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(height: 10,),

                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: textfield_type_1(title: 'Tên sản phẩm mới', hint: 'Nhập tên sản phẩm', controller: nameController),
                            ),

                            Container(height: 10,),
                          ],
                        ),
                      ),

                      Container(height: 10,),

                      // product_dimension_select(product: product),

                      Container(
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
                                child: Row(
                                  children: [
                                    Text(
                                      'Kích cỡ sản phẩm',
                                      style: TextStyle(
                                        fontFamily: 'muli',
                                        fontSize: 17,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    SizedBox(width: 5,),

                                    GestureDetector(
                                      child: Icon(
                                        Icons.question_mark,
                                        color: Colors.red,
                                      ),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.white,
                                              insetPadding: EdgeInsets.zero,
                                              contentPadding: EdgeInsets.all(10),
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              content: Container(
                                                width: width/2,
                                                height: (width/2)/(1258/765),
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage('assets/hd/hdsd1.png'),
                                                    )
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {Navigator.of(context).pop();},
                                                  child: Text('Đóng', style: TextStyle(color: Colors.red),),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                )
                            ),

                            SizedBox(height: 10,),

                            product.dimensionList.isNotEmpty ? Container(
                              child: ListView.builder(
                                itemCount: product.dimensionList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(left: 20, right: 10),
                                    child: item_dimension(dimension: product.dimensionList[index], index: index, deleteEvent: () { product.dimensionList.removeAt(index); setState(() {}); Navigator.of(context).pop(); }, editEvent: () {setState(() {

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
                                        return add_product_dimension(product: product, event: () {setState(() {});  },);
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
                      ),

                      Container(height: 20,),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 75,
                bottom: 0,
                left: width1/4 + 10,
                child: Container(
                  width: width1/4,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        child: select_product_type(product: product,),
                      ),

                      Container(height: 20,),

                      Container(
                        child: select_product_directory(product: product,),
                      ),

                      Container(height: 20,),

                      Container(
                        child: select_product_image(imageList: product.imageList),
                      ),

                      Container(height: 30,),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 75,
                bottom: 0,
                left: width1/4 + 10 + width1/4 + 10,
                child: Container(
                  width: width1/2,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
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
                          children: [
                            Container(height: 10,),

                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Mô tả chi tiết sản phẩm',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: 'muli',
                                    fontSize: 17,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 8),

                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Container(
                                height: height - 300,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    )
                                ),
                                child: rich_text_editor_type_1(controller: controller, height: height - 300,),
                              ),
                            ),

                            Container(height: 10,),
                          ],
                        ),
                      ),

                      Container(height: 5,),

                      Container(
                        height: 50,
                        child: Row(
                          children: [
                            GestureDetector(
                              child: Container(
                                width: 200,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                ),
                                child: !loading ? Center(
                                  child: Text(
                                    'Thêm sản phẩm mới',
                                    style: TextStyle(
                                      fontFamily: 'muli',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ) : Container(width: 15, height: 15, child: CircularProgressIndicator(color: Colors.white),),
                              ),
                              onTap: () async {
                                if (check_if_fill_all()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  String id = (DateTime.now().hour >= 10 ? DateTime.now().hour.toString() : '0' + DateTime.now().hour.toString()) + (DateTime.now().minute >= 10 ? DateTime.now().minute.toString() : '0' + DateTime.now().minute.toString()) + (DateTime.now().second >= 10 ? DateTime.now().second.toString() : '0' + DateTime.now().second.toString()) + (DateTime.now().day >= 10 ? DateTime.now().day.toString() : '0' + DateTime.now().day.toString()) + (DateTime.now().month >= 10 ? DateTime.now().month.toString() : '0' + DateTime.now().month.toString()) + (DateTime.now().year >= 10 ? DateTime.now().year.toString() : '0' + DateTime.now().year.toString());
                                  product.id = 'SP' + id;
                                  product.description = await controller.getText();
                                  product.name = nameController.text.toString();
                                  product.createTime = getCurrentTime();
                                  //Xử lý upload ảnh lên supabase để lấy url
                                  for (int i  = 0; i < product.imageList.length; i++) {
                                    String uploadURL = await uploadBase64Image(base64Data: product.imageList[i], folder: 'productImage/' + product.id);
                                    product.imageList[i] = uploadURL;
                                  }
                                  for (int i  = 0; i < product.dimensionList.length; i++) {
                                    String uploadURL = await uploadBase64Image(base64Data: product.dimensionList[i].image, folder: 'productImage/' + product.id);
                                    product.dimensionList[i].image = uploadURL;
                                  }
                                  //Xử lý xong
                                  await push_new_product(product);
                                  setState(() {
                                    loading = false;
                                  });
                                  toastMessage('Tạo sản phẩm thành công');
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => main_manager_screen()),);
                                } else {
                                  toastMessage('Vui lòng hoàn thành đầy đủ các thông tin');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
