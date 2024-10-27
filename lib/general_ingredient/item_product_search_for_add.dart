import 'dart:convert';
import 'dart:typed_data';
import 'package:destinymanager/data/otherData/Tool.dart';
import 'package:destinymanager/data/product/Product.dart';
import 'package:flutter/material.dart';

class item_product_search_for_add extends StatelessWidget {
  final Product product;
  const item_product_search_for_add({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    Uint8List image = Uint8List.fromList(base64Decode(product.imageList.first));
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: MemoryImage(image),
              )
            ),
          ),
          
          SizedBox(width: 10,),
          
          Expanded(
            child: Container(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Text(product.name),
                  Text(getCostString(product.dimensionList), style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
