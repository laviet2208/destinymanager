import 'dart:math';
import '../cartData/CartData.dart';
import '../orderData/Order.dart';
import '../product/Dimension.dart';
import '../voucherData/Voucher.dart';
import 'Time.dart';

Time getCurrentTime() {
  DateTime now = DateTime.now();

  Time currentTime = Time(second: 0, minute: 0, hour: 0, day: 0, month: 0, year: 0);
  currentTime.second = now.second;
  currentTime.minute = now.minute;
  currentTime.hour = now.hour;
  currentTime.day = now.day;
  currentTime.month = now.month;
  currentTime.year = now.year;

  return currentTime;
}

// double calculatetotalMoney(Order order) {
//   double cost = 0;
//   for (Cartdata cartdata in order.productList) {
//     cost = cost + cartdata.product.cost * cartdata.number;
//   }
//   return cost;
// }
//
// double getVoucherSale(Voucher voucher, double cost) {
//   double money = 0;
//
//   if(voucher.Money < 100) {
//     double mn = cost * voucher.Money/100;
//     if (mn <= voucher.maxSale) {
//       money = mn;
//     } else {
//       money = voucher.maxSale;
//     }
//   } else {
//     money = voucher.Money;
//   }
//
//   return money;
// }

int calculateDiscountPercentage(double originalPrice, double discountedPrice) {
  // Tính phần trăm giảm giá
  double discount = ((originalPrice - discountedPrice) / originalPrice) * 100;
  // Làm tròn về số nguyên
  return discount.round();
}



double calculatetotalMoney(Order order) {
  double cost = 0;
  for (Cartdata cartdata in order.productList) {
    cost = cost + cartdata.dimension.cost * cartdata.number;
  }
  return cost;
}

double getVoucherSale(Voucher voucher, double cost) {
  double money = 0;

  if(voucher.maxSale != 0) {
    double mn = cost * voucher.Money/100;
    if (mn <= voucher.maxSale) {
      money = mn;
    } else {
      money = voucher.maxSale;
    }
  } else {
    money = voucher.Money;
  }

  return money;
}

String getCostBeforeSaleString(List<Dimension> list) {
  String costString = '';
  double maxCostBf = 0;
  double minCostBf = list.first.costBfSale;
  for (int i = 0; i < list.length; i++) {
    if (list[i].costBfSale > maxCostBf) {
      maxCostBf = list[i].costBfSale;
    }

    if (list[i].costBfSale < minCostBf) {
      minCostBf = list[i].costBfSale;
    }
  }
  if (maxCostBf != 0 && minCostBf != 0) {
    costString = getStringNumber(maxCostBf) + ' - ' + getStringNumber(minCostBf) + '.USDT';
  }

  if (maxCostBf == 0 && minCostBf != 0) {
    costString = getStringNumber(minCostBf) + '.USDT';
  }

  if (maxCostBf != 0 && minCostBf == 0) {
    costString = getStringNumber(maxCostBf) + '.USDT';
  }

  if (maxCostBf == minCostBf && maxCostBf != 0) {
    costString = getStringNumber(maxCostBf) + '.USDT';
  }

  return costString;
}

String getCostString(List<Dimension> list) {
  String costString = '';
  double maxCost = 0;
  double minCost = list.first.cost;
  for (int i = 0; i < list.length; i++) {
    if (list[i].cost > maxCost) {
      maxCost = list[i].cost;
    }

    if (list[i].cost < minCost) {
      minCost = list[i].cost;
    }
  }

  if (maxCost != 0 && minCost != 0) {
    costString = getStringNumber(maxCost) + ' - ' + getStringNumber(minCost) + '.USDT';
  }

  if (maxCost == 0 && minCost != 0) {
    costString = getStringNumber(minCost) + '.USDT';
  }

  if (maxCost != 0 && minCost == 0) {
    costString = getStringNumber(maxCost) + '.USDT';
  }

  if (maxCost == minCost) {
    costString = getStringNumber(maxCost) + '.USDT';
  }

  return costString;
}

String generateID(int count) {
  final character = "0123456789";
  var returnString = "";
  final length = count;
  final random = Random();
  var text = List.generate(length, (index) => character[random.nextInt(character.length)]);

  for (var i = 0 ; i < text.length ; i++) {
    returnString += text[i];
  }

  return returnString;
}

String getAllTimeString(Time time) {
  return (time.hour >= 10 ? time.hour.toString() : '0' + time.hour.toString()) + ":" + (time.minute >= 10 ? time.minute.toString() : '0' + time.minute.toString()) + " " + (time.day >= 10 ? time.day.toString() : '0' + time.day.toString()) + "/" + (time.month >= 10 ? time.month.toString() : '0' + time.month.toString()) + "/" + time.year.toString();
}

String getDayTimeString(Time time) {
  return (time.day >= 10 ? time.day.toString() : '0' + time.day.toString()) + "/" + (time.month >= 10 ? time.month.toString() : '0' + time.month.toString()) + "/" + time.year.toString();
}

List<String> generateSearchKeywords(String name) {
  List<String> keywords = [];
  String lowerCaseName = name.toLowerCase();
  for (int i = 0; i < lowerCaseName.length; i++) {
    for (int j = i + 1; j <= lowerCaseName.length; j++) {
      keywords.add(lowerCaseName.substring(i, j));
    }
  }
  return keywords;
}

String getStringNumber(double number) {
  String result = number.toStringAsFixed(0); // làm tròn số
  result = result.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},'); // chuyển đổi phân tách hàng nghìn
  return result;
}