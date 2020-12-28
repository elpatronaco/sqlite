import 'dart:async';

import 'package:sqliteapp/database/database.dart';
import 'package:sqliteapp/model/coin.dart';

class TodoDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Todo records
  Future<int> createTodo(Coin coin) async {
    final db = await dbProvider.database;
    var result = db.insert(todoTABLE, coin.toDatabaseJson());
    return result;
  }

  //Get All Todo items
  //Searches if query string was passed
  Future<List<Coin>> getTodos({List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(todoTABLE,
            columns: columns,
            where: 'description LIKE ?',
            whereArgs: ["%$query%"]);
    } else {
      result = await db.query(todoTABLE, columns: columns);
    }

    List<Coin> coins = result.isNotEmpty
        ? result.map((item) => Coin.fromDatabaseJson(item)).toList()
        : [];
    return coins;
  }

  //Update Todo record
  Future<int> updateTodo(Coin coin) async {
    final db = await dbProvider.database;

    var result = await db.update(todoTABLE, coin.toDatabaseJson(),
        where: "id = ?", whereArgs: [coin.id]);

    return result;
  }

  //Delete Todo records
  Future<int> deleteTodo(String id) async {
    final db = await dbProvider.database;
    var result = await db.delete(todoTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllTodos() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      todoTABLE,
    );

    return result;
  }
}
