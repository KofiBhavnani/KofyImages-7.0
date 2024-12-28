
import 'package:kofyimages/cart_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DBHelper {
static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;

    _db = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cart.db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }



  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart (id INTEGER PRIMARY KEY AUTOINCREMENT, productId STRING , productImage STRING, productPrice STRING, quantity INTEGER, productColor STRING,  productSize STRING , productSubtotal STRING, productTotalPrice STRING )');
  }

  Future<int> insert(Cart cart) async {
    final Database db = await initDatabase();
    var result = await db.insert('cart', cart.toMap());
    return result;
  }

  Future<List<Cart>> getCartList() async {
    final Database db = await initDatabase();
    final queryResult = await db.rawQuery('SELECT * from cart');
    return queryResult.map((e) => Cart.fromMap(e)).toList();
  }

  Future<int> delete(int? id) async {
    final Database db = await initDatabase();
    return await db.delete('cart', where: 'id= ?', whereArgs: [id]);
  }

  Future<int> update(Cart cart) async {
    final Database db = await initDatabase();
    return await db.update('cart', cart.toMap(), where: 'id= ?', whereArgs: [cart.id]);
  }

  Future<int> deleteAll() async {
    final Database db = await initDatabase();
    return await db.rawDelete('DELETE FROM cart');
  }



  
}
