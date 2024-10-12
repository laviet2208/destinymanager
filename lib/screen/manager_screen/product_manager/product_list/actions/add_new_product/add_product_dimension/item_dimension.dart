import 'package:destinymanager/data/otherData/Tool.dart';
import 'package:destinymanager/data/product/Dimension.dart';
import 'package:destinymanager/screen/manager_screen/product_manager/product_list/actions/add_new_product/add_product_dimension/edit_product_dimension.dart';
import 'package:flutter/material.dart';

class item_dimension extends StatelessWidget {
  final Dimension dimension;
  final int index;
  final VoidCallback deleteEvent;
  final VoidCallback editEvent;
  const item_dimension({super.key, required this.dimension, required this.index, required this.deleteEvent, required this.editEvent});

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 60)/4 - 30;
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.white : Color.fromARGB(255, 247, 250, 255),
        border: Border.all(
          color: Colors.black,
          width: 0.5,
        ),
      ),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            width: width/3 - 1,
            child: Center(
              child: Text(
                dimension.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'muli',
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Container(width: 1, decoration: BoxDecoration(color: Colors.black),),

          Container(
            width: width/3 - 1,
            child: Center(
              child: Text(
                getStringNumber(dimension.cost) + '.Usdt',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'muli',
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Container(width: 1, decoration: BoxDecoration(color: Colors.black),),

          Container(
            width: width/3 - 1,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Icon(
                      Icons.delete_outline_sharp, color: Colors.red,
                      size: 20,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Xác nhận xóa'),
                            content: Text('Xác nhận xóa kích cỡ này?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Không', style: TextStyle(color: Colors.red,),),
                              ),
                              TextButton(
                                onPressed: deleteEvent,
                                child: Text('Có', style: TextStyle(color: Colors.blueAccent,),),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),

                  SizedBox(width: 5,),

                  GestureDetector(
                    child: Icon(
                      Icons.edit, color: Colors.black,
                      size: 20,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return edit_product_dimension(dimension: dimension, event: editEvent);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
