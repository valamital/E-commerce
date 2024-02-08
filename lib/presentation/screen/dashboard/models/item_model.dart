
import '../../../../core/utiles/image_constant.dart';

var data = [
  {
    "name": "Apple i phone 14",
    "price":698.79,
    "image":ImageConstant.imagePathIphone
  },
  {
    "name": "nord CE 2 lite",
    "price": 216.86,
    "image":ImageConstant.imagePathOneplus
  },
  {
    "name": "vivo",
    "price": 445.77,
    "image":ImageConstant.imagePathvivo
  },
  {
    "name": "Redmi",
    "price": 240.97,
    "image":ImageConstant.imagePathRedmi
  },

];

class ShopItemModel {
  String? name;
  double? price;
  String? image;
  int? id;
  int? shopId;

  ShopItemModel(
      {this.shopId,
      required this.id,
      required this.price,
      required this.image,
      required this.name});

  factory ShopItemModel.fromJson(Map<String, dynamic> json) {
    return ShopItemModel(
      id: json['id'],
      price: json['price'],
      image: json['image'],
      name: json['name'],
      shopId: json['shop_id'] ?? 0,
    );
  }
}
