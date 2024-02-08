import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../presentation/screen/dashboard/models/item_model.dart';

class SqlService {
  Database? db;

  Future<bool> openDB() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'shopping.db');

      db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          this.db = db;
          await createTables();
        },
      );
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error opening database: $e');
      }
      return false;
    }
  }

  Future<void> createTables() async {
    try {
      var qry = "CREATE TABLE IF NOT EXISTS shopping ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "image TEXT,"
          "price REAL,"
          "datetime DATETIME)";
      await db?.execute(qry);

      /// Create 'cart_list' table
      qry = "CREATE TABLE IF NOT EXISTS cart_list ("
          "id INTEGER PRIMARY KEY,"
          "shop_id INTEGER,"
          "name TEXT,"
          "image TEXT,"
          "price REAL,"
          "datetime DATETIME)";
      await db?.execute(qry);
    } catch (e) {
      if (kDebugMode) {
        print('Error creating tables: $e');
      }
    }
  }

  Future<int> saveRecord(ShopItemModel data) async {
    if (db == null || !db!.isOpen) {
      /// Handle the case where the database is not open.
      return -1;
    }

    return await db!.transaction((txn) async {
      /// Use parameterized query
      var qry = 'INSERT INTO shopping(name, price, image) VALUES (?, ?, ?)';
      int id1 = await txn.rawInsert(qry, [data.name, data.price, data.image]);
      return id1;
    });
  }

  Future<List<Map<String, dynamic>>> getItemsRecord() async {
    try {
      if (db == null || !db!.isOpen) {
        // Handle the case where the database is not open.
        return [];
      }

      var list = await db?.rawQuery('SELECT * FROM shopping', []);
      return list ?? [];
    } catch (e) {
      if (kDebugMode) {
        print('Error retrieving items: $e');
      }

      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCartList() async {
    try {
      if (db == null || !db!.isOpen) {
        /// Handle the case where the database is not open.
        return [];
      }

      var list = await db?.rawQuery('SELECT * FROM cart_list', []);
      return list ?? [];
    } catch (e) {
      if (kDebugMode) {
        print('Error retrieving cart list: $e');
      }
      return [];
    }
  }

  Future<int> addToCart(ShopItemModel data) async {
    if (db == null || !db!.isOpen) {
      /// Handle the case where the database is not open.
      return -1;
    }

    return await db!.transaction((txn) async {
      /// Use parameterized query
      var qry =
          'INSERT INTO cart_list(shop_id, name, price, image ) VALUES(?, ?, ?, ?)';
      int id1 = await txn
          .rawInsert(qry, [data.id, data.name, data.price, data.image]);
      return id1;
    });
  }

  Future<int> removeFromCart(int shopId) async {
    if (db == null || !db!.isOpen) {
      /// Handle the case where the database is not open.
      return -1;
    }

    var qry = "DELETE FROM cart_list WHERE shop_id = ?";
    return await db!.rawDelete(qry, [shopId]);
  }

  Future<void> close() async {
    if (db != null && db!.isOpen) {
      await db!.close();
    }
  }
}
