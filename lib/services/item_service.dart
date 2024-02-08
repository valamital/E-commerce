import 'package:e_commarce_app_demo/services/sql_service.dart';
import 'package:e_commarce_app_demo/services/storage_service.dart';

import '../presentation/screen/dashboard/models/item_model.dart';

class ItemServices {
  SqlService sqlService = SqlService();
  StorageService storageService = StorageService();
  List<ShopItemModel> shoppingList = [];

  List<ShopItemModel> getShoppingItems() {
    int count = 0;
    shoppingList.addAll(data.map((element) {
      element['id'] = count++;
      return ShopItemModel.fromJson(element);
    }));
    return shoppingList;
  }

  List<ShopItemModel> get items => getShoppingItems();

  Future openDB() async {
    return await sqlService.openDB();
  }

  loadItems() async {
    bool isFirst = await isFirstTime();

    if (isFirst) {
      List items = await getLocalDBRecord();
      return items;
    } else {
      List items = await saveToLocalDB();
      return items;
    }
  }

  Future<bool> isFirstTime() async {
    return await storageService.getItem("isFirstTime") == 'true';
  }

  Future saveToLocalDB() async {
    await Future.forEach(items, (ShopItemModel item) async {
      await sqlService.saveRecord(item);
    });

    storageService.setItem("isFirstTime", "true");

    return getLocalDBRecord();
  }

  Future getLocalDBRecord() async {
    return await sqlService.getItemsRecord();
  }

  Future addToCart(ShopItemModel data) async {
    return await sqlService.addToCart(data);
  }

  Future getCartList() async {
    return await sqlService.getCartList();
  }

  removeFromCart(int shopId) async {
    return await sqlService.removeFromCart(shopId);
  }
}
