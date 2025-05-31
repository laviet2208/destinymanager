import 'dart:convert';
import 'dart:typed_data';
import 'package:destinymanager/data/product/Dimension.dart';
import 'package:destinymanager/screen/manager_screen/product_manager/product_list/controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../../data/product/Product.dart';
import '../../../../../../general_ingredient/textfield_type_1.dart';
import '../../../../../../general_ingredient/utils.dart';

class update_dimension extends StatefulWidget {
  final int index;
  final Product product;
  const update_dimension({super.key, required this.index, required this.product,});

  @override
  State<update_dimension> createState() => _update_dimensionState();
}

class _update_dimensionState extends State<update_dimension> {
  bool loading = false;
  final nameController = TextEditingController();
  final costController = TextEditingController();
  final costSaleController = TextEditingController();
  final inventoryController = TextEditingController();
  Uint8List? imageMain;
  Future<Uint8List?> galleryImagePicker() async {
    Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
    return bytesFromPicker;
  }

  bool areValuesValid() {
    // Lấy giá trị từ các controller
    String costText = costController.text.toString();
    String costSaleText = costSaleController.text.toString();
    String inventoryText = inventoryController.text.toString();

    // Chuyển đổi sang double, kiểm tra nếu hợp lệ và lớn hơn 0
    double? cost = double.tryParse(costText);
    double? costSale = double.tryParse(costSaleText);
    int? inventory = int.tryParse(inventoryText);

    // Kiểm tra cả hai giá trị đều lớn hơn 0
    if (cost != null && cost > 0 && costSale != null && costSale > 0 && inventory != null && inventory >= 0) {
      return true;
    } else {
      return false;
    }
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.product.dimensionList[widget.index].name;
    costController.text = widget.product.dimensionList[widget.index].cost.toString();
    costSaleController.text = widget.product.dimensionList[widget.index].costBfSale.toString();
    inventoryController.text = widget.product.dimensionList[widget.index].inventory.toStringAsFixed(0);
    // imageMain =  Uint8List.fromList(base64Decode(widget.product.dimensionList[widget.index].image));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      title: Text('Thêm kích cỡ sản phẩm'),
      backgroundColor: Colors.white,
      content: Container(
        width: width/4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: textfield_type_1(title: 'Tên kích cỡ', hint: 'Nhập tên kích cỡ', controller: nameController),
            ),

            Container(height: 10,),

            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: textfield_type_1(title: 'Giá tiền kích cỡ(USDT)', hint: 'Nhập giá tiền kích cỡ(Chỉ nhập số)', controller: costController),
            ),

            Container(height: 10,),

            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: textfield_type_1(title: 'Giá tiền trước giảm(USDT)', hint: 'Nhập giá tiền trước giảm(Chỉ nhập số)', controller: costSaleController),
            ),

            Container(height: 10,),

            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: textfield_type_1(title: 'Số lượng trong kho', hint: 'Nhập sl trong kho(Chỉ nhập số)', controller: inventoryController),
            ),

            Container(height: 10,),

            Text(
              'Hình ảnh của kích cỡ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                fontFamily: 'muli',
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),

            Container(height: 10,),

            Container(
              height: 100,
              alignment: Alignment.center,
              child: GestureDetector(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(5),
                    child: Center(
                      child: imageMain == null ? Image.network(
                        widget.product.dimensionList[widget.index].image,
                        fit: BoxFit.fill,
                        height: 100,
                        width: 100,
                      ) : Image.memory(
                        imageMain!,
                        fit: BoxFit.fill,
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  final Uint8List? image = await galleryImagePicker();

                  if (image != null) {
                    Uint8List? registrationImage;
                    registrationImage = image;
                    imageMain = registrationImage;
                    toastMessage('Thêm ảnh thành công');
                    setState(() {});
                  }
                },
              ),
            ),

            Container(height: 10,),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            if (areValuesValid() && nameController.text.isNotEmpty) {
              setState(() {
                loading = true;
              });
              widget.product.dimensionList[widget.index].name = nameController.text.toString();
              widget.product.dimensionList[widget.index].cost = double.parse(costController.text.toString());
              widget.product.dimensionList[widget.index].costBfSale = double.parse(costSaleController.text.toString());
              if (imageMain != null) {
                widget.product.dimensionList[widget.index].image = base64Encode(imageMain!);
                String uploadURL = await uploadBase64Image(base64Data: widget.product.dimensionList[widget.index].image, folder: 'productImage/' + widget.product.id);
                widget.product.dimensionList[widget.index].image = uploadURL;
              }
              widget.product.dimensionList[widget.index].inventory = int.parse(inventoryController.text.toString());
              await product_manager_controller.change_productDimension(widget.product);
              toastMessage('Sửa thành công');
              setState(() {
                loading = false;
              });
              Navigator.of(context).pop();
            } else {
              toastMessage('Vui lòng kiểm tra lại các giá trị');
            }
          },
          child: Text('Thêm kích cỡ', style: TextStyle(color: Colors.blueAccent,),),
        ),

        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Hủy', style: TextStyle(color: Colors.redAccent,),),
        ),
      ],
    );
  }
}
