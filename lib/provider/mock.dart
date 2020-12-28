import 'package:sqliteapp/model/coin.dart';
import 'package:sqliteapp/database/database.dart';
import 'package:dio/dio.dart';

class TodoApiProvider {
  Future<List<Coin>> getAllTodos() async {
    var url = "6d519adf-0a0d-4a62-9784-6fd765088f38.mock.pstmn"
        ".io/coins";
    Response response = await Dio().get(url);

    return (response.data as List).map((todo) {
      print('Inserting $todo');
      DatabaseProvider.dbProvider.addCoin(todo);
    }).toList();
  }
}
