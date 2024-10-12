class Dimension {
  String name;
  String image;
  int inventory;
  double cost;
  double costBfSale;

  Dimension({required this.name, required this.cost, required this.costBfSale, required this.image, required this.inventory});

  Map<dynamic, dynamic> toJson() => {
    'name': name,
    'image': image,
    'inventory': inventory,
    'cost': cost,
    'costBfSale': costBfSale,
  };

  factory Dimension.fromJson(Map<dynamic, dynamic> json) {
    return Dimension(
      name: json['name'].toString(),
      image: json['image'].toString(),
      inventory: int.parse(json['inventory'].toString()),
      cost: double.parse(json['cost'].toString()),
      costBfSale: double.parse(json['costBfSale'].toString()),
    );
  }
}